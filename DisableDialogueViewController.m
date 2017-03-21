//
//  DisableDialogueViewController.m
//  D2brain
//
//  Created by webmyne systems on 11/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "DisableDialogueViewController.h"

@interface DisableDialogueViewController ()

@end

@implementation DisableDialogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    

    NSString *deviceName=[[UIDevice currentDevice]name];
    if ([deviceName containsString:@"iPad"]) {
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1.6, 1.6);
        [self.view setTransform:transform];
    }
    else
    {
      
    }

    [self.btnPower setUserInteractionEnabled:NO];
    [self.btnBottom setUserInteractionEnabled:NO];
    [self.btnAddScene setUserInteractionEnabled:NO];
    [self.btnFavourite setUserInteractionEnabled:NO];
    
    [self setButtonDisplay];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setButtonDisplay
{
    self.btnFavouriteContainer.layer.borderWidth=1.5f;
    self.btnAddSceneContainer.layer.borderWidth=1.5f;
    self.btnUpContainer.layer.borderWidth=1.5f;
    self.btnAddSceneContainer.layer.cornerRadius=20.0f;
    self.btnFavouriteContainer.layer.cornerRadius=20.0f;
    self.btnUpContainer.layer.cornerRadius=20.0f;
    self.btnFavouriteContainer.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnAddSceneContainer.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnUpContainer.layer.borderColor=[UIColor colorWithRed:(0/255.0) green:(153/255.0) blue:(135/255.0) alpha:1.0].CGColor;
    [self.btnBottom setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
    [self.btnFavourite setImage:[UIImage imageNamed:@"w_heart13.png"] forState:UIControlStateNormal];
    [self.btnAddScene setImage:[UIImage imageNamed:@"w_add98.png"] forState:UIControlStateNormal];
    
}


- (IBAction)btnActiveMachines:(id)sender {
//    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"viewShow"];
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ADD_MACHINE"];
    [self presentViewController:viewController animated:YES completion:nil];
}
@end
