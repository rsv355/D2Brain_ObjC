//
//  SchedulerListViewController.m
//  D2brain
//
//  Created by webmyne systems on 07/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "SchedulerListViewController.h"
#import "SchedulerTableViewCell.h"
#import "EditSchedulerViewController.h"
#import "AddSchedulerViewController.h"

@interface SchedulerListViewController ()<BackToSchedulerListViewDelegate,AddSchedulerDelegate>
{
    SchedulerTableViewCell *cell;
    NSArray *schedulerArr;
    NSString *selectedSchedulerID;
}


@end

@implementation SchedulerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.btnHeaderBack.layer.borderWidth=1.5f;
    self.btnHeaderBack.layer.cornerRadius=13.0f;
    self.btnHeaderBack.layer.borderColor=[UIColor whiteColor].CGColor;
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    [self fetchAllSchedulerFromDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark UIButton IBAction

- (IBAction)btnClickHere:(id)sender {
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ADD_SCHEDULER"];
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)btnAddScheduler:(id)sender {
    AddSchedulerViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ADD_SCHEDULER"];
    viewController.delegate=(id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [schedulerArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(SchedulerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.lblSchedulerListName setText:[[schedulerArr objectAtIndex:indexPath.row]objectAtIndex:1]];
    [cell.lblSchedulerListComponentName setText:[[schedulerArr objectAtIndex:indexPath.row]objectAtIndex:9]];
    [cell.lblSchedulerListTime setText:[NSString stringWithFormat:@"Scheuduled Time : %@, %@",[[schedulerArr objectAtIndex:indexPath.row]objectAtIndex:2],[[schedulerArr objectAtIndex:indexPath.row]objectAtIndex:3]]];
    [cell.lblSchedulerListTimeCount setText:@"Once"];
    if ([[[schedulerArr objectAtIndex:indexPath.row]objectAtIndex:4] isEqualToString:@"0"]) {
        cell.switchSchedulerList.on=NO;
    }
    else {
        cell.switchSchedulerList.on=YES;
    }
    [cell.btnDeleteSchedulerList setTag:indexPath.row];
    [cell.btnEditSchedulerList setTag:indexPath.row];
    [cell.switchSchedulerList setTag:indexPath.row];
    
    [cell.btnDeleteSchedulerList addTarget:self
                                action:@selector(btnDeleteScheduler:) forControlEvents:UIControlEventTouchDown];
    [cell.btnEditSchedulerList addTarget:self
                              action:@selector(btnEditScheduler:) forControlEvents:UIControlEventTouchDown];
    [cell.switchSchedulerList addTarget:self
                             action:@selector(btnSwitchScheduler:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma - mark UITableViewCell UIButton IBAction

-(void)btnDeleteScheduler:(UIButton*)sender {
    
    selectedSchedulerID=[[schedulerArr objectAtIndex:sender.tag]objectAtIndex:0];
    
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"D² Brain" message:@"Are you sure you want to delete the scheduler?" delegate:(id)self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertView setTag:1];
    [alertView show];
}

-(void)btnEditScheduler:(UIButton*)sender {
    
    EditSchedulerViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SCEHDULER_EDIT"];
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    popover.dataArr=[schedulerArr objectAtIndex:sender.tag];
    popover.delegate=self;
    [self presentViewController:popover animated:YES completion:nil];
    
}

-(void)btnSwitchScheduler:(UIButton*)sender {
    UISwitch *switchControl = (UISwitch *)sender;
    NSString *switchState=[[NSString alloc]init];
    
    if (switchControl.on==YES) {
        switchState=@"1";
        NSString *curDate = [[NSString alloc] initWithFormat:@"%@ %@",[[schedulerArr objectAtIndex:sender.tag]objectAtIndex:2],[[schedulerArr objectAtIndex:sender.tag]objectAtIndex:3]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/d/y hh:mm a"];
        NSDate *date = [dateFormatter dateFromString:curDate];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = date;
        localNotification.alertBody = [[schedulerArr objectAtIndex:sender.tag]objectAtIndex:1];
        localNotification.alertAction = @"Show item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        NSDictionary *dct = [NSDictionary dictionaryWithObjectsAndKeys:[[schedulerArr objectAtIndex:sender.tag]objectAtIndex:1],@"Scheduler",[[schedulerArr objectAtIndex:sender.tag]objectAtIndex:0],@"uid", nil];
        
        localNotification.userInfo = dct;

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            NSLog(@"Request permission");
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else{
            [UIApplication.sharedApplication registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadScheduler" object:self];


    }
    else{
        switchState=@"0";
        for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])   {
            
            NSDictionary *userInfo = notification.userInfo;
            if ([[[schedulerArr objectAtIndex:sender.tag] objectAtIndex:0] isEqualToString:[userInfo objectForKey:@"uid"]])  {
                
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                NSLog(@"Local Notification ----->> %@",[userInfo objectForKey:@"uid"]);
            }
        }
    }
    NSString *updateQuery = [NSString stringWithFormat:@"update Scheduler set isActive='%@' where scheduler_id=%ld",switchState,[[[schedulerArr objectAtIndex:sender.tag]objectAtIndex:0] integerValue]];
    
    [self.dbHandler UpdateDataWithQuesy:updateQuery];
}

#pragma - mark UIAlertView Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            NSString *deleteScene =[NSString stringWithFormat:@"delete from Scheduler where scheduler_id=%ld",[selectedSchedulerID integerValue]];
            [self.dbHandler DeleteDataWithQuesy:deleteScene];
            
            [self fetchAllSchedulerFromDatabase];
        }
    }
}

#pragma - mark DatabaseOperation Methods
-(void)fetchAllSchedulerFromDatabase {
    
    NSString *selectSwitchQuery = @"select * from Scheduler";
    schedulerArr = [self.dbHandler selectAllDataFromTablewithQuery:selectSwitchQuery ofColumn:10];
    if ([schedulerArr count]==0) {
        [self.viewNoScheduler setHidden:NO];
    }
    else{
        [self.viewNoScheduler setHidden:YES];
    }
    // If Scheduler Date Passed
    for (int i=0; i<[schedulerArr count]; i++) {
        NSString *curDate = [[NSString alloc] initWithFormat:@"%@ %@",[[schedulerArr objectAtIndex:i]objectAtIndex:2],[[schedulerArr objectAtIndex:i]objectAtIndex:3]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/d/y hh:mm a"];
        NSDate *date = [dateFormatter dateFromString:curDate];
        BOOL isYES=[self isEndDateIsSmallerThanCurrent:date];
        if (isYES==YES) {
            NSString *updateQuery = [NSString stringWithFormat:@"update Scheduler set isActive='%@' where scheduler_id=%ld",@"0",[[[schedulerArr objectAtIndex:i]objectAtIndex:0] integerValue]];
            
            [self.dbHandler UpdateDataWithQuesy:updateQuery];
        }
        
    }

    [self.tableView reloadData];
    
}

- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}

-(void)btnHeaderBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(getBackFromController)])
    {
        [_delegate getBackFromController];
    }

}

-(void)reloadDataFromController {
    [self viewDidLoad];
}

-(void)SchedulerAdded:(BOOL)success{
    [self viewDidLoad];
}
@end
