//
//  BLPoint.h
//  BLSignature
//
//  Created by Bao Lan Le Quang on 5/28/15.
//  Copyright (c) 2015 Bao Lan Le Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLPoint : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

- (id)initWithPositionX:(CGFloat)x positionY:(CGFloat)y;

@end
