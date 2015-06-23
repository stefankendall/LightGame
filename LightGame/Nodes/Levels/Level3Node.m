#import "Level2Node.h"
#import "Level3Node.h"

@implementation Level3Node

- (UIBezierPath *)groundPath {
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(43.5, 49.5)];
    [bezierPath addLineToPoint: CGPointMake(273.5, 49.5)];
    [bezierPath addCurveToPoint: CGPointMake(273.5, 116.5) controlPoint1: CGPointMake(273.5, 49.5) controlPoint2: CGPointMake(322.5, 82.5)];
    [bezierPath addCurveToPoint: CGPointMake(287.5, 222.5) controlPoint1: CGPointMake(224.5, 150.5) controlPoint2: CGPointMake(287.5, 222.5)];
    [bezierPath addCurveToPoint: CGPointMake(227.5, 294.5) controlPoint1: CGPointMake(287.5, 222.5) controlPoint2: CGPointMake(351.5, 316.5)];
    [bezierPath addCurveToPoint: CGPointMake(43.5, 255.5) controlPoint1: CGPointMake(103.5, 272.5) controlPoint2: CGPointMake(43.5, 255.5)];
    [bezierPath addCurveToPoint: CGPointMake(43.5, 181.5) controlPoint1: CGPointMake(43.5, 255.5) controlPoint2: CGPointMake(-38.5, 221.5)];
    [bezierPath addCurveToPoint: CGPointMake(171.5, 181.5) controlPoint1: CGPointMake(125.5, 141.5) controlPoint2: CGPointMake(171.5, 164.5)];
    [bezierPath addCurveToPoint: CGPointMake(123.5, 203.5) controlPoint1: CGPointMake(171.5, 198.5) controlPoint2: CGPointMake(160.5, 225.5)];
    [bezierPath addCurveToPoint: CGPointMake(54.5, 222.5) controlPoint1: CGPointMake(86.5, 181.5) controlPoint2: CGPointMake(54.5, 222.5)];
    [bezierPath addCurveToPoint: CGPointMake(227.5, 255.5) controlPoint1: CGPointMake(54.5, 222.5) controlPoint2: CGPointMake(210.5, 277.5)];
    [bezierPath addCurveToPoint: CGPointMake(227.5, 181.5) controlPoint1: CGPointMake(244.5, 233.5) controlPoint2: CGPointMake(227.5, 181.5)];
    [bezierPath addCurveToPoint: CGPointMake(227.5, 116.5) controlPoint1: CGPointMake(227.5, 181.5) controlPoint2: CGPointMake(206.5, 142.5)];
    [bezierPath addCurveToPoint: CGPointMake(227.5, 88.5) controlPoint1: CGPointMake(248.5, 90.5) controlPoint2: CGPointMake(227.5, 88.5)];
    [bezierPath addLineToPoint: CGPointMake(43.5, 88.5)];
    [bezierPath addLineToPoint: CGPointMake(43.5, 49.5)];
    [bezierPath closePath];

    CGFloat scale = 4;
    [bezierPath applyTransform:CGAffineTransformMakeScale(scale, scale)];
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(-225, -250)];
    return bezierPath;
}

- (CGPoint)initialBallPosition {
    return CGPointMake(0, 0);
}

- (CGPoint)holePosition {
    return CGPointMake(0, 565);
}

@end