#import <SpriteKit/SpriteKit.h>

@interface CourseScene : SKScene <SKPhysicsContactDelegate>

@property(nonatomic) BOOL ballFallingTowardHole;
@property(nonatomic) NSTimeInterval lastTime;
@property(nonatomic) BOOL ballInHole;
@property(nonatomic) BOOL holeOver;
@property(nonatomic) BOOL goToNextLevel;
@end
