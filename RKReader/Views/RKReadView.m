//
//  RKReadView.m
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadView.h"
#import "CoreText/CoreText.h"

@implementation RKReadView

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
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    // 步骤 4
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Hello World!"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    // 步骤 5
    CTFrameDraw(frame, context);
    // 步骤 6
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}


@end
