#import "GameViewController.h"
#import "TutorialScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKView *skView = (SKView *) self.view;
    skView.showsFPS = YES;
    skView.ignoresSiblingOrder = YES;
    TutorialScene *scene = [[TutorialScene alloc] initWithSize:skView.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
