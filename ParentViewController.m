//
//  ParentViewController.m
//  D2brain
//
//  Created by webmyne systems on 03/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "ParentViewController.h"
#import "DashboardViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
   // storyboardID
    NSString *storyboardID=[[NSUserDefaults standardUserDefaults]objectForKey:@"storyboardID"];
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSubContent:(NSString*)storyboardID{
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
    if (_content) {
        [_content removeFromParentViewController];
        [_content.view removeFromSuperview];
        if ([_content isKindOfClass:[DashboardViewController class]]) {
            [(DashboardViewController*)_content removeAll];
        }
    }
    
    _content = vc;
    [self addChildViewController:_content];
    _content.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:_content.view];
    [_content didMoveToParentViewController:self];
    
      // NSArray *defaultsMenuitemIdentifire = [[NSArray alloc] initWithObjects:@"MAINCONTAINER1",@"SCENE_LIST",@"FAVOURITE_DRAWER",@"SCHEDULER",@"",@"ADD_MACHINE",@"SETTING",@"ABOUT_US",@"CONTACT_US", nil];
    if ([storyboardID isEqualToString:@"MAINCONTAINER1"]) {
        [self.lblHeader setText:@"Main Panel"];
    }
    else if ([storyboardID isEqualToString:@"SCENE_LIST"]) {
        [self.lblHeader setText:@"Scenes"];
    }
    else if ([storyboardID isEqualToString:@"FAVOURITE_DRAWER"]) {
        [self.lblHeader setText:@"Favourites"];
    }
    else if ([storyboardID isEqualToString:@"SCHEDULER"]) {
        [self.lblHeader setText:@"Schedulers"];
    }
    else if ([storyboardID isEqualToString:@"ADD_MACHINE"]) {
        [self.lblHeader setText:@"Add Machine"];
    }
    else if ([storyboardID isEqualToString:@"SETTING"]) {
        [self.lblHeader setText:@"Settings"];
    }
    else if ([storyboardID isEqualToString:@"ABOUT_US"]) {
        [self.lblHeader setText:@"About Us"];
    }
    else if ([storyboardID isEqualToString:@"CONTACT_US"]) {
        [self.lblHeader setText:@"Contact Us"];
    }

}

@end
