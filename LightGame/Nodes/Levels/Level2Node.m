#import "Level2Node.h"
#import "ContactCategories.h"

@implementation Level2Node

- (UIBezierPath *)groundPath {
    UIBezierPath *bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint:CGPointMake(39.35, 215.34)];
    [bezierPath addCurveToPoint:CGPointMake(147.34, 107.66) controlPoint1:CGPointMake(39.34, 215.34) controlPoint2:CGPointMake(147.34, 107.66)];
    [bezierPath addLineToPoint:CGPointMake(39.69, 0)];
    [bezierPath addLineToPoint:CGPointMake(0.84, 38.84)];
    [bezierPath addLineToPoint:CGPointMake(69.5, 107.5)];
    [bezierPath addLineToPoint:CGPointMake(0.5, 176.5)];
    [bezierPath addLineToPoint:CGPointMake(39.34, 215.34)];
    [bezierPath closePath];

    CGFloat scale = 4;
    [bezierPath applyTransform:CGAffineTransformMakeScale(scale, scale)];
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(-150, -150)];
    return bezierPath;
}

- (CGPoint)initialBallPosition {
    return CGPointMake(0, 0);
}

- (CGPoint)holePosition {
    return CGPointMake(0, 565);
}

@end