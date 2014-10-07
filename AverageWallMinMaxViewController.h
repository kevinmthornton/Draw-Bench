//
//  AverageWallMinMaxViewController.h
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/12/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AverageWallMinMaxViewController : UIViewController <UIScrollViewDelegate> {

    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UITextField *activeField;
}
- (IBAction)shareScreen;
-(void)styleButtons;
-(IBAction)dismissKeyboard:(id)sender;

@end
