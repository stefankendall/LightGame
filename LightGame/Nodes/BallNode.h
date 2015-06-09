#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface BallNode : SKNode

+ (instancetype) create;

- (void)hitInDirection:(CGVector)vector withPercentOfMaxForce:(double)force;
@end