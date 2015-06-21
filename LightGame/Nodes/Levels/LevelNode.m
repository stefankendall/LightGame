#import "LevelNode.h"
#import "HoleNode.h"
#import "AimNode.h"
#import "BallNode.h"

@implementation LevelNode

+ (LevelNode *)createWithSize:(CGSize)size {
    LevelNode *node = [self node];
    node.name = @"level";
    node.size = size;

    [node addGround];
    [node addBall];
    [node addHole];

    return node;
}

- (void)addGround {
}

- (void)addHole {
    HoleNode *hole = [HoleNode create];
    [self addChild:hole];
    hole.position = [self holePosition];
}

- (void)addBall {
    BallNode *ballNode = [BallNode create];
    [self addChild:ballNode];
    ballNode.position = [self initialBallPosition];

    AimNode *aim = [AimNode create];
    [ballNode addChild:aim];
}

- (CGPoint)holePosition {
    return CGPointZero;
}

- (CGPoint)initialBallPosition {
    return CGPointZero;
}

@end