//
//  ParentViewController.h
//  D2brain
//
//  Created by webmyne systems on 03/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainContentNavigationController.h"
@interface ParentViewController : UIViewController
@property (nonatomic,strong) MainContentNavigationController *mainContentNavigationController;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,weak) UIViewController *content;
-(void)setSubContent:(NSString*)storyboardID;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@end
