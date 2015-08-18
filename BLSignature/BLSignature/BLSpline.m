//
//  BLSpline.m
//  BLSignature
//
//  Created by Bao Lan Le Quang on 5/28/15.
//  Copyright (c) 2015 Bao Lan Le Quang. All rights reserved.
//

#import "BLSpline.h"

@implementation BLSpline

- (id)initWithX:(CGFloat)x a:(CGFloat)a b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d {
    self = [super init];
    if (self) {
        _x = x;
        _a = a;
        _b = b;
        _c = c;
        _d = d;
    }
    return self;
}

@end
