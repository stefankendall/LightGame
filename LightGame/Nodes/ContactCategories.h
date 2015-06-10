#import <Foundation/Foundation.h>

typedef enum : uint8_t {
    ContactWall = 1 << 0,
    CategoryHole = 1 << 1,
    CategoryBall = 1 << 2
} ContactType;

typedef enum : uint8_t {
    CollisionBallAndHole = 1 << 0
} CollisionType;

