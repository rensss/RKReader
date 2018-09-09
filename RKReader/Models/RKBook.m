//
//  RKBook.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKBook.h"

@interface RKBook ()

@end

@implementation RKBook

@synthesize fileInfo = _fileInfo;

#pragma mark - 初始化
- (instancetype)initWithContent:(NSString *)content {
	self = [super init];
	if (self) {
		_content = content;
		NSMutableArray *charpter = [NSMutableArray array];
		[RKFileManager separateChapter:&charpter content:content];
		_chapters = [NSMutableArray arrayWithArray:charpter];
	}
	return self;
}

#pragma mark - 编码/解码
- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeObject:self.content forKey:@"content"];
	[aCoder encodeObject:@(self.progress) forKey:@"progress"];
	[aCoder encodeObject:self.coverName forKey:@"coverName"];
	[aCoder encodeObject:self.chapters forKey:@"chapters"];
	[aCoder encodeObject:self.fileInfo forKey:@"fileInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		self.name = [aDecoder decodeObjectForKey:@"name"];
		self.progress = [[aDecoder decodeObjectForKey:@"progress"] floatValue];
		self.coverName = [aDecoder decodeObjectForKey:@"coverName"];
		self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
		self.fileInfo = [aDecoder decodeObjectForKey:@"fileInfo"];
	}
	return self;
}

#pragma mark - getting
- (RKFile *)fileInfo {
    if (!_fileInfo) {
        _fileInfo = [RKFile new];
    }
    return _fileInfo;
}
#pragma mark - setting
- (void)setFileInfo:(RKFile *)fileInfo {
	_fileInfo = fileInfo;
}

#pragma mark - 类方法
+ (instancetype)getLocalModelWithURL:(NSURL *)url {
	NSString *key = [url.path lastPathComponent];
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if (!data) {
		if ([[key pathExtension] isEqualToString:@"txt"]) {
			RKBook *book = [[RKBook alloc] initWithContent:[RKFileManager encodeWithURL:url]];
			book.progress = 0.0;
			book.coverName = [NSString stringWithFormat:@"cover%d",arc4random()%10+1];
			return book;
		} else {
			@throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
		}
	}
	NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	//主线程操作
	RKBook *model = [unarchive decodeObjectForKey:key];
	return model;
}

@end
