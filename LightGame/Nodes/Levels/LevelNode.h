#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface LevelNode : SKNode

+ (LevelNode *)createWithSize:(CGSize)size;

- (void)addGround;

- (void)addHole;

- (void)addBall;

- (CGPoint)holePosition;

- (CGPoint)initialBallPosition;

@property(nonatomic) CGSize size;

@end