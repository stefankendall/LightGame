#import "LevelNode.h"
#import "HoleNode.h"
#import "AimNode.h"
#import "BallNode.h"

@implementation LevelNode

+ (LevelNode *)createWithSize:(CGSize)size {
    return nil;
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