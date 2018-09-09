//
//  RKReadView.m
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadView.h"

@interface RKReadView ()

@property (nonatomic,assign) CTFrameRef frameRef;

@end

@implementation RKReadView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)dealloc {
	if (_frameRef) {
		CFRelease(_frameRef);
		_frameRef = nil;
	}
}

#pragma mark - drawRect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // 步骤 1
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 步骤 2
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // 步骤 3
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
    // 步骤 4
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.content];
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
//                             CFRangeMake(0, [attString length]), path, NULL);
    // 步骤 5
//    CTFrameDraw(frame, context);
	CTFrameDraw(_frameRef, context);
    // 步骤 6
//    CFRelease(frame);
//    CFRelease(path);
//    CFRelease(framesetter);
}

#pragma mark - setting
- (void)setFrameRef:(CTFrameRef)frameRef {
	if (_frameRef != frameRef) {
		if (_frameRef) {
			CFRelease(_frameRef);
			_frameRef = nil;
		}
		_frameRef = frameRef;
	}
}

- (void)setContent:(NSString *)content {
	_content = content;
	self.frameRef = [RKFileManager parserContent:self.content];
}

@end
