//
//  BLSignatureView.m
//  BLSignature
//
//  Created by Bao Lan Le Quang on 5/28/15.
//  Copyright (c) 2015 Bao Lan Le Quang. All rights reserved.
//

#import "BLSignatureView.h"
#import "BLPoint.h"
#import "BLPointList.h"
#import "BLNode.h"
#import "BLNodeList.h"
#import "BLSpline.h"

@implementation BLSignatureView {
    CGPoint lastPoint;  //stores the last drawn point on the canvas
    BOOL mouseSwiped;   //identifies if the brush stroke is continuous
    CGFloat brush;  //store the brush stroke width
    CGFloat opacity;    //store the opacity
    UIColor *strokeColor; //color of signature
    NSMutableArray *arrPoint;   //array of current drawing point
    
    NSMutableArray *stroke1;    //stroke of current display signature
    NSMutableArray *stroke2;    //stroke of saved signature
    
    double startTime;   //time when you touch in draw view
}

- (void)awakeFromNib {
    //init value when the this view is loaded
    brush = 5.0;
    opacity = 1.0;
    arrPoint = [[NSMutableArray alloc] init];
    strokeColor = [self colorFromHexString:@"000000"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //check when user begain touch to draw
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self];
    
    startTime = [[NSDate date] timeIntervalSince1970];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //check when user drawing signature
    //this function draw the signature and save the data of stroke to arrPoint
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    float tValue = [[NSDate date] timeIntervalSince1970] - startTime;
    
    BLNode *blNode = [[BLNode alloc] initWithX:currentPoint.x y:currentPoint.y t:tValue];
    
    [arrPoint addObject:blNode];
    
    //draw the signature
    UIGraphicsBeginImageContext(self.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGFloat red, green, blue, alpha;
    [strokeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //check when the user end touch and display the signature
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
    
    
}

- (void)loadSavedData {
    //load the signature form base64 string
    [self clearSignature];
    
    NSArray *decompressedArr = [self decompressData];
    
    //draw the saved signature on the view
    for (int i=1; i<decompressedArr.count; i++) {
        BLNode *node1 = [decompressedArr objectAtIndex:i-1];
        BLNode *node = [decompressedArr objectAtIndex:i];
        UIGraphicsBeginImageContext(self.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), node1.x, node1.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), node.x, node.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGFloat red, green, blue, alpha;
        [strokeColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.tempDrawImage setAlpha:opacity];
        UIGraphicsEndImageContext();

    }
    
    
    
    
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
}

- (NSDictionary *)compareWithSavedSignature {
    //compare two signatures
    //result return a dictionary with the comparsion string and the percent different
    stroke1 = [NSMutableArray arrayWithObject:arrPoint];    //stroke from current display signature
    
    NSMutableArray *savedData = [self decompressData];
    if (savedData != nil && savedData.count > 0) {
        stroke2 = [NSMutableArray arrayWithObject:savedData]; //stroke from saved signature
    }
    
    
    NSString *comparison = @"different";
    float percentX = 0;
    float percentY = 0;
    if (arrPoint.count > 0  && savedData.count > 0) {
        //compare two signatures
        BLPoint *pointCompare = [self compare:stroke1 stroke2:stroke2];
        float c = MIN(pointCompare.x, pointCompare.y);
        NSLog(@"comx: %f", pointCompare.x);
        NSLog(@"comy: %f", pointCompare.y);
        if (c > 0.9)
            comparison = @"identical";
        else if (c > 0.6)
            comparison = @"similar";
        
        percentX = roundf(pointCompare.x*100);
        percentY = roundf(pointCompare.y*100);
        
        NSLog(@"com: %@", comparison);
    }
    
    NSString *strPercentX = [NSString stringWithFormat:@"%.2f%%", percentX];
    NSString *strPercentY = [NSString stringWithFormat:@"%.2f%%", percentY];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:comparison, @"result", strPercentX, @"percentx", strPercentY, @"percenty", nil];
}

