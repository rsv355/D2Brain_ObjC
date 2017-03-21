//
//  TryAgainDialogueViewController.m
//  D2brain
//
//  Created by webmyne systems on 13/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "TryAgainDialogueViewController.h"

@interface TryAgainDialogueViewController ()

@end

@implementation TryAgainDialogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnYes:(id)sender {
    if ([sender tag]==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if ([_delegate respondsToSelector:@selector(getBackFromTryDialogueController:)])
        {
            [_delegate getBackFromTryDialogueController:[NSString stringWithFormat:@"yes%@",_strDialogue]];
        }
    }
    else if ([sender tag]==1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if ([_delegate respondsToSelector:@selector(getBackFromTryDialogueController:)])
        {
            [_delegate getBackFromTryDialogueController:[NSString stringWithFormat:@"no%@",_strDialogue]];
        }
    }
    
}
@end
