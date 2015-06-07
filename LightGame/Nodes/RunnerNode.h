#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Directions.h"

@interface RunnerNode : SKNode

@property(nonatomic) double currentSpeed;

@property(nonatomic, assign) enum Direction direction;

@property(nonatomic) CGSize size;

+ (RunnerNode *)create;

- (void)applyImpulseForDirection;

- (void)turnRight;

- (void)turnLeft;

- (void)stop;

- (CGPoint)backPosition;
@end