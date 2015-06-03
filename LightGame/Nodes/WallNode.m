#import "WallNode.h"

@implementation WallNode

+ (WallNode *)createWithSize:(CGSize)size {
    WallNode *node = [self node];

    SKShapeNode *rectangle = [SKShapeNode shapeNodeWithRectOfSize:size];
    [rectangle setFillColor:[UIColor whiteColor]];
    [node addChild:rectangle];

    return node;
}

@end