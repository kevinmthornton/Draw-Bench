//
//  DrawnLengthViewController.h
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/13/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawnLengthViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UITextField *activeField;
    
    IBOutlet UITextField *initialField;
    IBOutlet UITextField *raField;
    IBOutlet UITextField *pointField;
    IBOutlet UITextView *drawnLengthTextView;
    
}

- (IBAction)shareScreen;

-(void)styleButtons;

-(IBAction)dismissKeyboard:(id)sender;

-(IBAction)EstimateDrawnLenght:(id)sender;


@end
