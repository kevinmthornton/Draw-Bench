//
//  RAViewController.h
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/11/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RAViewController : UIViewController <UIScrollViewDelegate> {
    
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UITextField *activeField;
    IBOutlet UITextField *job_number;
    
    //Fields Used to Calculate %RA
    IBOutlet UITextField *initial_field;
    IBOutlet UITextField *final_field;
    IBOutlet UITextView *showPRA;

    // ft. or in. for Original Length
    IBOutlet UISegmentedControl *originalSegment;
    IBOutlet UISegmentedControl *finalSegment;
    
    IBOutlet UIButton *calcRAButton;
}

- (IBAction)shareScreen;
- (void)styleButtons;
- (IBAction)CalculateRA:(id)sender;

@end
