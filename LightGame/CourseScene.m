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
    level.position = [self cameraPosition];

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
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    [ball startTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    [ball touchesMoved:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    [ball release:[touches anyObject]];
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
    Level1Node *level = (Level1Node *) [self childNodeWithName:@"level"];
    [level runAction:[SKAction moveTo:[self cameraPosition] duration:0.1]];
}

- (CGPoint)cameraPosition {
    Level1Node *level = (Level1Node *) [self childNodeWithName:@"level"];
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    double ballYChange = ball.position.y - level.initialBallPosition.y;
    return CGPointMake(self.size.width / 2,
            level.yScale * ((CGFloat) (-ballYChange) + 3 * [level calculateAccumulatedFrame].size.height / 4));
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKNode *gravity;
    BallNode *ball;
    if ([contact.bodyA.node.name isEqualToString:@"gravity"]) {
        gravity = contact.bodyA.node;
    }
    if ([contact.bodyB.node.name isEqualToString:@"gravity"]) {
        gravity = contact.bodyB.node;
    }

    if ([contact.bodyA.node.name isEqualToString:@"ball"]) {
        ball = (BallNode *) contact.bodyA.node;
    }
    if ([contact.bodyB.node.name isEqualToString:@"ball"]) {
        ball = (BallNode *) contact.bodyB.node;
    }

    if (gravity && ball) {
        CGPoint ballPoint = [self convertPoint:ball.position fromNode:ball.parent];
        CGPoint gravityPoint = [self convertPoint:gravity.position fromNode:gravity.parent];
        [ball fallToward:CGVectorMake(gravityPoint.x - ballPoint.x, gravityPoint.y - ballPoint.y)];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact {

}


@end
