#import "RunnerNode.h"
#import "CGPathRefHelper.h"
#import "ContactCategories.h"

@implementation RunnerNode

+ (RunnerNode *)create {
    RunnerNode *node = [self node];
    node.currentSpeed = 0.2;
    node.direction = NORTH;

    CGSize size = CGSizeMake(10, 10);
    CGPathRef path = [CGPathRefHelper pathForTriangleOfSize:size];
    SKShapeNode *body = [SKShapeNode shapeNodeWithPath:path];
    [body setFillColor:[UIColor whiteColor]];
    [node addChild:body];
    [node setPhysicsBody:[SKPhysicsBody bodyWithPolygonFromPath:[CGPathRefHelper pathForTriangleOfSize:
            CGSizeMake(size.width - 2, size.height - 2)]]];
    node.physicsBody.linearDamping = 0;
    node.physicsBody.angularDamping = 0;

    node.physicsBody.categoryBitMask = ContactRunner;
    node.physicsBody.contactTestBitMask = ContactWall;

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

- (void)stop {
    self.physicsBody.velocity = CGVectorMake(0, 0);
}

@end