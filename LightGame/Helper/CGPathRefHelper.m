#import "CGPathRefHelper.h"

@implementation CGPathRefHelper

+ (CGPathRef)pathForTriangleOfSize:(CGSize)size {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, size.height / 2);
    CGPathAddLineToPoint(path, nil, size.width / 2, -size.height / 2);
    CGPathAddLineToPoint(path, nil, -size.width / 2, -size.height / 2);
    CGPathAddLineToPoint(path, nil, 0, size.height / 2);
    return path;
}

@end