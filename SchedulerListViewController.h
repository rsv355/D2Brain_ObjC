//
//  SchedulerListViewController.h
//  D2brain
//
//  Created by webmyne systems on 07/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "CustomAnimationAndTransiotion.h"

@protocol SchedulerViewControllerDelegate <NSObject>

@required
- (void)getBackFromController;

@end

@interface SchedulerListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnHeaderBack;
- (IBAction)btnHeaderBack:(id)sender;
@property (nonatomic,strong) CustomAnimationAndTransiotion *customTransitionController;

@property (weak, nonatomic) IBOutlet UIView *viewNoScheduler;
- (IBAction)btnClickHere:(id)sender;

@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, weak) id<SchedulerViewControllerDelegate> delegate;
@end
