#import "CourseScene.h"
#import "LevelNode.h"
#import "BallNode.h"
#import "HoleNode.h"
#import "NextLevelOverlayNode.h"
#import "Level1Node.h"

@class Level1Node;

@implementation CourseScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [UIColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    [self.physicsWorld setContactDelegate:self];
    [self replaceLevel:Level1Node.class];
    UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [view addGestureRecognizer:pinch];
}

- (void)replaceLevel:(Class)klass {
    [[self childNodeWithName:@"level"] removeFromParent];
    LevelNode *level = [klass createWithSize:self.size];
    [self addChild:level];
    level.position = [self cameraPosition];
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
    UITouch *anyTouch = [touches anyObject];
    NSArray *touchedNodes = [self nodesAtPoint:[anyTouch locationInNode:self]];
    SKNode *nextLevelNode = [self childNodeWithName:@"//nextLevelButton"];
    if ([touchedNodes containsObject:nextLevelNode]) {
        self.goToNextLevel = YES;
        nextLevelNode.alpha = 0.5;
    }
    else if (!self.holeOver) {
        BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
        [ball startTouch:[touches anyObject]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.holeOver) {
        return;
    }

    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    [ball touchesMoved:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.goToNextLevel) {
        [self replaceLevel:Level1Node.class];
        [self hideNextLevelPrompt];
    }
    else if (!self.holeOver) {
        BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
        [ball release:[touches anyObject]];
    }
}

- (void)stopBallIfNecessary {
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    double velocitySquared = pow(ball.physicsBody.velocity.dy, 2) + pow(ball.physicsBody.velocity.dx, 2);
    if (velocitySquared < 40) {
        ball.physicsBody.velocity = CGVectorMake(0, 0);
    }
}

- (void)followBallWithCamera {
    LevelNode *level = (LevelNode *) [self childNodeWithName:@"level"];
    [level runAction:[SKAction moveTo:[self cameraPosition] duration:0.1]];
}

- (CGPoint)cameraPosition {
    LevelNode *level = (LevelNode *) [self childNodeWithName:@"level"];
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    double ballYChange = ball.position.y - level.initialBallPosition.y;
    return CGPointMake(self.size.width / 2,
            level.yScale * ((CGFloat) (-ballYChange) + 3 * [level calculateAccumulatedFrame].size.height / 4));
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    NSArray *nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
    if ([nodeNames containsObject:@"gravity"] && [nodeNames containsObject:@"ball"]) {
        self.ballFallingTowardHole = YES;
    }
    if ([nodeNames containsObject:@"hole"] && [nodeNames containsObject:@"ball"]) {
        self.ballInHole = YES;
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    NSArray *nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
    if ([nodeNames containsObject:@"gravity"] && [nodeNames containsObject:@"ball"]) {
        self.ballFallingTowardHole = NO;
    }
    if ([nodeNames containsObject:@"hole"] && [nodeNames containsObject:@"ball"]) {
        self.ballInHole = NO;
    }
}

- (void)update:(NSTimeInterval)currentTime {
    if (self.holeOver) {
        return;
    }

    [self followBallWithCamera];
    [self stopBallIfNecessary];

    if (self.ballFallingTowardHole) {
        BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
        SKNode *gravity = (BallNode *) [self childNodeWithName:@"//gravity"];

        CGPoint ballPoint = [self convertPoint:ball.position fromNode:ball.parent];
        CGPoint gravityPoint = [self convertPoint:gravity.position fromNode:gravity.parent];
        [ball fallToward:CGVectorMake(gravityPoint.x - ballPoint.x, gravityPoint.y - ballPoint.y)
            overDuration:currentTime - self.lastTime];
    }

    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    const int stopThreshhold = 1200;
    double speed = pow(ball.physicsBody.velocity.dy, 2) + pow(ball.physicsBody.velocity.dx, 2);
    if (speed < stopThreshhold && self.ballInHole) {
        [self holeReached];
    }

    self.lastTime = currentTime;
}

- (void)holeReached {
    self.holeOver = YES;
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    HoleNode *hole = (HoleNode *) [self childNodeWithName:@"//hole"];

    [ball runAction:[SKAction sequence:@[
            [SKAction moveTo:[hole position] duration:0.5],
            [SKAction runBlock:^{
                [self showNextLevelPrompt];
            }],
            [SKAction removeFromParent],
    ]]];
}

- (void)showNextLevelPrompt {
    SKShapeNode *nextLevelNode = [NextLevelOverlayNode create:self.frame];
    [self addChild:nextLevelNode];
    SKAction *moveIn = [SKAction moveToY:0 duration:0.3];
    moveIn.timingMode = SKActionTimingEaseIn;
    [nextLevelNode runAction:moveIn];
}

- (void)hideNextLevelPrompt {
    SKNode *nextLevelNode = [self childNodeWithName:@"//nextLevelOverlay"];
    SKNode *nextLevelButton = [self childNodeWithName:@"//nextLevelButton"];
    nextLevelButton.alpha = 1;
    [nextLevelNode runAction:
            [SKAction sequence:@[
                    [SKAction moveToY:self.size.height duration:0.3],
                    [SKAction runBlock:^{
                        self.goToNextLevel = NO;
                        self.holeOver = NO;
                        self.ballFallingTowardHole = NO;
                        self.ballInHole = NO;
                    }],
                    [SKAction removeFromParent]
            ]]
    ];
}

- (void)setBallFallingTowardHole:(BOOL)ballFallingTowardHole {
    _ballFallingTowardHole = ballFallingTowardHole;
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    [ball setDampeningForFallingTowardHole: _ballFallingTowardHole];
}


@end
