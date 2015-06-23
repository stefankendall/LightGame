#import "LevelNode.h"
#import "HoleNode.h"
#import "AimNode.h"
#import "BallNode.h"
#import "ContactCategories.h"

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
    UIBezierPath *bezierPath = [self groundPath];
    SKShapeNode *ground = [SKShapeNode shapeNodeWithPath:bezierPath.CGPath];
    ground.position = CGPointMake(0, 0);
    [ground setFillColor:[UIColor whiteColor]];
    [ground setStrokeColor:[UIColor grayColor]];
    int borderWidth = 10;
    [ground setLineWidth:borderWidth];
    ground.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:bezierPath.CGPath];
    ground.physicsBody.dynamic = NO;
    ground.physicsBody.categoryBitMask = CategoryWall;
    ground.physicsBody.collisionBitMask = CategoryBall;
    ground.physicsBody.restitution = 1;
    [self addChild:ground];
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

- (UIBezierPath *)groundPath {
    return nil;
}

- (CGPoint)initialBallPosition {
    return CGPointZero;
}

@end