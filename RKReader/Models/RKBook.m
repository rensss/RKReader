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


#pragma mark - getting
- (RKFile *)fileInfo {
    if (!_fileInfo) {
        _fileInfo = [RKFile new];
    }
    return _fileInfo;
}

- (RKReadProgress *)readProgress {
	if (!_readProgress) {
		_readProgress = [RKReadProgress new];
	}
	return _readProgress;
}

#pragma mark - setting
- (void)setFileInfo:(RKFile *)fileInfo {
	_fileInfo = fileInfo;
}

#pragma mark - 类方法
+ (instancetype)getLocalModelWithFileInfo:(RKFile *)file {
	
	NSString *fileURL = [file.filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *key = [fileURL lastPathComponent];
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	
	if (!data) {
		RKBook *book = [[RKBook alloc] initWithContent:[RKFileManager encodeWithFilePath:fileURL]];
		
		book.name = file.fileName;
		RKReadProgress *readProgress = [RKReadProgress new];
		readProgress.progress = 0.0f;
		readProgress.chapter = 0;
		readProgress.page = 0;
		book.readProgress = readProgress;
		book.coverName = [NSString stringWithFormat:@"cover%d",arc4random()%10+1];
		book.fileInfo = file;
		// 保存到本地
		[RKFileManager archiverBookData:book];
		return book;
	}
	NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	//主线程操作
	RKBook *model = [unarchive decodeObjectForKey:key];
	return model;
}

@end
