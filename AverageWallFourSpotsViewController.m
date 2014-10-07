//
//  AverageWallFourSpotsViewController.m
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/12/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import "AverageWallFourSpotsViewController.h"

@interface AverageWallFourSpotsViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;


//Fields Used to Calculate and Show Wall Average, 4 Spots
@property (strong, nonatomic) IBOutlet UITextField *wallField12;
@property (strong, nonatomic) IBOutlet UITextField *wallField3;
@property (strong, nonatomic) IBOutlet UITextField *wallField6;
@property (strong, nonatomic) IBOutlet UITextField *wallField9;
@property (strong, nonatomic) IBOutlet UIButton *calcWallAverageButton;
@property (strong, nonatomic) IBOutlet UITextView *showWallTextView;

@end

@implementation AverageWallFourSpotsViewController
@synthesize mainScrollView = _mainScrollView;
@synthesize wallField12 = _wallField12;
@synthesize wallField3 = _wallField3;
@synthesize wallField6 = _wallField6;
@synthesize wallField9 = _wallField9;
@synthesize calcWallAverageButton = _calcWallAverageButton;
@synthesize showWallTextView = _showWallTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // add a tap gesture so we can dismiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    // register that we will recieve keyboard notifications
    [self registerForKeyboardNotifications];
    
    [self.mainScrollView setDelegate:self];
    [self.mainScrollView setScrollEnabled:YES];
    [self.mainScrollView setContentSize:CGSizeMake(320, 280)];
    
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
    NSString *textToShare = @"Average Wall 4 Positions Screen Shot";
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
    CALayer * calcWALayer = [self.calcWallAverageButton layer];
    [calcWALayer setMasksToBounds:YES];
    [calcWALayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [calcWALayer setBorderWidth:1.0];
    [calcWALayer setBorderColor:[[UIColor grayColor] CGColor]];
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
-(IBAction)CalculateWall4:(id)sender{
    // when this button is clicked, dismiss the keyboard
    [self dismissKeyboard:sender];
    
    NSString *wall_1 = self.wallField12.text;
    NSString *wall_2 = self.wallField3.text;
    NSString *wall_3 = self.wallField6.text;
    NSString *wall_4 = self.wallField9.text;
    
    double wall_1_value = [wall_1 doubleValue];
    double wall_2_value = [wall_2 doubleValue];
    double wall_3_value = [wall_3 doubleValue];
    double wall_4_value = [wall_4 doubleValue];
    double wall_avg     = (wall_1_value+wall_2_value+wall_3_value+wall_4_value)/4.0;
    self.showWallTextView.text      = [NSString stringWithFormat:@"Wall Average: %.3f in.", wall_avg];
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
