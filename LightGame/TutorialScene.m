#import "TutorialScene.h"
#import "RunnerNode.h"
#import "WallNode.h"

@implementation TutorialScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [UIColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.hitWall = NO;
    [self.physicsWorld setContactDelegate:self];

    RunnerNode *runner = [RunnerNode create];
    runner.name = @"runner";
    [self addChild:runner];
    runner.position = CGPointMake(self.size.width / 2, [runner calculateAccumulatedFrame].size.height);
    self.startTrailPosition = [runner backPosition];
    [runner applyImpulseForDirection];

    [self startTrail];

    int topWallHeight = 10;
    CGFloat topWallYPosition = self.size.height - 100;

    [self addWall:CGRectMake(0, topWallYPosition, self.size.width, topWallHeight)];
    [self addWall:CGRectMake(0, topWallYPosition, 10, self.size.height - (self.size.height - topWallYPosition))];
    [self addWall:CGRectMake(self.size.width - 10, topWallYPosition, 10, self.size.height - (self.size.height - topWallYPosition))];

    SKLabelNode *warning = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
    [warning setFontSize:14];
    [warning setText:@"DO NOT TOUCH"];
    warning.position = CGPointMake(self.size.width / 2, topWallYPosition + topWallHeight + 10);
    [warning setAlpha:0.3];
    [warning runAction:[SKAction repeatActionForever:[SKAction sequence:@[
            [SKAction fadeAlphaTo:1 duration:6],
            [SKAction fadeAlphaTo:0.3 duration:5]
    ]]]];
    [self addChild:warning];
}

- (void)startTrail {
    WallNode *trail = [WallNode createWithSize:CGSizeMake(0, 0)];
    trail.name = @"trail";
    [self addChild:trail];
}

- (void)addWall:(CGRect)rect {
    WallNode *wall = [WallNode createWithSize:rect.size];
    wall.position = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y - rect.size.height / 2);
    [self addChild:wall];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.hitWall) {
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    RunnerNode *runner = (RunnerNode *) [self childNodeWithName:@"runner"];

    [self stopTrail];
    if (location.x < self.size.width / 2) {
        [runner turnLeft];
    }
    else {
        [runner turnRight];
    }
    self.startTrailPosition = [runner backPosition];
    [self startTrail];
    [runner applyImpulseForDirection];
}

- (void)stopTrail {
    WallNode *node = (WallNode *) [self childNodeWithName:@"trail"];
    [node makeSolidWall];
}

- (void)update:(CFTimeInterval)currentTime {
    if (!self.lastUpdateTime) {
        self.lastUpdateTime = currentTime;
    }
    [self updateTrail];
}

- (void)updateTrail {
    RunnerNode *runner = (RunnerNode *) [self childNodeWithName:@"runner"];
    WallNode *trail = (WallNode *) [self childNodeWithName:@"trail"];
    [trail updateForRunner:runner originalPosition:self.startTrailPosition];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if ([contact.bodyA.node.name isEqualToString:@"runner"] || [contact.bodyB.node.name isEqualToString:@"runner"]) {
        RunnerNode *runner = (RunnerNode *)
                [self childNodeWithName:@"runner"];
        [runner stop];
        self.hitWall = YES;
        [runner runAction:[SKAction sequence:@[
                [SKAction runBlock:^{
                    void (^removeFromParent)(SKNode *, BOOL *) = ^(SKNode *node, BOOL *stop) {
                        [node runAction:[SKAction sequence:@[
                                [SKAction fadeAlphaTo:0 duration:0.5],
                                [SKAction removeFromParent]
                        ]]];
                    };
                    [self enumerateChildNodesWithName:@"trail" usingBlock:removeFromParent];
                    [self enumerateChildNodesWithName:@"wall" usingBlock:removeFromParent];
                }],
                [SKAction waitForDuration:0.5],
                [SKAction fadeAlphaTo:0 duration:1],
                [SKAction runBlock:^{
                    [runner setDirection:NORTH];
                    runner.position = CGPointMake(self.size.width / 2, [runner calculateAccumulatedFrame].size.height);
                    self.startTrailPosition = [runner backPosition];
                    runner.zRotation = 0;
                }],
                [SKAction fadeAlphaTo:1 duration:0.5],
                [SKAction runBlock:^{
                    self.hitWall = NO;
                    [runner applyImpulseForDirection];
                    [self startTrail];
                }]
        ]]];
    }
}

@end
