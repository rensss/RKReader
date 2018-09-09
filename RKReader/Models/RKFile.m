//
//  RKFile.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKFile.h"

@implementation RKFile

#pragma mark - 编码/解码
- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.fileName forKey:@"name"];
	[aCoder encodeObject:self.filePath forKey:@"filePath"];
	[aCoder encodeObject:self.fileType forKey:@"fileType"];
	[aCoder encodeObject:@(self.fileSize) forKey:@"fileSize"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
		self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
		self.fileType = [aDecoder decodeObjectForKey:@"fileType"];
		self.fileSize = [[aDecoder decodeObjectForKey:@"fileSize"] floatValue];
	}
	return self;
}

@end
