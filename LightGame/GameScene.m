#import "GameScene.h"
#import "RunnerNode.h"
#import "WallNode.h"

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [UIColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0, 0);

    RunnerNode *runner = [RunnerNode create];
    runner.name = @"runner";
    runner.position = CGPointMake(self.size.width / 2, 100);
    [self addChild:runner];
    [runner applyImpulseForDirection];

    WallNode *wall = [WallNode createWithSize:CGSizeMake(self.size.width, 10)];
    wall.position = CGPointMake(self.size.width / 2, self.size.height - 100);
    [self addChild:wall];
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
