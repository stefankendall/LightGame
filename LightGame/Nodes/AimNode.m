#import "AimNode.h"

@implementation AimNode

+ (instancetype)create {
    AimNode *aim = [self node];
    aim.name = @"aim";
    [aim addDottedLines];
    return aim;
}

const int spaceBetweenDashes = 5;
const int numberOfDashes = 6;
const int lineWidth = 3;
const int offSetFromBall = 10;
const int lineHeight = 10;
const double alphaHeight = (lineHeight + spaceBetweenDashes) * numberOfDashes - spaceBetweenDashes;

- (void)addDottedLines {
    for (int i = 0; i < numberOfDashes; i++) {
        SKShapeNode *dottedAimer =
                [SKShapeNode shapeNodeWithRect:CGRectMake(-lineWidth / 2,
                        offSetFromBall + i * (lineHeight + spaceBetweenDashes),
                        lineWidth,
                        lineHeight)];
        [dottedAimer setFillColor:[UIColor blackColor]];
        [self addChild:dottedAimer];
    }

    [self highlight:0];
}

- (void)highlight:(double)percentage {
    double filledPortion = percentage * alphaHeight;
    [[self childNodeWithName:@"alpha"] removeFromParent];;
    SKShapeNode *alphaLayer = [SKShapeNode shapeNodeWithRect:CGRectMake(-lineWidth / 2,
            (CGFloat) (offSetFromBall + filledPortion),
            lineWidth,
            (CGFloat) ((CGFloat) alphaHeight - filledPortion))];
    [alphaLayer setFillColor:[UIColor whiteColor]];
    alphaLayer.alpha = 0.7;
    alphaLayer.name = @"alpha";
    [self addChild:alphaLayer];
}

@end