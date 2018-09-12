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

- (RKReadProgress *)readProgress {
	if (!_readProgress) {
		_readProgress = [RKReadProgress new];
	}
	return _readProgress;
}

#pragma mark - 类方法
/**
 根据初始化
 @param listBook 文件信息
 @return 书籍对象
 */
+ (instancetype)getLocalModelWithHomeBook:(RKHomeListBooks *)listBook {
	
	NSString *fileURL = [listBook.fileInfo.filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *key = [fileURL lastPathComponent];
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	
	if (!data) {
		RKBook *book = [[RKBook alloc] initWithContent:[RKFileManager encodeWithFilePath:fileURL]];
		
		book.name = listBook.fileInfo.fileName;
		RKReadProgress *readProgress = [RKReadProgress new];
		readProgress.progress = 0.0f;
		readProgress.chapter = 0;
		readProgress.page = 0;
		book.readProgress = readProgress;
		book.filePath = listBook.fileInfo.filePath;
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
