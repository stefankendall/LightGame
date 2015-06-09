#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface Level1Node : SKNode

@property(nonatomic) CGPoint initialBallPosition;

+ (Level1Node *)createWithSize:(CGSize)size;
@end