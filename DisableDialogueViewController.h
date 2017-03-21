//
//  DisableDialogueViewController.h
//  D2brain
//
//  Created by webmyne systems on 11/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisableDialogueViewController : UIViewController
- (IBAction)btnActiveMachines:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFavourite;
@property (weak, nonatomic) IBOutlet UIButton *btnAddScene;
@property (weak, nonatomic) IBOutlet UIButton *btnBottom;
@property (weak, nonatomic) IBOutlet UIButton *btnPower;


@property (weak, nonatomic) IBOutlet UIView *btnFavouriteContainer;
@property (weak, nonatomic) IBOutlet UIView *btnAddSceneContainer;

@property (weak, nonatomic) IBOutlet UIView *btnUpContainer;

@end
