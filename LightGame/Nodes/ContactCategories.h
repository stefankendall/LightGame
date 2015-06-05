#import <Foundation/Foundation.h>

typedef enum : uint8_t {
    ContactWall = 1 << 0,
    ContactNewWall = 1 << 1,
    ContactRunner = 1 << 2
} ContactType;