//
//  MenuTableViewController.h
//  ShreeSwastik
//
//  Created by Rajendrasinh Parmar on 25/09/15.
//  Copyright © 2015 ChorusProapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDrawerViewController.h"
#import "DataBaseFile.h"

@class MenuDrawerViewController;

@interface MenuTableViewController : UITableViewController<UITableViewDataSource>{
    NSMutableArray *menuItems;
    NSMutableArray *menuIcons;
    NSMutableArray *menuItemIdentifire;
}


@property (nonatomic,weak) MenuTableViewController *menuViewController;
@property (nonatomic,weak) MenuDrawerViewController *menuDrawerViewController;
@property(strong,nonatomic)DataBaseFile *dbHandler;
@end
