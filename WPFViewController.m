//
//  WPFViewController.m
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/5/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import "WPFViewController.h"

@interface WPFViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) NSArray *alloyPickerArray;
@property (strong, nonatomic) UIPickerView *alloyDensityPicker;
@property (strong, nonatomic) UIView *alloyDensityView;
@property (strong, nonatomic) IBOutlet UIButton *selectDensityButton;
@property (strong, nonatomic) IBOutlet UITextField *density_field;
@property (strong, nonatomic) IBOutlet UITextField *OD_field;
@property (strong, nonatomic) IBOutlet UIButton *selectIDButton;
@property (strong, nonatomic) IBOutlet UITextField *wall_field;
@property (strong, nonatomic) IBOutlet UITextField *wallOrID;
@property (strong, nonatomic) IBOutlet UISegmentedControl *wallOrIDSegment;
@property (strong, nonatomic) IBOutlet UIButton *calcWPFButton;

// bottom blank text field to be filled in with calculation
@property (strong, nonatomic) IBOutlet UITextView *ShowWPF;
@property (strong, nonatomic) IBOutlet UIButton *shareScreenButton;

@end

@implementation WPFViewController

// calculating view
@synthesize mainScrollView = _mainScrollView;
@synthesize alloyPickerArray = _alloyPickerArray;
@synthesize alloyDensityPicker = _alloyDensityPicker;
@synthesize selectDensityButton = _selectDensityButton;
@synthesize selectIDButton = _selectIDButton;
@synthesize alloyDensityView = _alloyDensityView;
@synthesize calcWPFButton = _calcWPFButton;
@synthesize density_field = _density_field;
@synthesize OD_field = _OD_field;
@synthesize wall_field = _wall_field;
@synthesize wallOrID = _wallOrID;
@synthesize wallOrIDSegment = _wallOrIDSegment;
@synthesize ShowWPF = _ShowWPF;
@synthesize shareScreenButton = _shareScreenButton;

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
    
    // picker lists
    self.alloyDensityPicker = [[UIPickerView alloc] init];
    [self.alloyDensityPicker setTag:1];
    [self.alloyDensityPicker setDelegate:self];
    
    // fill in picker lists with values
    [self createPickerLists];
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
    NSString *textToShare = @"Weight Per Foot Screen Shot";
    // put text and screen shot into array to send to activity controller
    NSArray *itemsToShare = @[textToShare, screenShot];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];

    //take out whichever is not needed
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact];
    // show it
    [self presentViewController:activityVC animated:YES completion:nil];
}

