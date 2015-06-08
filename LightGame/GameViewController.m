#import "GameViewController.h"
#import "CourseScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKView *skView = (SKView *) self.view;
    skView.showsFPS = YES;
    skView.ignoresSiblingOrder = YES;
    CourseScene *scene = [[CourseScene alloc] initWithSize:skView.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
