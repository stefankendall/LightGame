#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface LevelNode : SKNode
@property(nonatomic) CGPoint initialBallPosition;

+ (LevelNode *)createWithSize:(CGSize)size;
@end