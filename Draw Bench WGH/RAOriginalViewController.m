//
//  RAOriginalViewController.m
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/16/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import "RAOriginalViewController.h"

@interface RAOriginalViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITextField *odOriginalField;
@property (strong, nonatomic) IBOutlet UITextField *odFinalField;
@property (strong, nonatomic) IBOutlet UITextField *wallOrIDOriginalField;
@property (strong, nonatomic) IBOutlet UITextField *wallOrIDFinalField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *originalSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *finalSegment;
@property (strong, nonatomic) IBOutlet UIButton *calcRAButton;
@property (strong, nonatomic) IBOutlet UITextView *showRA;


@end

@implementation RAOriginalViewController

@synthesize mainScrollView = _mainScrollView;
@synthesize activeField = _activeField;

@synthesize odOriginalField = _odOriginalField;
@synthesize odFinalField = _odFinalField;
@synthesize wallOrIDOriginalField = _wallOrIDOriginalField;
@synthesize wallOrIDFinalField = _wallOrIDFinalField;

@synthesize originalSegment = _originalSegment;
@synthesize finalSegment = _finalSegment;
@synthesize  calcRAButton = _calcRAButton;


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
    NSString *textToShare = @"RA Original Screen Shot";
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
    
    NSString *initial_OD    = self.odOriginalField.text;
    NSString *initial_wall  = self.wallOrIDOriginalField.text;
    NSString *final_OD      = self.odFinalField.text;
    NSString *final_wall    = self.wallOrIDFinalField.text;
    
    double PI                 = 3.14159265358979; //PI constant
    double initial_OD_value   = [initial_OD doubleValue];
    double final_OD_value     = [final_OD doubleValue];
    
    double initial_wall_value;
    double initial_ID_value;
    
    double final_wall_value;
    double final_ID_value;
    
    // Use inches as the common unit length.
    NSString *originalLength = [self.originalSegment titleForSegmentAtIndex:self.originalSegment.selectedSegmentIndex];
    if ([originalLength isEqualToString:@"Wall"]) {
        // inches selected for original length, no conversion reqrd
        initial_wall_value = [initial_wall doubleValue];
        initial_ID_value   = initial_OD_value-2*initial_wall_value;
    } else {
        // feet selected for original length
        initial_ID_value   = [initial_wall doubleValue];
    }
    
    NSString *finalLength = [self.finalSegment titleForSegmentAtIndex:self.finalSegment.selectedSegmentIndex];
    if ([finalLength isEqualToString:@"Wall"]) {
        // inches selected for final length, no conversion reqrd
        final_wall_value = [final_wall doubleValue];
        final_ID_value   = final_OD_value-2*final_wall_value;
    } else {
        // feet selected for final length
        final_ID_value   = [final_wall doubleValue];
    }
    
    double initial_cross_area = (initial_OD_value*initial_OD_value-initial_ID_value*initial_ID_value)*PI/4;
    double final_cross_area = (final_OD_value*final_OD_value-final_ID_value*final_ID_value)*PI/4;
    double percent       = 100.0; // convert number to %
    double percent_RA    = (initial_cross_area-final_cross_area)/initial_cross_area*percent;
    self.showRA.text         = [NSString stringWithFormat:@"Calculated %%RA: %.2f %%", percent_RA];
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
