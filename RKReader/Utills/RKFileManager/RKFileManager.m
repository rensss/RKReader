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
+ (void)fileManagerInit {
    BOOL isSuccess = [RKFileManager createDir];
    if (!isSuccess) {
        RKLog(@"文件创建失败!  path=%@",kBookSavePath);
    }else {
        RKLog(@"文件创建成功或已存在!  path=%@",kBookSavePath);
    }
}

#pragma mark - 函数
/// 创建书籍存放文件夹
+ (BOOL)createDir {
    
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

#pragma mark - 文件操作/缓存相关
#pragma mark -- 增
/**
 根据文件地址分配任务
 @param filePath 文件路径
 */
+ (void)threadedTaskAllocationWithFile:(NSString *)filePath {
	dispatch_queue_t myQueue = dispatch_queue_create(kMyConcurrentQueue, DISPATCH_QUEUE_CONCURRENT);
	dispatch_async(myQueue, ^{
		// 更新首页数据
		[RKFileManager updateHomeListData:YES filePath:filePath];
	});
}

/**
 根据路径生成model,然后保存
 @param filePath 文件路径
 */
+ (void)addFileWithFilePath:(NSString *)filePath {
    RKHomeListBooks *listBook = [RKHomeListBooks new];
	
    RKFile *fileInfo = [RKFile new];
    fileInfo.fileName = [filePath componentsSeparatedByString:@"/"].lastObject;
    fileInfo.filePath = filePath;
    fileInfo.fileSize = [RKFileManager getFileSize:filePath];
	
	listBook.key = [fileInfo.fileName md5Encrypt];
	listBook.coverName = [NSString stringWithFormat:@"cover%d",arc4random()%10+1];
	listBook.fileInfo = fileInfo;
	
	RKReadProgress *readProgress = [RKReadProgress new];
	readProgress.title = @"开始";
	listBook.readProgress = readProgress;
    // 保存到首页列表
    [RKFileManager saveHomeListWithListBook:listBook];
	
	// 解析书籍
	RKBook *book = [[RKBook alloc] initWithContent:[RKFileManager encodeWithFilePath:filePath]];
	book.name = fileInfo.fileName;
	book.filePath = filePath;
	[RKFileManager archiverBookData:book withKey:listBook.key];
}

/**
 添加首页列表数据
 @param book 列表书籍数据
 */
+ (void)saveHomeListWithListBook:(RKHomeListBooks *)book {
    
	NSMutableArray *array = [RKFileManager getHomeListBooks];
	if (array.count > 0) {
		[array addObject:book];
	}else {
		array = [NSMutableArray arrayWithObject:book];
	}
	[RKFileManager saveHomeList:array];
}

/**
 保存首页列表
 @param homeList 列表数据
 */
+ (void)saveHomeList:(NSMutableArray *)homeList {
    
    [[NSFileManager defaultManager] removeItemAtPath:kHomeBookListsPath error:nil];
    
    BOOL res = [NSKeyedArchiver archiveRootObject:homeList toFile:kHomeBookListsPath];
	RKLog(@"保存结果 -- %@",res?@YES:@NO);
}


#pragma mark -- 删
/**
 删除单个文件
 @param filePath 文件路径
 */
+ (void)deleteFileWithFilePath:(NSString *)filePath {
    
    // 清除缓存
    [RKFileManager deleteUserDefaultsDataWithFilePath:filePath];
    
    // 删除文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager removeItemAtPath:filePath error:nil];
    RKLog(@"文件是否存在: %@ -- res:%@",[fileManager isExecutableFileAtPath:filePath]?@"YES":@"NO",res?@"YES":@"NO");
}

/**
 删除单个书籍
 @param book 书籍数据
 */
+ (void)deleteHomeListWithHomeList:(RKHomeListBooks *)book {
    
    [RKFileManager deleteFileWithFilePath:book.fileInfo.filePath];
    
    NSMutableArray *array = [RKFileManager getHomeListBooks];
    for (int i = 0; i < array.count; i++) {
        RKHomeListBooks *bookList = array[i];
        if ([book.key isEqualToString:bookList.key]) {
            [array removeObjectAtIndex:i];
            [RKFileManager saveHomeList:array];
            return;
        }
    }
}

/**
 删除全部首页列表数据
 */
+ (void)deleteAllHomeList {
    [[NSFileManager defaultManager] removeItemAtPath:kHomeBookListsPath error:nil];
}

/**
 删除单个缓存文件
 @param filePath 文件路径
 */
+ (void)deleteUserDefaultsDataWithFilePath:(NSString *)filePath {
    
    NSString *fileURL = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *key = [fileURL lastPathComponent];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    
    [userDefaults synchronize];
}

#pragma mark -- 改
/**
 更新首页列表数据
 @param isAdd 是否添加
 @param filePath 文件路径
 */
+ (void)updateHomeListData:(BOOL)isAdd filePath:(NSString *)filePath {
    if (isAdd) {
        [RKFileManager addFileWithFilePath:filePath];
    }else {
        // 删除文件
        [RKFileManager deleteFileWithFilePath:filePath];
    }
}

/**
 更新书籍阅读进度
 @param book 首页列表书籍对象
 */
+ (void)updateHomeListDataWithListBook:(RKHomeListBooks *)book {
	NSMutableArray *array = [RKFileManager getHomeListBooks];
	for (int i = 0; i < array.count; i++) {
		RKHomeListBooks *bookList = array[i];
		if ([book.key isEqualToString:bookList.key]) {
			bookList.readProgress = book.readProgress;
		}
	}
	[RKFileManager saveHomeList:array];
}

#pragma mark -- 查
/**
 获取首页列表书籍数据
 */
+ (NSMutableArray <RKHomeListBooks *> *)getHomeListBooks {
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:kHomeBookListsPath];
    
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return array;
}

