#import "CourseScene.h"
#import "Level1Node.h"

@class Level1Node;

@implementation CourseScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [UIColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    [self.physicsWorld setContactDelegate:self];

    Level1Node *level = [Level1Node createWithSize:self.size];
    level.name = @"level";
    [self addChild:level];
    level.position = CGPointMake(self.size.width / 2, self.size.height / 2);

    UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [view addGestureRecognizer:pinch];
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    CGFloat scale = pinch.scale;
    scale = scale > 1 ? 1 : scale;
    double minZoom = 0.5;
    scale = (CGFloat) (scale < minZoom ? minZoom : scale);
    [[self childNodeWithName:@"level"] setScale:scale];
}

@end
