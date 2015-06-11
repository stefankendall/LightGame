#import <SpriteKit/SpriteKit.h>

@interface CourseScene : SKScene <SKPhysicsContactDelegate>

@property(nonatomic) BOOL ballFallingTowardHole;
@property(nonatomic) NSTimeInterval lastTime;
@end
