#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface AimNode : SKNode

+ (instancetype) create;

- (void)highlight:(double)d;
@end