- (void)clearSignature {
    //clear current display signature
    self.mainImage.image = nil;
    [arrPoint removeAllObjects];
    arrPoint = [NSMutableArray new];
}

- (void)saveSignature {
    //save signature to base64
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:arrPoint];
    NSData *stbase64 = [saveData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.base64String = [[NSString alloc] initWithData:stbase64 encoding:NSUTF8StringEncoding];
}

- (NSMutableArray *)decompressData {
    //get the stroke data from base64 string
    NSMutableArray *result;
    NSData *d = [[NSData alloc] initWithBase64EncodedString:self.base64String options:NSDataBase64Encoding64CharacterLineLength];
    result = [NSKeyedUnarchiver unarchiveObjectWithData:d];
    return result;
}


#pragma mark - COMPARE
- (BLNodeList *)toObjectArray:(NSMutableArray *)p {
    //convert the BLNodeList Object to a array
    BLNodeList *r = [[BLNodeList alloc] init];
    r.x = [[NSMutableArray alloc] init];
    r.y = [[NSMutableArray alloc] init];
    r.t = [[NSMutableArray alloc] init];
    for (int i=0; i<p.count; i++) {
        BLNode *node = [p objectAtIndex:i];
        NSNumber *numX = [NSNumber numberWithFloat:node.x];
        NSNumber *numY = [NSNumber numberWithFloat:node.y];
        NSNumber *numT = [NSNumber numberWithFloat:node.t];
        [r.x insertObject:numX atIndex:i];
        [r.y insertObject:numY atIndex:i];
        [r.t insertObject:numT atIndex:i];
    }
    return r;
}


- (NSMutableArray *)fromObjectArray:(BLNodeList *)r {
    //convert a array object to BLNodeList object
    NSMutableArray *p = [[NSMutableArray alloc] init];
    for (int i = 0; i < r.t.count; i++) {
        CGFloat x = [[r.x objectAtIndex:i] floatValue];
        CGFloat y = [[r.y objectAtIndex:i] floatValue];
        CGFloat t = [[r.t objectAtIndex:i] floatValue];
        BLNode *node = [[BLNode alloc] initWithX:x y:y t:t];
        [p insertObject:node atIndex:i];
    }
    return p;
}

- (NSMutableArray *)buildSpline:(NSArray *)x y:(NSArray *)y {
    //build the simulation line from x and y of positions
    int n = MIN(x.count, y.count);
    
    NSMutableArray *splines = [[NSMutableArray alloc] init];
    for (int i = 0; i < n; ++i)
    {
        CGFloat numX = [[x objectAtIndex:i] floatValue];
        CGFloat numY = [[y objectAtIndex:i] floatValue];
        BLSpline *spline = [[BLSpline alloc] initWithX:numX  a:numY b:0 c:0 d:0];
        [splines insertObject:spline atIndex:i];
    }
    
    NSMutableArray *alpha = [[NSMutableArray alloc] init];
    NSMutableArray *beta = [[NSMutableArray alloc] init];
    [alpha addObject:[NSNumber numberWithFloat:0.0]];
    [beta addObject:[NSNumber numberWithFloat:0.0]];
    for (int i=1; i<n-1; ++i) {
        float hi = [[x objectAtIndex:i] floatValue] - [[x objectAtIndex:i-1] floatValue];
        float hi1 = [[x objectAtIndex:i+1] floatValue] - [[x objectAtIndex:i] floatValue];
        float A = hi;
        float C = 2 * (hi + hi1);
        float B = hi1;
        float F = 6 * (([[y objectAtIndex:i+1] floatValue] - [[y objectAtIndex:i] floatValue]) / hi1 - ([[y objectAtIndex:i] floatValue] - [[y objectAtIndex:i-1] floatValue]) / hi);
        float z = (A * [[alpha objectAtIndex:i-1] floatValue] + C);
        NSNumber *numAlpha = [NSNumber numberWithFloat:(-B/z)];
        [alpha insertObject:numAlpha atIndex:i];
        NSNumber *numBeta = [NSNumber numberWithFloat:((F - A * [[beta objectAtIndex:i-1] floatValue]) / z)];
        [beta insertObject:numBeta atIndex:i];
        
    }

    for (int i=n-2; i>0; --i) {
        BLSpline *spline = [splines objectAtIndex:i];
        BLSpline *spline1 = [splines objectAtIndex:i+1];
        spline.c = [[alpha objectAtIndex:i] floatValue] * spline1.c + [[beta objectAtIndex:i] floatValue];
    }
    
    for (int i=n-1; i>0; --i) {
        float hi = [[x objectAtIndex:i] floatValue] - [[x objectAtIndex:i-1] floatValue];
        BLSpline *spline = [splines objectAtIndex:i];
        BLSpline *spline1 = [splines objectAtIndex:i-1];
        spline.d = (spline.c - spline1.c) / hi;
        spline.b = hi * (2 * spline.c + spline1.c) / 6 + ([[y objectAtIndex:i] floatValue] - [[y objectAtIndex:i-1] floatValue]) / hi;
    }
    
    return splines;
    
}

