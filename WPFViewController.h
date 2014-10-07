//
//  WPFViewController.h
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/5/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPFViewController : UIViewController<UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UITextField *activeField;

    // alloy picker properties
    NSArray *alloyPickerArray;
    UIPickerView *alloyDensityPicker;
    UIView *alloyDensityView;

    IBOutlet UITextField *job_number;
    IBOutlet UIButton *selectDensityButton;
    IBOutlet UIButton *selectIDButton;
        
    //Fields Used to Calculate Weight Per Foot
    IBOutlet UITextField *density_field;
    IBOutlet UITextField *OD_field;
    IBOutlet UITextField *wall_field;
    IBOutlet UITextField *wallOrID;
    IBOutlet UISegmentedControl *wallOrIDSegment;
    IBOutlet UIButton *calcWPFButton;
    IBOutlet UITextView *ShowWPF;

    }

- (IBAction)shareScreen;

-(void)styleButtons;
// picker view methods
-(void)createPickerLists;

// slide up/down the alloy picker
-(IBAction)openAlloyPickerView;
-(void)closeAlloyPickerView;

// finally do the calculation
-(IBAction)CalculateWPF:(id)sender;

@end
