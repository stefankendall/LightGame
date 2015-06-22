#import "BallNode.h"
#import "ContactCategories.h"
#import "AimNode.h"

const int BALL_RADIUS = 7;

@implementation BallNode

const double GROUND_LINEAR_DAMPENING = 0.8;

+ (instancetype)create {
    BallNode *ball = [self node];
    ball.name = @"ball";
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:BALL_RADIUS];
    ball.physicsBody.restitution = 0.95;
    ball.physicsBody.linearDamping = (CGFloat) GROUND_LINEAR_DAMPENING;
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
    return 2 * diff / 3 / MAX_PULL;
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

    double forcePercent = self.pullStrength;
    if (forcePercent >= 0.67) {
        forcePercent = 0.67 + (forcePercent - 0.67) * 2;
    }

    forcePercent = forcePercent < 0.02 ? 0.02 : forcePercent;

    double maxForce = 160;
    double xForce = maxForce * forcePercent * cos(self.hitAngle);
    double yForce = maxForce * forcePercent * sin(self.hitAngle);
    [self.physicsBody applyForce:CGVectorMake((CGFloat) xForce, (CGFloat) yForce)];
}

- (void)fallToward:(CGVector)vector overDuration:(NSTimeInterval)duration {
    double power = duration / 70;
    [self.physicsBody applyImpulse:
            CGVectorMake((CGFloat) (vector.dx * power), (CGFloat) (vector.dy * power))];
}

- (void)setDampeningForFallingTowardHole:(BOOL)falling {
    self.physicsBody.linearDamping = (CGFloat) (falling ? 1 : GROUND_LINEAR_DAMPENING);
}

@end