#import "RunnerNode.h"
#import "CGPathRefHelper.h"

@implementation RunnerNode

+ (RunnerNode *)create {
    RunnerNode *node = [self node];
    node.currentSpeed = 0.7;
    node.direction = NORTH;

    CGSize size = CGSizeMake(10, 10);
    SKShapeNode *body = [SKShapeNode shapeNodeWithPath:[CGPathRefHelper pathForTriangleOfSize:size]];
    [body setFillColor:[UIColor whiteColor]];
    [node addChild:body];
    [node setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:size]];
    node.physicsBody.linearDamping = 0;
    node.physicsBody.angularDamping = 0;
    return node;
}

- (void)applyImpulseForDirection {
    self.physicsBody.velocity = CGVectorMake(0, 0);
    CGVector velocityVector = [self vectorForDirection:self.direction];
    [self.physicsBody applyImpulse:CGVectorMake((CGFloat) (self.currentSpeed * velocityVector.dx),
            (CGFloat) self.currentSpeed * velocityVector.dy)];
}

- (CGVector)vectorForDirection:(enum Direction)direction {
    CGVector velocityVector;
    switch (self.direction) {
        case NORTH:
            velocityVector = CGVectorMake(0, 1);
            break;
        case SOUTH:
            velocityVector = CGVectorMake(0, -1);
            break;
        case EAST:
            velocityVector = CGVectorMake(1, 0);
            break;
        case WEST:
            velocityVector = CGVectorMake(-1, 0);
            break;
    }
    return velocityVector;
}

- (void)moveForwardInDirection:(int)positionChange {
    NSArray *directions = @[@(NORTH), @(EAST), @(SOUTH), @(WEST)];
    int nextIndex = (([directions indexOfObject:@(self.direction)] + positionChange) % [directions count]);
    self.direction = (enum Direction) [directions[(NSUInteger) nextIndex] intValue];
    [self applyImpulseForDirection];
}

- (void)turnRight {
    [self moveForwardInDirection:1];
    self.zRotation = (CGFloat) (self.zRotation - M_PI / 2);
}

- (void)turnLeft {
    [self moveForwardInDirection:-1];
    self.zRotation = (CGFloat) (self.zRotation + M_PI / 2);
}

@end