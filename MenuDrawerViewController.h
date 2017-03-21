//
//  MenuDrawerViewController.h
//  ShreeSwastik
//
//  Created by Rajendrasinh Parmar on 25/09/15.
//  Copyright © 2015 ChorusProapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewController.h"

@class MenuTableViewController;

@interface MenuDrawerViewController : UIViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
-(void)setContent:(NSString*)storyboardID;
-(void)setMainContainer;

@property (nonatomic,weak) MenuTableViewController *menuTableViewController;
@property (nonatomic,weak) MenuDrawerViewController *menuDrawerViewController;
//@property (nonatomic,weak) UIViewController *content;
@property (nonatomic,weak) UIViewController *mainContent;
-(void)shareMyFeedback:(NSString *)strFeedback;

@end
