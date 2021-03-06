//
//  RKModel.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKModel.h"
#import <objc/runtime.h>

@implementation RKModel

#pragma mark - 编码/解码
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }

/**
 描述对象
 
 @return 对象的描述
 */
- (NSString *)description {
    //得到当前class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableString *str = [NSMutableString string];
    
    //循环并用KVC得到每个属性的值
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ? : @"nil";//默认值为nil字符串
        [str appendString:[NSString stringWithFormat:@" <%@:%@> ",name,value]];
    }
    
    //释放
    free(properties);
    
    //return
    return [NSString stringWithFormat:@"<%@ : %p> %@",[self class],self,str];
}

@end