- (float)interpolate:(NSArray *)splines x:(float)x
{
    //interpolate function
    //this is the part of algorithm but I can't know what's exactly name of this
    int n = splines.count;
    BLSpline *s;
    
    BLSpline *spline0 = [splines objectAtIndex:0];
    BLSpline *splineN1 = [splines objectAtIndex:n-1];
    if (x <= spline0.x) {
        s = spline0;
    }
    else if (x >= splineN1.x) {
        s = splineN1;
    }
    else {
        int i = 0;
        int j = n-1;
        while (i + 1 < j) {
            int k = i + ((j - i) / 2);
            BLSpline *splineK = [splines objectAtIndex:k];
            if (x <= splineK.x) {
                j = k;
            }
            else {
                i = k;
            }
        }
        BLSpline *splineJ = [splines objectAtIndex:j];
        s = splineJ;
    }
    
    float dx = s.x - x;
    
    
    float returnValue = s.a + (s.b + (s.c / 2 + s.d * dx / 6) * dx) * dx;
    
    if (returnValue != returnValue) {
        returnValue = 0;
    }
    
    return returnValue;
    
}

- (float)correlation:(NSArray *)a b:(NSArray *)b {
    //correlation function
    //this is the part of algorithm but I can't know what's exactly name of this
    float a0 = 0;
    int na = a.count;
    for (int i = 0; i < na; i++) {
        a0 = a0 + [[a objectAtIndex:i] floatValue];
    }
    a0 = a0 / na;
    
    float b0 = 0;
    float nb = b.count;
    for (int i=0; i < nb; i++) {
        b0 = b0 + [[b objectAtIndex:i] floatValue];
    }
    b0 = b0 / nb;
    
    float cov = 0;
    float da = 0;
    float db = 0;
    for (int i=0; i<MIN(na, nb); i++) {
        cov = cov + ([[a objectAtIndex:i] floatValue] - a0) * ([[b objectAtIndex:i] floatValue]  - b0);
    }
   
    for (int i = 0; i < na; i++) {
        da = da + ([[a objectAtIndex:i] floatValue] - a0) * ([[a objectAtIndex:i] floatValue] - a0);
    }
    
    for (int i = 0; i < nb; i++) {
        db = db + ([[b objectAtIndex:i] floatValue] - b0) * ([[b objectAtIndex:i] floatValue] - b0);
    }
    
    return da == 0 && db == 0 ? 1 : (da == 0 || db == 0 ? 0 : cov / (float)(sqrt(da * db)));
    
}

