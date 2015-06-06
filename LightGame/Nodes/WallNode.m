#import "WallNode.h"
#import "ContactCategories.h"
#import "RunnerNode.h"

@implementation WallNode

+ (WallNode *)createWithSize:(CGSize)size hollow:(BOOL)hollow {
    WallNode *node = [self node];

    if (hollow) {
        [node addHollowRectangleOfSize:size];
    }
    else {
        [node addSolidRectangleOfSize:size];
    }
    node.size = size;
    [node createPhysicsBody];

    return node;
}

- (void)addHollowRectangleOfSize:(CGSize)size {
    SKShapeNode *rectangle = [SKShapeNode shapeNodeWithRectOfSize:size];
    [rectangle setStrokeColor:[UIColor whiteColor]];
    [rectangle setLineWidth:2];
    rectangle.name = @"rectangle";
    [self addChild:rectangle];
}

- (void)addSolidRectangleOfSize:(CGSize)size {
    SKShapeNode *rectangle = [SKShapeNode shapeNodeWithRectOfSize:size];
    [rectangle setFillColor:[UIColor whiteColor]];
    rectangle.name = @"rectangle";
    [self addChild:rectangle];
}

- (void)updateForRunner:(RunnerNode *)runner originalPosition:(CGPoint)startTrailPosition {
    if (self.position.x == startTrailPosition.x) {
        self.position = CGPointMake(runner.position.x, (runner.position.y + startTrailPosition.y) / 2);
        CGFloat newHeight = (CGFloat) fabs(runner.position.y - startTrailPosition.y);
        [self setRectangleSize:CGSizeMake([runner calculateAccumulatedFrame].size.width, newHeight)];
    }
    else {
        self.position = CGPointMake((runner.position.x + startTrailPosition.x) / 2, runner.position.y);
        CGFloat newWidth = (CGFloat) fabs(runner.position.x - startTrailPosition.x);
        [self setRectangleSize:CGSizeMake(newWidth, [runner calculateAccumulatedFrame].size.height)];
    }
}

- (void)setRectangleSize:(CGSize)size {
    self.size = size;
    SKShapeNode *rectangle = (SKShapeNode *) [self childNodeWithName:@"rectangle"];
    [self addHollowRectangleOfSize:size];
    [rectangle removeFromParent];
}

- (void)makeSolidWall {
    [self runAction:[SKAction sequence:@[
            [SKAction waitForDuration:0.25],
            [SKAction runBlock:^{
                [self createPhysicsBody];
                [self addSolidRectangleOfSize:self.size];
                [[self childNodeWithName:@"rectangle"] removeFromParent];
            }]
    ]]];
    self.name = @"wall";
}

- (void)createPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = ContactWall;
}
@end