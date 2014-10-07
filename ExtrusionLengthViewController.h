//
//  ExtrusionLengthViewController.h
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/13/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtrusionLengthViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UITextField *activeField;

    //Fields Used to Calculate and Show Wall Average, 4 Spots
    //IBOutlet UITextField *min_final_field_2;
    //IBOutlet UITextField *max_final_field_2;
    //IBOutlet UITextField *RA_field_2;
    //IBOutlet UITextField *point_field_2;
    //IBOutlet UITextView *showExtruded;
}

- (IBAction)shareScreen;

-(void)styleButtons;

-(IBAction)dismissKeyboard:(id)sender;


-(IBAction)EstimateExtrusionLenght:(id)sender;
@end
