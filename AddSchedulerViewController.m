//
//  AddSchedulerViewController.m
//  D2brain
//
//  Created by webmyne systems on 06/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "AddSchedulerViewController.h"
#import "SelectSchedulerComponentViewController.h"
#import "UIView+Toast.h"
#import "AppConstant.h"

@interface AddSchedulerViewController () <BackViewControllerDelegate>
{
    NSString *strComponentID, *strComponentType;
}
@end

@implementation AddSchedulerViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    self.btnHeaderBack.layer.borderWidth=1.5f;
    self.btnHeaderBack.layer.cornerRadius=13.0f;
    self.btnHeaderBack.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.txtComponentName setUserInteractionEnabled:NO];
    [self.switchScheduler setOn:NO];
    [self.switchScheduler setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    [_viewPicker setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hitScheduledURL)
                                                 name:@"hitScheduledURL"
                                               object:nil];
    
    [self textField:self.txtSchedulerName shouldChangeCharactersInRange:NSMakeRange(0, 10) replacementString:@""];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hitScheduledURL{
    NSLog(@"------->>CALLED");
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

#pragma - mark UIButton IBAction

- (IBAction)btnHeaderBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchScheduler:(id)sender {
}

- (IBAction)btnSwitch:(id)sender {
    
    SelectSchedulerComponentViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"SCHEDULER_COMPONENT"];
    viewController.componentType=@"switch";
    viewController.delegate=self;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)btnDimmer:(id)sender {
    
    SelectSchedulerComponentViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"SCHEDULER_COMPONENT"];
    viewController.componentType=@"dimmer";
    viewController.delegate=self;
    [self presentViewController:viewController animated:YES completion:nil];
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

-(void)componentDataFromController:(NSMutableDictionary *)dictionary {
    
    [self.txtComponentName setText:[dictionary objectForKey:@"component_name"]];
    strComponentID=[dictionary objectForKey:@"component_id"];
    strComponentType=[dictionary objectForKey:@"component_type"];
}

- (IBAction)btnCreateScheduler:(id)sender {
    
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
        NSString *strComponentName=[self.txtComponentName text];
        NSString *strSchedulerDate=[self.txtScehdulDate text];
        NSString *strSchedulerTime=[self.txtScehdulTime text];
        
        NSString *strIsActive;
        if (self.switchScheduler.on==YES) {
            strIsActive=@"01";
        }
        else{
            strIsActive=@"00";
        }
        
        NSString *insertQuery = [NSString stringWithFormat:@"insert into Scheduler (scheduler_name,scheduler_date,scheduler_time,isActive,component_type,component_def_value,component_isOn,component_id,component_name) values ('%@','%@','%@','%@','%@','%@','%@',%ld,'%@')",strSchedulerName,strSchedulerDate,strSchedulerTime,@"1",strComponentType,@"0",strIsActive,[strComponentID integerValue],strComponentName];
        
        [self.dbHandler insertDataWithQuesy:insertQuery];
        
        NSString *selectQuery=@"SELECT scheduler_id FROM Scheduler ORDER BY scheduler_id DESC LIMIT 1";
        NSArray *arr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:1];
        NSString *scheduler_id=[[arr objectAtIndex:0] objectAtIndex:0];
        NSLog(@"SCXHEDUELR_ID--------- %@",scheduler_id);
        NSString *curDate = [[NSString alloc] initWithFormat:@"%@ %@",strSchedulerDate,strSchedulerTime];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/d/y hh:mm a"];
        NSDate *date = [dateFormatter dateFromString:curDate];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.fireDate = date;
        localNotification.alertBody = strSchedulerName;
        localNotification.alertAction = @"Show item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        NSDictionary *dct = [NSDictionary dictionaryWithObjectsAndKeys:[self.txtSchedulerName text] ,@"Scheduler",scheduler_id,@"uid", nil];
       
        localNotification.userInfo = dct;
        //        localNotification.userInfo = [[NSDictionary alloc] init];
        //generate unique key for schedular and pass it as key value pair in Userinfo object for local nofication so that we can update notification time in edit schedular view controller.
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            NSLog(@"Request permission");
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }else{
            [UIApplication.sharedApplication registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadScheduler" object:self];
        [self dismissViewControllerAnimated:YES completion:^{}];
        if ([delegate respondsToSelector:@selector(SchedulerAdded:)])
        {
            [delegate SchedulerAdded:YES];
        }

    }
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
