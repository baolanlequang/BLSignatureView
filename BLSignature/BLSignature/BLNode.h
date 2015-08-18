//
//  BLNode.h
//  BLSignature
//
//  Created by Bao Lan Le Quang on 5/28/15.
//  Copyright (c) 2015 Bao Lan Le Quang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLNode : NSObject <NSCoding>

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat t;

- (id)initWithX:(CGFloat)x y:(CGFloat)y t:(CGFloat)t;

@end
