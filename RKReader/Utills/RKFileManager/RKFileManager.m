//
//  RKFileManager.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKFileManager.h"
#import "RKBookChapter.h"

@implementation RKFileManager

+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        BOOL isSuccess = [self createDir];
        if (!isSuccess) {
            RKLog(@"文件创建失败!  path=%@",kBookSavePath);
        }else {
            RKLog(@"文件创建成功!  path=%@",kBookSavePath);
        }
    }
    return self;
}

#pragma mark - 函数
/// 创建书籍存放文件夹
- (BOOL)createDir {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    // 先判断目录是否存在，不存在才创建
    if  (![fileManager fileExistsAtPath:kBookSavePath isDirectory:&isDir]) {
        BOOL res = [fileManager createDirectoryAtPath:kBookSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        return res;
    } else {
        // 文件已存在
        return YES;
    }
}
#pragma mark -- 公用函数
- (NSArray *)getBookList {
    NSMutableArray *array = [NSMutableArray array];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    //获取数据
    //①只获取文件名
    NSArray *fileNameArray = [NSMutableArray arrayWithArray:[manager contentsOfDirectoryAtPath:kBookSavePath error:nil]];
    
    for (NSString *fileName in fileNameArray) {
        RKFile *file = [RKFile new];
        file.fileName = fileName;
        file.filePath = [NSString stringWithFormat:@"%@/%@",kBookSavePath,fileName];
        file.fileType = [[fileName componentsSeparatedByString:@"."] lastObject];
        file.fileSize = [self getFileSize:file.filePath];

        [array addObject:file];
    }
    
    return array;
}

/// 计算文件的大小，单位为 M
- (CGFloat)getFileSize:(NSString *)path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = size/1000.0/1000.0;
    }
    return filesize;
}

#pragma mark -- 类函数
+ (void)separateChapter:(NSMutableArray * __autoreleasing *)chapters content:(NSString *)content {
	[*chapters removeAllObjects];
	
	// 正则匹配
	NSString *parten = @"[?【]*第[0-9一二三四五六七八九十百千]*[章回节].*";
	NSError *error = NULL;
	NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
	
	NSArray* match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
	
	if (match.count != 0) {
		__block NSRange lastRange = NSMakeRange(0, 0);
		[match enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			NSRange range = [obj range];
			NSInteger local = range.location;
			if (idx == 0) {
				RKBookChapter *model = [[RKBookChapter alloc] init];
				model.title = @"开始";
				NSUInteger len = local;
				model.contentFrame = [RKUserConfiguration sharedInstance].readViewFrame;
				model.content = [content substringWithRange:NSMakeRange(0, len)];
				[*chapters addObject:model];
			}
			
			if (idx > 0 ) {
				RKBookChapter *model = [[RKBookChapter alloc] init];
				model.title = [content substringWithRange:lastRange];
				NSUInteger len = local-lastRange.location;
				model.contentFrame = [RKUserConfiguration sharedInstance].readViewFrame;
				model.content = [content substringWithRange:NSMakeRange(lastRange.location, len)];
				[*chapters addObject:model];
			}
			
			if (idx == match.count-1) {
				RKBookChapter *model = [[RKBookChapter alloc] init];
				model.title = [content substringWithRange:range];
				model.contentFrame = [RKUserConfiguration sharedInstance].readViewFrame;
				model.content = [content substringWithRange:NSMakeRange(local, content.length-local)];
				[*chapters addObject:model];
			}
			lastRange = range;
		}];
	} else {// 没找出章节
		RKBookChapter *model = [[RKBookChapter alloc] init];
		model.content = content;
		[*chapters addObject:model];
	}
}

+ (NSString *)encodeWithURL:(NSURL *)url {
	if (!url) {
		return @"";
	}
	
	NSError *error = NULL;
	NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	if (!content) {
		if (error) {
			RKLog(@"NSUTF8StringEncoding -- 解码错误 -- %@",error.domain);
			content = nil;
			error = NULL;
		}
	}
	if (!content) {
		content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:&error];
		if (error) {
			RKLog(@"GBK -- 解码错误 -- %@",error.domain);
			content = nil;
			error = NULL;
		}
	}
	if (!content) {
		NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
		//文件内容转换成字符串类型
		content = [[NSString alloc] initWithContentsOfFile:url.path encoding:enc error:&error];
		if (error) {
			RKLog(@"kCFStringEncodingGB_18030_2000 -- 解码错误 -- %@",error.domain);
			content = nil;
			error = NULL;
		}
	}
//	NSLog(@"内容30个字符 \n%@\n",[content substringToIndex:30]);
	if (!content) {
		return @"";
	}
	return content;
}

+ (CTFrameRef)parserContent:(NSString *)content {
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
	NSDictionary *attribute = [[RKUserConfiguration sharedInstance] parserAttribute];
	[attributedString setAttributes:attribute range:NSMakeRange(0, content.length)];
	CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
	CGPathRef pathRef = CGPathCreateWithRect([RKUserConfiguration sharedInstance].readViewFrame, NULL);
	CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
	CFRelease(setterRef);
	CFRelease(pathRef);
	return frameRef;
}

@end
