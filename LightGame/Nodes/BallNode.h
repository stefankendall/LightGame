#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

extern const int BALL_RADIUS;

@interface BallNode : SKNode

@property(nonatomic) double startTouchDistanceFromBall;

@property(nonatomic) double pullStrength;

@property(nonatomic) CGFloat hitAngle;

+ (instancetype)create;

- (void)adjustAimForTouch:(id)object;

- (void)startTouch:(id)object;

- (void)touchesMoved:(UITouch *)touch;

- (void)release:(UITouch *)touch;

- (void)hit;

- (void)fallToward:(CGVector)point;
@end