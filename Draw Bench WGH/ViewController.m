//
//  ViewController.m
//  Draw Bench WGH
//
//  Created by kevin thornton on 6/2/14.
//  Copyright (c) 2014 Wyman-Gordon. All rights reserved.
/*
 !! SEPARATE view controllers once we get this working !!
 */

#import "ViewController.h"
// for buttons
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *proceedButton;
@property (strong, nonatomic) IBOutlet UIButton *wpfButton;
@property (strong, nonatomic) IBOutlet UIButton *raButton;
@property (strong, nonatomic) IBOutlet UIButton *awMMButton;
@property (strong, nonatomic) IBOutlet UIButton *awFourSpots;
@property (strong, nonatomic) IBOutlet UIButton *drawnLengthButton;
@property (strong, nonatomic) IBOutlet UIButton *extrusionLengthButton;
@property (strong, nonatomic) IBOutlet UIButton *raOriginalButton;
@property (strong, nonatomic) IBOutlet UIImageView *pipesImageView;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;
@end



@implementation ViewController

@synthesize proceedButton = _proceedButton;
@synthesize wpfButton = _wpfButton;
@synthesize raButton = _raButton;
@synthesize awMMButton =_awMMButton;
@synthesize drawnLengthButton;
@synthesize documentInteractionController = _documentInteractionController;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // put border and color to buttons
    [self styleButtons];
    
}

// set button style
- (void)styleButtons {
    // proceed button on first view
    CALayer * proceedLayer = [self.proceedButton layer];
    [proceedLayer setMasksToBounds:YES];
    [proceedLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [proceedLayer setBorderWidth:1.0];
    [proceedLayer setBorderColor:[[UIColor grayColor] CGColor]];
    
    // wpf button on second view
    CALayer * wpfLayer = [self.wpfButton layer];
    [wpfLayer setMasksToBounds:YES];
    [wpfLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [wpfLayer setBorderWidth:1.0];
    [wpfLayer setBorderColor:[[UIColor grayColor] CGColor]];
    // move the text off the left hand edge
    [self.wpfButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 2.0f, 0.0f, 0.0f)];
    
    // RA button on second view
    CALayer * raLayer = [self.raButton layer];
    [raLayer setMasksToBounds:YES];
    [raLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [raLayer setBorderWidth:1.0];
    [raLayer setBorderColor:[[UIColor grayColor] CGColor]];
    // move the text off the left hand edge
    [self.raButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 2.0f, 0.0f, 0.0f)];
    
    // RA button on second view
    CALayer * raOrigLayer = [self.raOriginalButton layer];
    [raOrigLayer setMasksToBounds:YES];
    [raOrigLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [raOrigLayer setBorderWidth:1.0];
    [raOrigLayer setBorderColor:[[UIColor grayColor] CGColor]];
    // move the text off the left hand edge
    [self.raOriginalButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 2.0f, 0.0f, 0.0f)];
    
    // average wall min/max button on second view
    CALayer * awMMLayer = [self.awMMButton layer];
    [awMMLayer setMasksToBounds:YES];
    [awMMLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [awMMLayer setBorderWidth:1.0];
    [awMMLayer setBorderColor:[[UIColor grayColor] CGColor]];
    // move the text off the left hand edge
    [self.awMMButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 2.0f, 0.0f, 0.0f)];
    
    // four walls button on second view
    CALayer * awFourLayer = [self.awFourSpots layer];
    [awFourLayer setMasksToBounds:YES];
    [awFourLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [awFourLayer setBorderWidth:1.0];
    [awFourLayer setBorderColor:[[UIColor grayColor] CGColor]];
    // move the text off the left hand edge
    [self.awFourSpots setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 2.0f, 0.0f, 0.0f)];
    
    // drawn length button on second view
    CALayer * drawnLengthLayer = [self.drawnLengthButton layer];
    [drawnLengthLayer setMasksToBounds:YES];
    [drawnLengthLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [drawnLengthLayer setBorderWidth:1.0];
    [drawnLengthLayer setBorderColor:[[UIColor grayColor] CGColor]];
    // move the text off the left hand edge
    [self.drawnLengthButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 2.0f, 0.0f, 0.0f)];
   
    // extrusion length button on second view
    CALayer * extrusionLengthLayer = [self.extrusionLengthButton layer];
    [extrusionLengthLayer setMasksToBounds:YES];
    [extrusionLengthLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [extrusionLengthLayer setBorderWidth:1.0];
    [extrusionLengthLayer setBorderColor:[[UIColor grayColor] CGColor]];
    // move the text off the left hand edge
    [self.extrusionLengthButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 2.0f, 0.0f, 0.0f)];
    
    // extrusion length button on second view
    CALayer * pipesLayer = [self.pipesImageView layer];
    [pipesLayer setMasksToBounds:YES];
    [pipesLayer setCornerRadius:8.0]; //when radius is 0, the border is a rectangle
    [pipesLayer setBorderWidth:1.0];
    [pipesLayer setBorderColor:[[UIColor grayColor] CGColor]];
    
}

// for viewing the requirements PDF
- (IBAction)previewDocument:(id)sender {
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"Draw-Bench-Requirements" withExtension:@"pdf"];
    
    if (URL) {
        // init documentInteractionController
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        [self.documentInteractionController setDelegate:self];
        
        // preview PDF
        [self.documentInteractionController presentPreviewAnimated:YES];
    }
}

// MUST implement this for delegate
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

