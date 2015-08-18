//
//  BLViewController.m
//  BLSignature
//
//  Created by Bao Lan Le Quang on 5/28/15.
//  Copyright (c) 2015 Bao Lan Le Quang. All rights reserved.
//

#import "BLViewController.h"

@interface BLViewController () {
    BLSignatureView *blSignatureView; //variable for signature view
}

@end

@implementation BLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init signature view
    blSignatureView = [[[NSBundle mainBundle] loadNibNamed:@"BLSignatureView" owner:self options:nil] objectAtIndex:0];
    
    //add signature view to current view
    [self.view addSubview:blSignatureView];
    
    blSignatureView.frame = CGRectMake(0, 0, 320, 400);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveSignatureButtonOnClick:(id)sender {
    //save current signature
    [blSignatureView saveSignature];
    _textViewBase64.text = blSignatureView.base64String;
}

- (IBAction)clearSignatureButtonOnClick:(id)sender {
    //clear current signature
    [blSignatureView clearSignature];
}

- (IBAction)compareWithSavedSignature:(id)sender {
    if (!blSignatureView.base64String || [blSignatureView.base64String isEqualToString:@""]) {
        return;
    }
    
    
    NSDictionary *dicResutl = [blSignatureView compareWithSavedSignature];
    NSString *stringResult = [NSString stringWithFormat:@"%@ (%@, %@)", [dicResutl objectForKey:@"result"], [dicResutl objectForKey:@"percentx"], [dicResutl objectForKey:@"percenty"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:stringResult delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
