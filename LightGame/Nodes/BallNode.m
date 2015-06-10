#import "BallNode.h"
#import "ContactCategories.h"
#import "AimNode.h"

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
    ball.physicsBody.allowsRotation = NO;
    SKShapeNode *ballShape = [SKShapeNode shapeNodeWithCircleOfRadius:BALL_RADIUS];
    [ballShape setFillColor:[UIColor darkGrayColor]];
    [ball addChild:ballShape];
    return ball;
}

- (void)adjustAimForTouch:(UITouch *)touch {
    CGPoint point = [touch locationInNode:self];
    self.hitAngle = (CGFloat) (atan2f(point.y, point.x) + M_PI);
    [self childNodeWithName:@"aim"].zRotation = (CGFloat) (self.hitAngle + M_PI_2 + M_PI);
}

- (void)startTouch:(UITouch *)touch {
    [self adjustAimForTouch:touch];
    self.startTouchDistanceFromBall = [self radialDistanceFromBall:[touch locationInNode:self]];
}

- (void)touchesMoved:(UITouch *)touch {
    [self adjustAimForTouch:touch];
    self.pullStrength = [self percentPullFrom:touch];
    AimNode *aim = (AimNode *) [self childNodeWithName:@"aim"];
    [aim highlight:self.pullStrength];
}

- (double)percentPullFrom:(const UITouch *)touch {
    double radialDistanceFromBall = [self radialDistanceFromBall:[touch locationInNode:self]];
    double diff = radialDistanceFromBall - self.startTouchDistanceFromBall;
    diff = diff < 0 ? 0 : diff;
    double MAX_PULL = 150;
    return diff / MAX_PULL;
}

- (void)release:(UITouch *)touch {
    self.pullStrength = [self percentPullFrom:touch];
    [self adjustAimForTouch:touch];
    AimNode *aim = (AimNode *) [self childNodeWithName:@"aim"];
    [aim highlight:0];
    [self hit];
}

- (double)radialDistanceFromBall:(CGPoint)point {
    return sqrt(point.y * point.y + point.x * point.x);
}

- (void)hit {
    if (self.pullStrength <= 0) {
        return;
    }

    double minForce = 0.05;
    double forcePercent = self.pullStrength < minForce ? minForce : self.pullStrength;
    double maxForce = 200;

    double xForce = maxForce * forcePercent * cos(self.hitAngle);
    double yForce = maxForce * forcePercent * sin(self.hitAngle);
    [self.physicsBody applyForce:CGVectorMake((CGFloat) xForce, (CGFloat) yForce)];
}
@end