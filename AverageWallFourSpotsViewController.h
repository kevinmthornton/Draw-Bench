//
//  AverageWallFourSpotsViewController.h
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/12/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AverageWallFourSpotsViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UITextField *activeField;
 
    //Fields Used to Calculate and Show Wall Average, 4 Spots
    IBOutlet UITextField *wallField12;
    IBOutlet UITextField *wallField3;
    IBOutlet UITextField *wallField6;
    IBOutlet UITextField *wallField9;
    IBOutlet UITextView *showWallTextView;
    IBOutlet UIButton *calcWallAverageButton;
}

- (IBAction)shareScreen;
-(void)styleButtons;
-(IBAction)dismissKeyboard:(id)sender;
-(IBAction)CalculateWall4:(id)sender;

@end
