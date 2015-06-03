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
    [runner applyImpulseForDirection];

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
    if (location.x < self.size.width / 2) {
        [runner turnLeft];
    }
    else {
        [runner turnRight];
    }
}

- (void)update:(CFTimeInterval)currentTime {
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if ([contact.bodyA.node.name isEqualToString:@"runner"]) {
        RunnerNode *runner = (RunnerNode *) [self childNodeWithName:@"runner"];
        [runner stop];
        self.hitWall = YES;
        [runner runAction:[SKAction sequence:@[
                [SKAction fadeAlphaTo:0 duration:1],
                [SKAction runBlock:^{
                    [runner setDirection:NORTH];
                    runner.position = CGPointMake(self.size.width / 2, [runner calculateAccumulatedFrame].size.height);
                    runner.zRotation = 0;
                }],
                [SKAction fadeAlphaTo:1 duration:0.5],
                [SKAction runBlock:^{
                    self.hitWall = NO;
                    [runner applyImpulseForDirection];
                }]
        ]]];
    }
}

@end
