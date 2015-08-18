//
//  BLNode.m
//  BLSignature
//
//  Created by Bao Lan Le Quang on 5/28/15.
//  Copyright (c) 2015 Bao Lan Le Quang. All rights reserved.
//

#import "BLNode.h"

@implementation BLNode

- (id)initWithX:(CGFloat)x y:(CGFloat)y t:(CGFloat)t {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _t = t;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeFloat:_x forKey:@"x"];
    [aCoder encodeFloat:_y forKey:@"y"];
    [aCoder encodeFloat:_t forKey:@"t"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    float x = [aDecoder decodeFloatForKey:@"x"];
    float y = [aDecoder decodeFloatForKey:@"y"];
    float t = [aDecoder decodeFloatForKey:@"t"];
    return [self initWithX:x y:y t:t];
}

@end
