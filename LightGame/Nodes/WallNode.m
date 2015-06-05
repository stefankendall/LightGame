#import "WallNode.h"
#import "ContactCategories.h"
#import "RunnerNode.h"

@implementation WallNode

+ (WallNode *)createWithSize:(CGSize)size {
    WallNode *node = [self node];

    [node addRectangleOfSize:size];
    node.size = size;
    [node setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:size]];
    node.physicsBody.categoryBitMask = ContactWall;
    node.physicsBody.dynamic = NO;

    return node;
}

- (void)addRectangleOfSize:(CGSize)size {
    SKShapeNode *rectangle = [SKShapeNode shapeNodeWithRectOfSize:size];
    [rectangle setFillColor:[UIColor whiteColor]];
    rectangle.name = @"rectangle";
    [self addChild:rectangle];
}

- (void)setHeight:(CGFloat)height {
    SKShapeNode *rectangle = (SKShapeNode *) [self childNodeWithName:@"rectangle"];
    [self addRectangleOfSize:CGSizeMake(self.size.width, height)];
    [rectangle removeFromParent];
}

- (void)updateForRunner:(RunnerNode *)runner originalPosition: (CGPoint) startTrailPosition {
    self.position = CGPointMake(runner.position.x, (runner.position.y + startTrailPosition.y) / 2);
    CGFloat newHeight = runner.position.y - startTrailPosition.y;
    [self setHeight:newHeight];
}
@end