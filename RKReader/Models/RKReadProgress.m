//
//  RKReadProgress.m
//  RKReader
//
//  Created by RZK on 2018/9/9.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadProgress.h"

@implementation RKReadProgress

#pragma mark - 编码/解码
- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:@(self.progress) forKey:@"progress"];
	[aCoder encodeObject:@(self.chapter) forKey:@"chapter"];
	[aCoder encodeObject:@(self.page) forKey:@"page"];
	[aCoder encodeObject:self.title forKey:@"title"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		self.progress = [[aDecoder decodeObjectForKey:@"progress"] floatValue];
		self.chapter = [[aDecoder decodeObjectForKey:@"chapter"] integerValue];
		self.page = [[aDecoder decodeObjectForKey:@"page"] integerValue];
		self.title = [aDecoder decodeObjectForKey:@"title"];
	}
	return self;
}

@end
