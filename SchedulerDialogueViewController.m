//
//  SchedulerDialogueViewController.m
//  D2brain
//
//  Created by webmyne systems on 07/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "SchedulerDialogueViewController.h"
#import "UIView+Toast.h"
#import "AppConstant.h"

@interface SchedulerDialogueViewController ()

@end

@implementation SchedulerDialogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    [self.switchScheduler setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    [_viewPicker setHidden:YES];
    
    [self.switchScheduler setOn:NO];
   
    [self.txtComponentName setText:[self.dataDict objectForKey:@"component_name"]];
    
    [self textField:self.txtSchedulerName shouldChangeCharactersInRange:NSMakeRange(0, 10) replacementString:@""];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  Keyboard return methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// keyboard hide on touch outside
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentSize:CGSizeMake (self.scrollView.frame.size.width, self.scrollView.contentSize.height)];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)btnScheduledDate:(id)sender {
    [_viewPicker setHidden:NO];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    _datePicker.hidden=NO;
    _datePicker.date=[NSDate date];
    [self.btnSelect setTag:1];
}
- (IBAction)btnSelectDate:(id)sender {
    if (self.btnSelect.tag==1) {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        dateFormat.dateStyle=NSDateFormatterMediumStyle;
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
        
        [_viewPicker setHidden:YES];
        _txtScehdulDate.text=str;
      
        
    }
    else if (self.btnSelect.tag==2) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *currentTime = [dateFormatter stringFromDate:self.datePicker.date];
        self.txtScehdulTime.text=currentTime;
        [_viewPicker setHidden:YES];
    }
}
- (IBAction)btnScheduledTime:(id)sender {
    [_viewPicker setHidden:NO];
    _datePicker.datePickerMode=UIDatePickerModeTime;
    _datePicker.hidden=NO;
    [self.btnSelect setTag:2];
}

- (IBAction)btnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(reloadDataFromController)])
    {
        [_delegate reloadDataFromController];
    }
}

- (IBAction)btnSaveScheduler:(id)sender {
    if([self.txtSchedulerName.text length]==0) {
        [self.view makeToast:@"Please Enter Scheduler Name."];
    }
    else if([self.txtComponentName.text length]==0) {
        
        [self.view makeToast:@"Please Select Component."];
    }
    else if([self.txtScehdulDate.text length]==0) {
        
        [self.view makeToast:@"Please Select Scheduler Date."];
    }
    else if([self.txtScehdulTime.text length]==0) {
        
        [self.view makeToast:@"Please Select Scheduler Time."];
    }
    else {
        
        NSString *strSchedulerName=[self.txtSchedulerName text];
        NSString *strSchedulerDate=[self.txtScehdulDate text];
        NSString *strSchedulerTime=[self.txtScehdulTime text];
        NSString *strComponentName=[self.txtComponentName text];
        NSString *strComponentID=[self.dataDict objectForKey:@"component_id"];
        NSString *strComponentType=[self.dataDict objectForKey:@"component_type"];
        NSString *strIsActive;
        
        NSString *curDate = [[NSString alloc] initWithFormat:@"%@ %@",strSchedulerDate,strSchedulerTime];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/d/y hh:mm a"];
        NSDate *date = [dateFormatter dateFromString:curDate];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = date;
        localNotification.alertBody = strSchedulerName;
        localNotification.alertAction = @"Show item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        NSDictionary *dct = [NSDictionary dictionaryWithObjectsAndKeys:[self.txtSchedulerName text] ,@"Scheduler", nil];
        localNotification.userInfo = dct;
        //        localNotification.userInfo = [[NSDictionary alloc] init];
        //generate unique key for schedular and pass it as key value pair in Userinfo object for local nofication so that we can update notification time in edit schedular view controller.
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            NSLog(@"Request permission");
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }else{
            [UIApplication.sharedApplication registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];
        }
        
        if (self.switchScheduler.on==YES) {
            strIsActive=@"1";
        }
        else{
            strIsActive=@"0";
        }
        
        NSString *insertQuery = [NSString stringWithFormat:@"insert into Scheduler (scheduler_name,scheduler_date,scheduler_time,isActive,component_type,component_def_value,component_isOn,component_id,component_name) values ('%@','%@','%@','%@','%@','%@','%@',%ld,'%@')",strSchedulerName,strSchedulerDate,strSchedulerTime,@"0",strComponentType,@"0",strIsActive,[strComponentID integerValue],strComponentName];
        
        [self.dbHandler insertDataWithQuesy:insertQuery];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(reloadDataFromController)])
        {
            [_delegate reloadDataFromController];
        }

    }
}
- (IBAction)switchScheduler:(id)sender {
    
}

- (IBAction)btnCanclePicker:(id)sender {
    [_viewPicker setHidden:YES];
}
#pragma - mark UITextField Limit method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if([textField.text length]<CHARACTER_COUNT) {
        return YES;
    }
    else
        return NO;
    
}
@end
