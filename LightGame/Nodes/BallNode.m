#import "BallNode.h"

@implementation BallNode

+ (instancetype)create {
    BallNode *ball = [self node];
    ball.name = @"ball";
    int ballRadius = 7;
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ballRadius];
    ball.physicsBody.restitution = 0.85;
    ball.physicsBody.linearDamping = 0.6;
    SKShapeNode *ballShape = [SKShapeNode shapeNodeWithCircleOfRadius:ballRadius];
    [ballShape setFillColor:[UIColor darkGrayColor]];
    [ball addChild:ballShape];
    return ball;
}

- (void)hitInDirection:(CGVector)vector withPercentOfMaxForce:(double)forcePercent {
    forcePercent = forcePercent < 0.1 ? 0.1 : forcePercent;
    double maxForce = 250;

    double angle = atan2(vector.dy, vector.dx);
    double xForce = maxForce * forcePercent * cos(angle);
    double yForce = maxForce * forcePercent * sin(angle);
    [self.physicsBody applyForce:CGVectorMake((CGFloat) xForce, (CGFloat) yForce)];
}

@end