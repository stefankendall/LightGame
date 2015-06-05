#import <SpriteKit/SpriteKit.h>

@class WallNode;

@interface TutorialScene : SKScene <SKPhysicsContactDelegate>

@property(nonatomic) BOOL hitWall;
@property(nonatomic) CFTimeInterval lastUpdateTime;
@property(nonatomic) CGPoint startTrailPosition;
@end
