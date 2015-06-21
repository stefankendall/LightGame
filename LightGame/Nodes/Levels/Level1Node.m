#import "Level1Node.h"

@implementation Level1Node

+ (Level1Node *)createWithSize:(CGSize)size {
    Level1Node *node = [self node];
    node.name = @"level";
    node.size = size;

    [node addGround];
    [node addBall];
    [node addHole];

    return node;
}

- (void)addGround {
    CGFloat xPad = self.size.width / 6;
    CGRect groundRect = CGRectMake(-self.size.width / 2 + xPad, -self.size.height / 2 + xPad, self.size.width - 2 * xPad, self.size.height);
    SKShapeNode *ground = [SKShapeNode shapeNodeWithRect:groundRect];
    ground.position = CGPointMake(0, 0);
    [ground setFillColor:[UIColor whiteColor]];
    [ground setStrokeColor:[UIColor grayColor]];
    int borderWidth = 10;
    [ground setLineWidth:borderWidth];
    ground.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectInset(groundRect, borderWidth / 2, borderWidth / 2)];
    ground.physicsBody.dynamic = NO;
    [self addChild:ground];
}

- (CGPoint)initialBallPosition {
    CGFloat xPad = self.size.width / 6;
    return CGPointMake(0, -self.size.height / 2 + xPad + 100);
}

- (CGPoint)holePosition {
    CGFloat xPad = self.size.width / 6;
    return CGPointMake(0, self.size.height / 2 - xPad);
}


@end