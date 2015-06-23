#import "CourseScene.h"
#import "LevelNode.h"
#import "BallNode.h"
#import "HoleNode.h"
#import "NextLevelOverlayNode.h"
#import "Level1Node.h"
#import "Level2Node.h"

@class Level1Node;

@implementation CourseScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [UIColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    [self.physicsWorld setContactDelegate:self];
    self.levels = @[Level1Node.class, Level2Node.class];
    [self replaceLevel:self.levels[self.currentLevel]];
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
        [self replaceLevel:self.levels[++self.currentLevel % self.levels.count]];
        [self hideNextLevelPrompt];
    }
    else if (!self.holeOver) {
        BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
        [ball release:[touches anyObject]];
    }
}

- (void)followBallWithCamera {
    LevelNode *level = (LevelNode *) [self childNodeWithName:@"level"];
    [level runAction:[SKAction moveTo:[self cameraPosition] duration:0.1]];
}

- (CGPoint)cameraPosition {
    LevelNode *level = (LevelNode *) [self childNodeWithName:@"level"];
    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    double ballXChange = level.initialBallPosition.x - ball.position.x;
    return CGPointMake((CGFloat) (ball.position.x + self.size.width / 2 + 2 * ballXChange),
            (CGFloat) ([level calculateAccumulatedFrame].size.height / 2 - ball.position.y));
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
    if (self.ballFallingTowardHole) {
        BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
        SKNode *gravity = (BallNode *) [self childNodeWithName:@"//gravity"];

        CGPoint ballPoint = [self convertPoint:ball.position fromNode:ball.parent];
        CGPoint gravityPoint = [self convertPoint:gravity.position fromNode:gravity.parent];
        [ball fallToward:CGVectorMake(gravityPoint.x - ballPoint.x, gravityPoint.y - ballPoint.y)
            overDuration:currentTime - self.lastTime];
    }

    BallNode *ball = (BallNode *) [self childNodeWithName:@"//ball"];
    const int stopThreshold = 1200;
    const int slowThreshold = 5000;
    double speed = pow(ball.physicsBody.velocity.dy, 2) + pow(ball.physicsBody.velocity.dx, 2);
    if (speed < stopThreshold && self.ballInHole) {
        [self holeReached];
    }
    else if (speed < slowThreshold && speed > 0) {
        float scaleDown = 1 + (float) (currentTime - self.lastTime) * 2;
        ball.physicsBody.velocity = CGVectorMake(
                ball.physicsBody.velocity.dx / scaleDown,
                ball.physicsBody.velocity.dy / scaleDown);
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
    [ball setDampeningForFallingTowardHole:_ballFallingTowardHole];
}


@end
