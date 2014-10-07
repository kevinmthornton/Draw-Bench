//
//  RAViewController.m
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/11/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import "RAViewController.h"

@interface RAViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIButton *calcRAButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *originalSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *finalSegment;
@property (strong, nonatomic) IBOutlet UITextView *showPRA;
@end

@implementation RAViewController

@synthesize mainScrollView = _mainScrollView;
@synthesize  calcRAButton = _calcRAButton;
@synthesize originalSegment = _originalSegment;
@synthesize finalSegment = _finalSegment;
@synthesize showPRA = _showPRA;

#pragma mark views

- (void)viewDidLoad {
    [super viewDidLoad];
	// add a tap gesture so we can dismiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    // register that we will recieve keyboard notifications
    [self registerForKeyboardNotifications];
    
    [self.mainScrollView setDelegate:self];
    [self.mainScrollView setScrollEnabled:YES];
    
    // set up for which field will be active with textFieldDidBeginEditing:
    // this will vary depending on which field they chose
    activeField = [[UITextField alloc] init];
    
    // put border and color to buttons
    [self styleButtons];
}

// share button in bottom right to show the activity monitor for email/text of screen shot
- (IBAction)shareScreen {
    // screen capture
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // create the activity controller
    // text to put into body
    NSString *textToShare = @"RA 1-1 Stencil Screen Shot";
    // put text and screen shot into array to send to activity controller
    NSArray *itemsToShare = @[textToShare, screenShot];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    
    //take out whichever is not needed
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact];
    // show it
    [self presentViewController:activityVC animated:YES completion:nil];
}

// set button style
-(void)styleButtons {
    // calculate RA button
    CALayer * calcRALayer = [self.calcRAButton layer];
    [calcRALayer setMasksToBounds:YES];
    [calcRALayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [calcRALayer setBorderWidth:1.0];
    [calcRALayer setBorderColor:[[UIColor grayColor] CGColor]];
    
}

// so self.mainScrollView works with the Use Autolayout check in the IB ViewController
-(void)viewDidLayoutSubviews {
    self.mainScrollView.contentSize = CGSizeMake(320.0f, 300.0f);
}


#pragma mark keyboard

// register the notification for the keyboard actions
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    // [sender resignFirstResponder]; // doesn't work as well
    [self.view endEditing:YES];
}

// called when the UIKeyboardDidShowNotification is sent
- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    // the example from Apple doesn't work on iOS 7
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.mainScrollView.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = activeField.frame.origin;
    origin.y -= self.mainScrollView.contentOffset.y;
    
    if (!CGRectContainsPoint(aRect, origin) ) {
        // user we use [mainDcrollView setContentOffset:] instead???
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(20.0, 0.0, 100.0, 0.0);// move up 100 points
        self.mainScrollView.contentInset = contentInsets;
        self.mainScrollView.scrollIndicatorInsets = contentInsets;
    }
}

// called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [self.mainScrollView setContentOffset:CGPointZero animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}

#pragma mark calculations


-(IBAction)CalculateRA:(id)sender {
    // when this button is clicked, dismiss the keyboard
    [self dismissKeyboard:sender];
    
    NSString *initial    = initial_field.text;
    NSString *final      = final_field.text;
    double initial_value = [initial doubleValue];
    double final_value   = [final doubleValue];
    double in2ft         = 12.0;  //12 inches per foot
    
    // Use inches as the common unit length
    NSString *originalLength = [self.originalSegment titleForSegmentAtIndex:self.originalSegment.selectedSegmentIndex];
    if ([originalLength isEqualToString:@"in."]) {
        // inches selected for original length, no conversion reqrd
    } else {
        // feet selected for original length
        initial_value = initial_value*in2ft; // Convert to inches
    }
    
    NSString *finalLength = [self.finalSegment titleForSegmentAtIndex:self.finalSegment.selectedSegmentIndex];
    if ([finalLength isEqualToString:@"in."]) {
        // inches selected for final length, no conversion reqrd
    } else {
        // feet selected for final length
        final_value = final_value*in2ft;  // Convert to inches
    }
    
    double percent       = 100.0; // convert number to %
    double percent_RA    = (1-1.0*initial_value/final_value)*percent;
    self.showPRA.text         = [NSString stringWithFormat:@"Calculated %%RA: %.2f %%", percent_RA];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
