//
//  BLSpline.h
//  BLSignature
//
//  Created by Bao Lan Le Quang on 5/28/15.
//  Copyright (c) 2015 Bao Lan Le Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLSpline : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat a;
@property (nonatomic) CGFloat b;
@property (nonatomic) CGFloat c;
@property (nonatomic) CGFloat d;

- (id)initWithX:(CGFloat)x a:(CGFloat)a b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d;

@end
