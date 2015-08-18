//
//  BLPoint.m
//  BLSignature
//
//  Created by Bao Lan Le Quang on 5/28/15.
//  Copyright (c) 2015 Bao Lan Le Quang. All rights reserved.
//

#import "BLPoint.h"

@implementation BLPoint

- (id)initWithPositionX:(CGFloat)x positionY:(CGFloat)y {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

@end
