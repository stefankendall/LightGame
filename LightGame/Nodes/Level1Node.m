#import "Level1Node.h"
#import "BallNode.h"

@implementation Level1Node

+ (Level1Node *)createWithSize:(CGSize)size {
    Level1Node *node = [self node];

    CGFloat xPad = size.width / 6;
    SKShapeNode *ground = [SKShapeNode shapeNodeWithRect:
            CGRectMake(-size.width / 2 + xPad, -size.height / 2 + xPad, size.width - 2 * xPad, size.height)];
    ground.position = CGPointMake(0, 0);
    [ground setFillColor:[UIColor whiteColor]];
    [ground setStrokeColor:[UIColor grayColor]];
    [ground setLineWidth:10];
    [node addChild:ground];

    BallNode *ballNode = [BallNode create];
    [node addChild:ballNode];
    ballNode.position = CGPointMake(0, -size.height / 2 + xPad + 100);
    node.initialBallPosition = ballNode.position;


    return node;
}
@end