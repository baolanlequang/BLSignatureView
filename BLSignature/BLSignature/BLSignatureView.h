//
//  BLSignatureView.h
//  BLSignature
//
//  Created by Bao Lan Le Quang on 5/28/15.
//  Copyright (c) 2015 Bao Lan Le Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLSignatureView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;        //image view for display signature
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;    //image view for display the stroke when drawing signature
@property (strong, nonatomic) NSString *base64String;               //base64 string of signature

- (void)clearSignature; //clear current signature
- (void)saveSignature;  //save signature to base64
- (NSDictionary *)compareWithSavedSignature;    //compare the new signature with the saved signature
- (void)loadSavedData;  //load the saved signature and draw it
- (void)setStrokeColor:(NSString *)hexString;   //set color for stroke of signature with the hex value


@end
