#import "BallNode.h"
#import "ContactCategories.h"

const int BALL_RADIUS = 7;

@implementation BallNode

+ (instancetype)create {
    BallNode *ball = [self node];
    ball.name = @"ball";
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:BALL_RADIUS];
    ball.physicsBody.restitution = 0.85;
    ball.physicsBody.linearDamping = 0.6;
    ball.physicsBody.collisionBitMask = CollisionBallAndHole;
    ball.physicsBody.categoryBitMask = CategoryBall;
    SKShapeNode *ballShape = [SKShapeNode shapeNodeWithCircleOfRadius:BALL_RADIUS];
    [ballShape setFillColor:[UIColor darkGrayColor]];
    [ball addChild:ballShape];
    return ball;
}

- (void)hitInDirection:(CGVector)vector withPercentOfMaxForce:(double)forcePercent {
    forcePercent = forcePercent < 0.1 ? 0.1 : forcePercent;
    double maxForce = 200;

    double angle = atan2(vector.dy, vector.dx);
    double xForce = maxForce * forcePercent * cos(angle);
    double yForce = maxForce * forcePercent * sin(angle);
    [self.physicsBody applyForce:CGVectorMake((CGFloat) xForce, (CGFloat) yForce)];
}

- (void)adjustAimForTouch:(UITouch *)touch {
    CGPoint point = [touch locationInNode:self];
    CGFloat angle = (CGFloat) atan2f(point.y, point.x);
    [self childNodeWithName:@"aim"].zRotation = (CGFloat) (angle + M_PI_2);
}

@end