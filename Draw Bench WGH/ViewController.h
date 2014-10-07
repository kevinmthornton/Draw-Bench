//
//  ViewController.h
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/2/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

float percent_RA;
float weight_per_foot;

@interface ViewController : UIViewController <UIDocumentInteractionControllerDelegate> {
    // UI pieces for second view
    IBOutlet UIButton *proceedButton;
    IBOutlet UIButton *wpfButton;
    IBOutlet UIButton *raButton;
    UIDocumentInteractionController *documentInteractionController;
}

-(void)styleButtons;
- (IBAction)previewDocument:(id)sender;

@end

