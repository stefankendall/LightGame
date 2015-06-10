#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

extern const int BALL_RADIUS;

@interface BallNode : SKNode

+ (instancetype)create;

- (void)hitInDirection:(CGVector)vector withPercentOfMaxForce:(double)force;

- (void)adjustAimForTouch:(id)object;
@end