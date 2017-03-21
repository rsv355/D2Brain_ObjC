//
//  SchedulerViewController.h
//  D2brain
//
//  Created by webmyne systems on 06/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "CustomAnimationAndTransiotion.h"
#import "AddSchedulerViewController.h"

@interface SchedulerViewController : UIViewController

@property (nonatomic,strong) CustomAnimationAndTransiotion *customTransitionController;

@property (weak, nonatomic) IBOutlet UIView *viewNoScheduler;
- (IBAction)btnClickHere:(id)sender;

@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
