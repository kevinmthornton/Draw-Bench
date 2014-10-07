//
//  DrawnLengthViewController.m
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/13/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import "DrawnLengthViewController.h"

@interface DrawnLengthViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIButton *drawnLengthButton;
@property (strong, nonatomic) IBOutlet UITextField *initialField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *initialSegment;
@property (strong, nonatomic) IBOutlet UITextField *raField;
@property (strong, nonatomic) IBOutlet UITextField *pointField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pointSegment;
@property (strong, nonatomic) IBOutlet UITextView *drawnLengthTextView;

@end

@implementation DrawnLengthViewController

@synthesize mainScrollView = _mainScrollView;
@synthesize drawnLengthButton = _drawnLengthButton;
@synthesize initialField = _initialField;
@synthesize initialSegment = _initialSegment;
@synthesize raField = _raField;
@synthesize pointField = _pointField;
@synthesize pointSegment = _pointSegment;
@synthesize drawnLengthTextView = _drawnLengthTextView;


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
    NSString *textToShare = @"Drawn Length Screen Shot";
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
    CALayer * drawnLengthLayer = [self.drawnLengthButton layer];
    [drawnLengthLayer setMasksToBounds:YES];
    [drawnLengthLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [drawnLengthLayer setBorderWidth:1.0];
    [drawnLengthLayer setBorderColor:[[UIColor grayColor] CGColor]];
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


-(IBAction)EstimateDrawnLenght:(id)sender{
    // when this button is clicked, dismiss the keyboard
    [self dismissKeyboard:sender];
    
    NSString *initial   = self.initialField.text;
    NSString *RA        = self.raField.text;
    NSString *point     = self.pointField.text;
    
    double initial_value    = [initial doubleValue];
    double RA_value         = [RA doubleValue];
    double point_value      = [point doubleValue];
    double in2ft            = 12.0; //12 inches per foot
    double percent          = 100.0; // convert number to %
    
    // Use inches as the common unit length
    NSString *originalLength = [self.initialSegment titleForSegmentAtIndex:self.initialSegment.selectedSegmentIndex];
    if ([originalLength isEqualToString:@"in."]) {
        // inches selected for original length
        initial_value = initial_value/in2ft;
    } else {
        // feet selected for original length, no conversion reqrd
    }

    // Use inches as the common unit length
    NSString *pointLength = [self.pointSegment titleForSegmentAtIndex:self.pointSegment.selectedSegmentIndex];
    if ([pointLength isEqualToString:@"in."]) {
        // inches selected for point length
        point_value = point_value/in2ft;
    } else {
        // feet selected for point length, no conversion reqrd
    }

    initial_value           = initial_value - point_value;
    double drawn_value_ft   = initial_value/(1.0-RA_value/percent);
    double total_value_ft   = drawn_value_ft + point_value;
    
    double drawn_value_in   = drawn_value_ft*12;
    double total_value_in   = total_value_ft*12;
    
    self.drawnLengthTextView.text = [NSString stringWithFormat:@"Drawn Length:\t\t%.2f ft. (%.1f in.)\nTotal Length:\t\t%.2f ft. (%.1f in.)", drawn_value_ft, drawn_value_in, total_value_ft, total_value_in];
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
