#import "Level1Node.h"
#import "BallNode.h"
#import "HoleNode.h"
#import "AimNode.h"

@implementation Level1Node

+ (Level1Node *)createWithSize:(CGSize)size {
    Level1Node *node = [self node];

    CGFloat xPad = size.width / 6;
    CGRect groundRect = CGRectMake(-size.width / 2 + xPad, -size.height / 2 + xPad, size.width - 2 * xPad, size.height);
    SKShapeNode *ground = [SKShapeNode shapeNodeWithRect:groundRect];
    ground.position = CGPointMake(0, 0);
    [ground setFillColor:[UIColor whiteColor]];
    [ground setStrokeColor:[UIColor grayColor]];
    int borderWidth = 10;
    [ground setLineWidth:borderWidth];
    ground.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectInset(groundRect, borderWidth / 2, borderWidth / 2)];
    ground.physicsBody.dynamic = NO;
    [node addChild:ground];

    BallNode *ballNode = [BallNode create];
    [node addChild:ballNode];
    ballNode.position = CGPointMake(0, -size.height / 2 + xPad + 100);
    node.initialBallPosition = ballNode.position;

    AimNode *aim = [AimNode create];
    [ballNode addChild:aim];


    HoleNode *hole = [HoleNode create];
    [node addChild:hole];
    hole.position = CGPointMake(0, size.height / 2 - xPad);

    return node;
}

@end