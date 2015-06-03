#import "TutorialScene.h"
#import "RunnerNode.h"
#import "WallNode.h"

@implementation TutorialScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [UIColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0, 0);

    RunnerNode *runner = [RunnerNode create];
    runner.name = @"runner";
    runner.position = CGPointMake(self.size.width / 2, 100);
    [self addChild:runner];
    [runner applyImpulseForDirection];

    int wallHeight = 10;
    WallNode *wall = [WallNode createWithSize:CGSizeMake(self.size.width, wallHeight)];
    CGFloat wallYPosition = self.size.height - 100;
    wall.position = CGPointMake(self.size.width / 2, wallYPosition);
    [self addChild:wall];

    SKLabelNode *warning = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
    [warning setFontSize:14];
    [warning setText:@"DO NOT TOUCH"];
    warning.position = CGPointMake(self.size.width / 2, wallYPosition + wallHeight + 10);
    [warning setAlpha:0.1];
    [warning runAction:[SKAction repeatActionForever:[SKAction sequence:@[
            [SKAction fadeAlphaTo:1 duration:6],
            [SKAction fadeAlphaTo:0.3 duration:5]
    ]]]];
    [self addChild:warning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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

@end