// give them rounded corners and a border
-(void)styleButtons {
    // calculate wpf button
    CALayer * calcWPFLayer = [self.calcWPFButton layer];
    [calcWPFLayer setMasksToBounds:YES];
    [calcWPFLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [calcWPFLayer setBorderWidth:1.0];
    [calcWPFLayer setBorderColor:[[UIColor grayColor] CGColor]];
    
    // choose alloy density button
    CALayer * selectDensityLayer = [self.selectDensityButton layer];
    [selectDensityLayer setMasksToBounds:YES];
    [selectDensityLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [selectDensityLayer setBorderWidth:1.0];
    [selectDensityLayer setBackgroundColor:[[UIColor blueColor] CGColor]];
    
    // choose alloy density button
    CALayer * selectIDLayer = [self.selectIDButton layer];
    [selectIDLayer setMasksToBounds:YES];
    [selectIDLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [selectIDLayer setBorderWidth:1.0];
    [selectIDLayer setBackgroundColor:[[UIColor blueColor] CGColor]];
    
}

#pragma mark picker list

// put picker into view and have it slide up/down with actions
// button on slider view that says 'choose alloy...' slides up view with picker and done button
// when done is clicked, value is filled into alloyDensityPicker field
// must detect screen size

-(void)createPickerLists {
    // put value in array for alloyDensityPicker picker list
    self.alloyPickerArray = [[NSArray alloc] initWithObjects:@"Alloy 028: 0.29", @"Alloy 825: 0.294", @"Alloy C-276: 0.321", @"G-3: 0.294", @"Super Duplex 25Cr: 0.285", @"945X: 0.296", nil];
    
    // set up the picker lists on hidden views that will be shown when 'choose...' buttons are clicked
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    // place this just off screen at the bottom the width of the main screen and a height of 250
    self.alloyDensityView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 250)];
    [self.alloyDensityView setBackgroundColor:[UIColor grayColor]];
    [self.alloyDensityView addSubview:self.alloyDensityPicker];
    
    // done button for alloy picker list
    UIButton *donePickingAlloy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [donePickingAlloy addTarget:self
                         action:@selector(closeAlloyPickerView)
               forControlEvents:UIControlEventTouchUpInside];
    [donePickingAlloy setTitle:@"Done" forState:UIControlStateNormal];
    [donePickingAlloy setFrame:CGRectMake((screenWidth/2)-50, 8, 100, 30)];
    
    // style the Done button
    CALayer *donePickingAlloyLayer = [donePickingAlloy layer];
    [donePickingAlloyLayer setMasksToBounds:YES];
    [donePickingAlloyLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [donePickingAlloyLayer setBorderWidth:1.0];
    [donePickingAlloyLayer setBorderColor:[[UIColor blackColor] CGColor]];
    
    // add the button to the view
    [self.alloyDensityView addSubview:donePickingAlloy];
    
    // finally, add this into the view
    [self.view addSubview:self.alloyDensityView];
} // end createPickerLists

// animate the alloy picker view up
-(IBAction)openAlloyPickerView {
    // to see if we need to move this up
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    // the frame of the alloyDensityView
    CGRect initAlloyDensityViewFrame = self.alloyDensityView.frame;
    
    // only move up if it's Y is equal to the screenHeight, it's original setting
    // is this frame already up? if so, do nothing
    if (initAlloyDensityViewFrame.origin.y == screenHeight) {
        // set movedAlloyDensityViewFrameUp to 250 pts higher than it currently is which SHOULD be below the main screen frame
        CGRect movedAlloyDensityViewFrameUp = CGRectMake(initAlloyDensityViewFrame.origin.x, initAlloyDensityViewFrame.origin.y - 250, initAlloyDensityViewFrame.size.width, initAlloyDensityViewFrame.size.height);
        
        [UIView animateWithDuration:0.7
                         animations:^{self.alloyDensityView.frame = movedAlloyDensityViewFrameUp;}
                         completion:nil];
    }
}

// enter the value from the aloy_density picker list and then scroll this down
-(void)closeAlloyPickerView {
    // get the value from the picker list, cast as an (int)
    int index = (int)[self.alloyDensityPicker selectedRowInComponent:0];
    NSString *pickerValue = [self.alloyPickerArray objectAtIndex:index];
    
    if ([pickerValue isEqualToString:@"Alloy 028: 0.29"]) {
        [self.density_field setText:@"0.29"];
    } else if ([pickerValue isEqualToString:@"Alloy 825: 0.294"]) {
        [self.density_field setText:@"0.294"];
    } else if ([pickerValue isEqualToString:@"Alloy C-276: 0.321"]) {
        [self.density_field setText:@"0.321"];
    } else if ([pickerValue isEqualToString:@"G-3: 0.294"]) {
        [self.density_field setText:@"0.294"];
    } else if ([pickerValue isEqualToString:@"Super Duplex 25Cr: 0.285"]) {
        [self.density_field setText:@"0.285"];
    }  else if ([pickerValue isEqualToString:@"945X: 0.296"]) {
        [self.density_field setText:@"0.296"];
    }
    
    // animate the frame down by 250 points so it is off screen
    CGRect initAlloyDensityViewFrame = self.alloyDensityView.frame;
    CGRect movedAlloyDensityViewFrameUp = CGRectMake(initAlloyDensityViewFrame.origin.x, initAlloyDensityViewFrame.origin.y + 250, initAlloyDensityViewFrame.size.width, initAlloyDensityViewFrame.size.height);
    
    [UIView animateWithDuration:0.7
                     animations:^{self.alloyDensityView.frame = movedAlloyDensityViewFrameUp;}
                     completion:nil];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //set number of rows based on which list this is marked by the tag set in fillPickerLists
    if (pickerView.tag == 1) {
        return self.alloyPickerArray.count;
    }
    
//    else if (pickerView.tag == 2) {
//        return self.idArray.count;
//    }
    
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //set item per row  based on which list this is marked by the tag set in fillPickerLists
    if (pickerView.tag == 1) {
       return [self.alloyPickerArray objectAtIndex:row];
    }
    // was for second picker tag; this is how you create two picker lists on the page page
//    else if (pickerView.tag == 2){
//       return [self.idArray objectAtIndex:row];
//    }
    
    return @"No list";
}

// the value that is present
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
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

// when you start editing a field, set the activeField to whichever is being edited
// the in keyboardWasShown:, the activeField is referenced and used to move around the 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}

#pragma mark calculations
-(IBAction)CalculateWPF:(id)sender{
    // when this button is clicked, dismiss the keyboard
    [self dismissKeyboard:sender];
    
    NSString *density   = self.density_field.text;
    NSString *OD        = self.OD_field.text;
    NSString *wall      = self.wall_field.text;
    
    double density_value    = [density doubleValue];
    double OD_value         = [OD doubleValue];
    double wall_value;
    double ID_value;
    
    //choose Wall or ID from segment control
    NSString *pickerValue = [self.wallOrIDSegment titleForSegmentAtIndex:self.wallOrIDSegment.selectedSegmentIndex];
    if ([pickerValue isEqualToString:@"ID"]) {
        ID_value   = [wall doubleValue];
    } else {
        wall_value = [wall doubleValue];
        ID_value   = OD_value-2*wall_value;
    }
    //Down to here
    
    double in2ft            	= 12.0;  //12 inches per foot
    double PI               	= 3.14159265358979; //PI constant
    double cross_area       = (OD_value*OD_value-ID_value*ID_value)*1.0/4.0*PI;
    double WPF             	 = cross_area*in2ft*density_value;
    
    self.ShowWPF.text = [NSString stringWithFormat:@"Cross-Area:\t%.2f in.^2\nWeight/Foot:\t%.2f lbs./ft.", cross_area, WPF];
    
    /* OLD - before wall/id picker
    NSString *density   = self.density_field.text;
    NSString *OD        = self.OD_field.text;
    NSString *wall      = self.wall_field.text;
    
    double density_value    = [density doubleValue];
    double OD_value         = [OD doubleValue];
    double wall_value       = [wall doubleValue];
    double in2ft            = 12.0;  //12 inches per foot
    double ID_value         = OD_value-2*wall_value;
    double PI               = 3.14159265358979; //PI constant
    double cross_area       = (OD_value*OD_value-ID_value*ID_value)*1.0/4.0*PI;
    double WPF              = cross_area*in2ft*density_value;
    
    self.ShowWPF.text = [NSString stringWithFormat:@"Cross-Area:\t%.2f in.^2\nWeight/Foot:\t%.2f lbs./ft.", cross_area, WPF];
    */
}

@end
