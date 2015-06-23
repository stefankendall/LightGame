#import "Level1Node.h"

@implementation Level1Node

- (UIBezierPath *)groundPath {
    CGFloat xPad = self.size.width / 6;
    CGRect groundRect = CGRectMake(-self.size.width / 2 + xPad, -self.size.height / 2 + xPad, self.size.width - 2 * xPad, self.size.height);
    return [UIBezierPath bezierPathWithRect:groundRect];
}

- (CGPoint)initialBallPosition {
    CGFloat xPad = self.size.width / 6;
    return CGPointMake(0, -self.size.height / 2 + xPad + 100);
}

- (CGPoint)holePosition {
    CGFloat xPad = self.size.width / 6;
    return CGPointMake(0, self.size.height / 2 - xPad);
}


@end