- (void)fillSequence:(NSMutableArray *)line size:(int)size sequence:(BLPointList *)sequence ofs:(int)ofs {
    //fillSequence function
    //this is the part of algorithm but I can't know what's exactly name of this
    if (line.count == 1) {
        BLNode *point = [line objectAtIndex:0];
        BLNode *node1 = [[BLNode alloc] initWithX:point.x y:point.y t:0];
        BLNode *node2 = [[BLNode alloc] initWithX:point.x y:point.y t:1];
        line = [NSMutableArray arrayWithObjects:node1, node2, nil];
    }
    
    BLNodeList *a = [self toObjectArray:line];
    
    int n = a.t.count;
    float tmax = [[a.t objectAtIndex:n-1] floatValue];
    for (int i=0; i<n; i++) {
        float tmp = [[a.t objectAtIndex:i] floatValue];
        NSNumber *numTmp = [NSNumber numberWithFloat:(tmp/tmax)];
//        if ([a.t objectAtIndex:i]) {
//            [a.t replaceObjectAtIndex:i withObject:numTmp];
//        }
//        else {
//            [a.t insertObject:numTmp atIndex:i];
//        }
        [a.t replaceObjectAtIndex:i withObject:numTmp];
    }
    
    
    NSMutableArray *splicesX = [self buildSpline:a.t y:a.x];
    NSMutableArray *splicesY = [self buildSpline:a.t y:a.y];
    
    
    for (int i=0; i<=size; i++) {
        float t = 1.0 * i / size;
        NSNumber *numberX = [NSNumber numberWithFloat:[self interpolate:splicesX x:t]];
        NSNumber *numberY = [NSNumber numberWithFloat:[self interpolate:splicesY x:t]];
        [sequence.x replaceObjectAtIndex:(ofs+i) withObject:numberX];
        [sequence.y replaceObjectAtIndex:(ofs+i) withObject:numberY];
        
    }
    
}

- (BLPoint *)compare:(NSArray *)stroke1 stroke2:(NSArray *)stroke2 {
    //compare two strokes
    BLNode *emptyNode = [[BLNode alloc] initWithX:0 y:0 t:0];
    NSMutableArray *empty = [NSMutableArray arrayWithObject:emptyNode];
    
    int total = 0;
    for (int i=0; i<MAX(stroke1.count, stroke2.count); i++) {
        NSMutableArray *aline = stroke1.count > i ? [stroke1 objectAtIndex:i] : empty;
        NSMutableArray *bline = stroke2.count > i ? [stroke2 objectAtIndex:i] : empty;
        total += MAX(aline.count, bline.count) * 10 + 1;
    }
    
    BLPointList *a = [[BLPointList alloc] init];
    a.x = [NSMutableArray arrayWithCapacity:total];
    a.y = [NSMutableArray arrayWithCapacity:total];
    BLPointList *b = [[BLPointList alloc] init];
    b.x = [NSMutableArray arrayWithCapacity:total];
    b.y = [NSMutableArray arrayWithCapacity:total];
    
    for (int i=0; i<total; i++) {
        [a.x insertObject:[NSNumber numberWithFloat:0.0f] atIndex:i];
        [a.y insertObject:[NSNumber numberWithFloat:0.0f] atIndex:i];
        [b.x insertObject:[NSNumber numberWithFloat:0.0f] atIndex:i];
        [b.y insertObject:[NSNumber numberWithFloat:0.0f] atIndex:i];
    }
    
    int ofs = 0;
    for (int i=0; i<MAX(stroke1.count, stroke2.count); i++) {
        NSMutableArray *aline = stroke1.count > i ? [stroke1 objectAtIndex:i] : empty;
        NSMutableArray *bline = stroke2.count > i ? [stroke2 objectAtIndex:i] : empty;
        
        int size = MAX(aline.count, bline.count) * 10;
        
        [self fillSequence:aline size:size sequence:a ofs:ofs];
        [self fillSequence:bline size:size sequence:b ofs:ofs];
        ofs += size + 1;
    }
    
    
    BLPoint *returnPoint = [[BLPoint alloc] initWithPositionX:[self correlation:a.x b:b.x] positionY:[self correlation:a.y b:b.y]];
    return returnPoint;
    
}

#pragma mark - CONVERT COLOR FROM HEX STRING
- (UIColor *)colorFromHexString:(NSString *)string {
    NSString *cleanString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    UIColor *color =  [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}

- (void)setStrokeColor:(NSString *)hexString {
    strokeColor = [self colorFromHexString:hexString];
}


@end
