#import "AimNode.h"

@implementation AimNode

+ (instancetype)create {
    AimNode *aim = [self node];
    aim.name = @"aim";

    int spaceBetweenDashes = 5;
    int numberOfDashes = 6;
    int lineWidth = 3;
    int offSetFromBall = 10;
    int lineHeight = 10;

    for (int i = 0; i < numberOfDashes; i++) {
        SKShapeNode *dottedAimer =
                [SKShapeNode shapeNodeWithRect:CGRectMake(-lineWidth / 2,
                        offSetFromBall + i * (lineHeight + spaceBetweenDashes),
                        lineWidth,
                        lineHeight)];
        [dottedAimer setFillColor:[UIColor grayColor]];
        dottedAimer.alpha = 0.5;
        [aim addChild:dottedAimer];
    }

    return aim;
}

@end