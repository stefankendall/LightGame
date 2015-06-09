#import "CourseScene.h"
#import "Level1Node.h"
#import "BallNode.h"

@class Level1Node;

@implementation CourseScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [UIColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    [self.physicsWorld setContactDelegate:self];

    Level1Node *level = [Level1Node createWithSize:self.size];
    level.name = @"level";
    [self addChild:level];
    level.position = CGPointMake(self.size.width / 2, self.size.height / 2);

    UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [view addGestureRecognizer:pinch];
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    if (ball.physicsBody.velocity.dy == 0 && ball.physicsBody.velocity.dx == 0) {
        CGFloat scale = pinch.scale;
        scale = scale > 1 ? 1 : scale;
        double minZoom = 0.5;
        scale = (CGFloat) (scale < minZoom ? minZoom : scale);
        [[self childNodeWithName:@"level"] setScale:scale];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
        [ball hitInDirection:CGVectorMake(0, 1) withPercentOfMaxForce:1];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    [self followBallWithCamera];
    [self stopBallIfNecessary];
}

- (void)stopBallIfNecessary {
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    double velocitySquared = pow(ball.physicsBody.velocity.dy, 2) + pow(ball.physicsBody.velocity.dx, 2);
    if (velocitySquared < 40) {
        ball.physicsBody.velocity = CGVectorMake(0, 0);
    }
}

- (void)followBallWithCamera {
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    Level1Node *level = (Level1Node *) [self childNodeWithName:@"level"];
    double ballYChange = ball.position.y - level.initialBallPosition.y;
    CGPoint newPosition = CGPointMake(level.position.x,
            (CGFloat) (-ballYChange) + [level calculateAccumulatedFrame].size.height / 2);
    [level runAction:[SKAction moveTo:newPosition duration:0.1]];
}


@end
