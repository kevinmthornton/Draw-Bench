//
//  ExtrusionLengthViewController.m
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/13/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import "ExtrusionLengthViewController.h"

@interface ExtrusionLengthViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *minFinalLengthSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *maxFinalLengthSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pointLengthSegment;
@property (strong, nonatomic) IBOutlet UITextField *min_final_field_2;
@property (strong, nonatomic) IBOutlet UITextField *max_final_field_2;
@property (strong, nonatomic) IBOutlet UITextField *RA_field_2;
@property (strong, nonatomic) IBOutlet UITextField *point_field_2;
@property (strong, nonatomic) IBOutlet UIButton *calcExtrusionLengthButton;
@property (strong, nonatomic) IBOutlet UITextView *showExtruded;

@end

@implementation ExtrusionLengthViewController
@synthesize mainScrollView = _mainScrollView;
@synthesize min_final_field_2 = _min_final_field_2;
@synthesize max_final_field_2 = _max_final_field_2;
@synthesize RA_field_2 = _RA_field_2;
@synthesize point_field_2 = _point_field_2;
@synthesize showExtruded = _showExtruded;


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
    
    [self styleButtons];
}

// so self.mainScrollView works with the Use Autolayout check in the IB ViewController
-(void)viewDidLayoutSubviews {
    self.mainScrollView.contentSize = CGSizeMake(320.0f, 300.0f);
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
    NSString *textToShare = @"Extrusion Length Screen Shot";
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
    // proceed button on first view
    CALayer * extrusionLengthLayer = [self.calcExtrusionLengthButton layer];
    [extrusionLengthLayer setMasksToBounds:YES];
    [extrusionLengthLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [extrusionLengthLayer setBorderWidth:1.0];
    [extrusionLengthLayer setBorderColor:[[UIColor grayColor] CGColor]];
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
#pragma mark Calculation

 -(IBAction)EstimateExtrusionLenght:(id)sender{
 
 // when this button is clicked, dismiss the keyboard
 [self dismissKeyboard:sender];
 
 NSString *min_final = self.min_final_field_2.text;
 NSString *max_final = self.max_final_field_2.text;
 NSString *RA    = self.RA_field_2.text;
 NSString *point = self.point_field_2.text;
 
 double min_final_value = [min_final doubleValue];
 double max_final_value = [max_final doubleValue];
 double RA_value    = [RA doubleValue];
 double point_value = [point doubleValue];
 double in2ft       = 12.0; //12 inches per foot
 double percent     = 100; // convert number to %
 
 
 // Use ft as the common unit length
 NSString *pointLength = [self.pointLengthSegment titleForSegmentAtIndex:self.pointLengthSegment.selectedSegmentIndex];
     if ([pointLength isEqualToString:@"in."]) {
         // inches selected for original length
         point_value = point_value/in2ft;
     } else {
     // feet selected for point length, no conversion reqrd
     }
 
 NSString *min_output_string = @"";
 NSString *max_output_string = @"";
 
 if ([min_final isEqualToString:@""]){
     //do nothing
     min_output_string = [NSString stringWithFormat:@"MIN:"];
 } else {
     // Use ft as the common unit length
     NSString *minFinalLength = [self.minFinalLengthSegment titleForSegmentAtIndex:self.minFinalLengthSegment.selectedSegmentIndex];
     if ([minFinalLength isEqualToString:@"in."]) {
         min_final_value = min_final_value/in2ft;
         // inches selected for final length
     } else {
         // feet selected for original length, no conversion reqrd
     }
     double min_extruded_value_ft = min_final_value*(1.0-RA_value/percent);
     min_extruded_value_ft        = min_extruded_value_ft + point_value;
     double min_extruded_value_in = min_extruded_value_ft*12;
     min_output_string = [NSString stringWithFormat:@"MIN:\t\t%.2f ft. (%.1f in.)", min_extruded_value_ft, min_extruded_value_in];
 }
 
 
 if ([max_final isEqualToString:@""]){
     //do nothing
     max_output_string = [NSString stringWithFormat:@"MAX:"];
 } else {
     // Use ft as the common unit length
     NSString *maxFinalLength = [self.maxFinalLengthSegment titleForSegmentAtIndex:self.maxFinalLengthSegment.selectedSegmentIndex];
     if ([maxFinalLength isEqualToString:@"in."]) {
         max_final_value = max_final_value/in2ft;
         // inches selected for final length
    } else {
        // feet selected for original length, no conversion reqrd
    }
        double max_extruded_value_ft = max_final_value*(1.0-RA_value/percent);
        max_extruded_value_ft        = max_extruded_value_ft + point_value;
        double max_extruded_value_in = max_extruded_value_ft*12;
        max_output_string = [NSString stringWithFormat:@"MAX:\t%.2f ft. (%.1f in.)", max_extruded_value_ft, max_extruded_value_in];
 }
 
 self.showExtruded.text = [NSString stringWithFormat:@"Requred Extruded Lengths\n%@\n%@", min_output_string, max_output_string];
 
 //self.showExtruded.text = [NSString stringWithFormat:@"Rqrd. Extruded Length: %.2f ft. (%.1f in.)", max_extruded_value_ft, max_extruded_value_in];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
