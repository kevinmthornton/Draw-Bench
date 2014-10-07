//
//  RAOriginalViewController.h
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/16/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RAOriginalViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UITextField *activeField;
    IBOutlet UITextField *job_number;
    
    // ft. or in. for Original Length
    IBOutlet UISegmentedControl *originalSegment;
    IBOutlet UISegmentedControl *finalSegment;
}

- (IBAction)shareScreen;
- (IBAction)dismissKeyboard:(id)sender ;
-(IBAction)CalculateRA:(id)sender;
-(void)styleButtons;

@end