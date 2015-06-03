#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface WallNode : SKNode
+ (WallNode *)createWithSize:(CGSize)size;
@end