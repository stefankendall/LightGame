#import "HoleNode.h"
#import "BallNode.h"
#import "ContactCategories.h"

@implementation HoleNode

+ (instancetype)create {
    HoleNode *node = [self node];

    int HOLE_RADIUS = BALL_RADIUS + 1;
    int gravityRadius = HOLE_RADIUS + 10;
    SKShapeNode *gravity = [SKShapeNode shapeNodeWithCircleOfRadius:gravityRadius];
    gravity.name = @"gravity";
    gravity.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:gravityRadius];
    gravity.physicsBody.categoryBitMask = CategoryGravity;
    gravity.physicsBody.contactTestBitMask = CategoryBall;
    gravity.physicsBody.collisionBitMask = CollisionBallAndHole;
    [gravity setFillColor:[UIColor lightGrayColor]];
    gravity.alpha = 0.7;
    [node addChild:gravity];

    SKShapeNode *darkness = [SKShapeNode shapeNodeWithCircleOfRadius:HOLE_RADIUS];
    [darkness setFillColor:[UIColor blackColor]];
    [darkness setLineWidth:0];
    [gravity addChild:darkness];

    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:HOLE_RADIUS];
    node.physicsBody.categoryBitMask = CategoryHole;
    node.physicsBody.collisionBitMask = CollisionBallAndHole;
    node.physicsBody.contactTestBitMask = CategoryBall;
    node.name = @"hole";
    return node;
}

@end