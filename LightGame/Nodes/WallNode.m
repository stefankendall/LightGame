#import "WallNode.h"
#import "ContactCategories.h"

@implementation WallNode

+ (WallNode *)createWithSize:(CGSize)size {
    WallNode *node = [self node];

    SKShapeNode *rectangle = [SKShapeNode shapeNodeWithRectOfSize:size];
    [rectangle setFillColor:[UIColor whiteColor]];
    [node addChild:rectangle];

    [node setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:size]];
    node.physicsBody.categoryBitMask = ContactWall;
    node.physicsBody.dynamic = NO;

    return node;
}

@end