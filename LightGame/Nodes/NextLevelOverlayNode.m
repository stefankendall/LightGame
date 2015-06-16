#import "NextLevelOverlayNode.h"

@implementation NextLevelOverlayNode

+ (SKShapeNode *)create: (CGRect) frame {
    SKShapeNode *nextLevelNode = [SKShapeNode shapeNodeWithRect:frame];
    nextLevelNode.lineWidth = 0;
    nextLevelNode.alpha = 0.8;
    nextLevelNode.fillColor = [UIColor blackColor];
    nextLevelNode.position = CGPointMake(0, frame.size.height);
    nextLevelNode.name = @"nextLevelOverlay";

    CGFloat circleRadius = frame.size.width / 6;
    SKShapeNode *circle = [SKShapeNode shapeNodeWithCircleOfRadius:circleRadius];
    [circle setFillColor:[UIColor whiteColor]];
    circle.position = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    SKSpriteNode *arrowSprite = [SKSpriteNode spriteNodeWithImageNamed:@"766-arrow-right-selected"];
    [arrowSprite setSize:CGSizeMake(circleRadius / 2, circleRadius)];
    [circle addChild:arrowSprite];
    circle.name = @"nextLevelButton";
    [nextLevelNode addChild:circle];
    return nextLevelNode;
}

@end