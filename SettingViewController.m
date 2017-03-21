//
//  SettingViewController.m
//  D2brain
//
//  Created by webmyne systems on 10/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "SettingViewController.h"
#import "TouchPanelTableViewCell.h"

@interface SettingViewController ()
{
    TouchPanelTableViewCell *cell;
    NSArray *settingArr;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    settingArr=[[NSArray alloc]initWithObjects:@"StartUp Screen", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [settingArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(TouchPanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.lblSettingName setText:[settingArr objectAtIndex:indexPath.row]];
    [cell.settingSwitch setTag:indexPath.row];
    [cell.settingSwitch addTarget:self
                           action:@selector(btnChangeSwitchState:) forControlEvents:UIControlEventValueChanged];
    
    NSObject *obj=[[NSUserDefaults standardUserDefaults]objectForKey:@"showStartUpScreen"];
        if (obj!=nil) {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"showStartUpScreen"] isEqualToString:@"1"]) {
                cell.settingSwitch.on=YES;
                
            }
            else {
                cell.settingSwitch.on=NO;
            }
        }
        
    return cell;
}
-(void)btnChangeSwitchState:(UIButton*)sender {
    
    UISwitch *switchControl = (UISwitch *)sender;
    if (switchControl.on==YES) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"showStartUpScreen"];
    }
    else{
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"showStartUpScreen"];
    }
    [self.tableView reloadData];
}


@end
