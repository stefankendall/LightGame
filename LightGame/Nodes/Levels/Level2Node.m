#import "Level2Node.h"

@implementation Level2Node

- (void)addGround {
    UIBezierPath *bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint:CGPointMake(39.35, 264.66)];
    [bezierPath addCurveToPoint:CGPointMake(108.34, 333.66) controlPoint1:CGPointMake(39.34, 264.66) controlPoint2:CGPointMake(77.47, 302.78)];
    [bezierPath addCurveToPoint:CGPointMake(108.5, 333.5) controlPoint1:CGPointMake(108.45, 333.55) controlPoint2:CGPointMake(108.5, 333.5)];
    [bezierPath addLineToPoint:CGPointMake(147.34, 372.34)];
    [bezierPath addLineToPoint:CGPointMake(39.69, 480)];
    [bezierPath addLineToPoint:CGPointMake(0.84, 441.16)];
    [bezierPath addCurveToPoint:CGPointMake(69.5, 372.5) controlPoint1:CGPointMake(0.84, 441.16) controlPoint2:CGPointMake(38.69, 403.31)];
    [bezierPath addCurveToPoint:CGPointMake(0.5, 303.5) controlPoint1:CGPointMake(38.63, 341.63) controlPoint2:CGPointMake(0.5, 303.5)];
    [bezierPath addLineToPoint:CGPointMake(39.34, 264.66)];
    [bezierPath addLineToPoint: CGPointMake(39.35, 264.66)];
    [bezierPath closePath];

    CGFloat scale = 4;
    [bezierPath applyTransform:CGAffineTransformMakeScale(scale, scale)];

    SKShapeNode *ground = [SKShapeNode shapeNodeWithPath:bezierPath.CGPath centered:YES];
    ground.position = CGPointMake(0, 0);
    [ground setFillColor:[UIColor whiteColor]];
    [ground setStrokeColor:[UIColor grayColor]];
    int borderWidth = 10;
    [ground setLineWidth:borderWidth];
    ground.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:bezierPath.CGPath];
    ground.physicsBody.dynamic = NO;
    [self addChild:ground];
}

- (CGPoint)initialBallPosition {
    return CGPointMake(0, 0);
}

- (CGPoint)holePosition {
    return CGPointMake(0, 100);
}

@end