#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class RunnerNode;

@interface WallNode : SKNode
@property(nonatomic) CGSize size;

+ (WallNode *)createWithSize:(CGSize)size;

- (void)setHeight:(CGFloat)height;

- (void)updateForRunner:(RunnerNode *)node originalPosition:(CGPoint)startTrailPosition;
@end