#pragma mark -- 缓存管理
/**
 删除全部书籍
 */
+ (void)clearAllBooks {
	// 删除首页列表数据
    [RKFileManager deleteAllHomeList];
	// 删除所有书籍缓存
	[RKFileManager clearAllUserDefaultsData];
	// 删除books下所有数据
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:kBookSavePath];
	NSString *fileName;
	while (fileName = [dirEnum nextObject]) {
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",kBookSavePath,fileName] error:nil];
	}
}

/**
 *  清除所有的存储本地的数据
 */
+ (void)clearAllUserDefaultsData {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *dic = [userDefaults dictionaryRepresentation];
	for (id key in dic) {
		[userDefaults removeObjectForKey:key];
	}
	[userDefaults synchronize];
}

#pragma mark - 数据解析
+ (void)separateChapter:(NSMutableArray * __autoreleasing *)chapters content:(NSString *)content {
	[*chapters removeAllObjects];
	
	// 正则匹配
	NSString *parten = @"(\\s)+[第]{0,1}[0-9一二三四五六七八九十百千万]+[章回节卷集幕计][ \t]*(\\S)*";
	NSError *error = NULL;
	NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
	
	NSArray* match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
	RKLog(@"章节个数 -- %lu",(unsigned long)match.count);
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
		model.title = @"开始";
		model.contentFrame = [RKUserConfiguration sharedInstance].readViewFrame;
		model.content = content;
		[*chapters addObject:model];
	}
}

+ (NSString *)encodeWithFilePath:(NSString *)path {
	
	NSError *error = NULL;
	NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	if (!content) {
		if (error) {
			RKLog(@"NSUTF8StringEncoding -- 解码错误 -- %@",error.domain);
			content = nil;
			error = NULL;
		}
	}
	if (!content) {
		content = [NSString stringWithContentsOfFile:path encoding:0x80000632 error:&error];
		if (error) {
			RKLog(@"GBK -- 解码错误 -- %@",error.domain);
			content = nil;
			error = NULL;
		}
	}
	if (!content) {
		NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
		//文件内容转换成字符串类型
		content = [NSString stringWithContentsOfFile:path encoding:enc error:&error];
		if (error) {
			RKLog(@"kCFStringEncodingGB_18030_2000 -- 解码错误 -- %@",error.domain);
			content = nil;
			error = NULL;
		}
	}
	if (!content) {
		return @"";
	}
	return content;
}

+ (void)archiverBookData:(RKBook *)book withKey:(NSString *)key {
	if (!key) {
		key = [book.name md5Encrypt];
	}
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:book forKey:key];
        [archiver finishEncoding];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    });
}

#pragma mark - 工具
/**
 计算文件的大小，单位为 M
 @param path 文件路径
 @return 大小(M)
 */
+ (CGFloat)getFileSize:(NSString *)path {
    // 转码
    NSString *filePath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    RKLog(@"转码\npath:%@\nfilePath:%@",path,filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0f;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = size/1000.0/1000.0;
    }
    if (filesize == -1.0f) {
        if ([fileManager fileExistsAtPath:filePath]) {
            NSDictionary *fileDic = [fileManager attributesOfItemAtPath:filePath error:nil];//获取文件的属性
            unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
            filesize = size/1000.0/1000.0;
        }
    }
    RKLog(@"文件大小 -- %f",filesize);
    return filesize;
}

@end
