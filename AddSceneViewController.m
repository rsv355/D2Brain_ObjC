//
//  AddSceneViewController.m
//  D2brain
//
//  Created by webmyne systems on 31/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "AddSceneViewController.h"
#import "AddSceneTableViewCell.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "SelectComponentViewController.h"
#import "AppConstant.h"

@interface AddSceneViewController ()<SecondViewControllerDelegate>
{
    AddSceneTableViewCell *cell;
    Reachability *reachability;
    NetworkStatus networkStatus;
    MBProgressHUD *hud;
    NSInteger componentCount;
    NSMutableArray *selectedComponet;
    NSMutableDictionary *switchDict,*dimmerDict;
    
}
@end

@implementation AddSceneViewController
@synthesize switchArr,dimmerArr;
@synthesize mstrXMLString;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    componentCount=0;
    
    NSString *deviceName=[[UIDevice currentDevice]name];
    if ([deviceName containsString:@"iPad"]) {
        CGAffineTransform transform = CGAffineTransformMakeScale(1.6, 1.6);
        [self.view setTransform:transform];
    }
    else
    {
        
    }
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    self.btnHeaderBack.layer.borderWidth=1.5f;
    self.btnHeaderBack.layer.cornerRadius=13.0f;
    self.btnHeaderBack.layer.borderColor=[UIColor whiteColor].CGColor;
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [self.btnCreateScene setUserInteractionEnabled:NO];
    [self.btnCreateScene setAlpha:0.9f];
    [self.txtSceneName addTarget:self
                          action:@selector(textFieldDidChange:)
                forControlEvents:UIControlEventEditingChanged];
    
    switchArr=[[NSMutableArray alloc]init];
    dimmerArr=[[NSMutableArray alloc]init];
    selectedComponet=[[NSMutableArray alloc]init];
    switchDict=[[NSMutableDictionary alloc]init];
    dimmerDict=[[NSMutableDictionary alloc]init];

    [switchDict setObject:@"00" forKey:@"1"];
    [switchDict setObject:@"00" forKey:@"3"];
    componentCount=[switchArr count]+[dimmerArr count];
    
    [self textField:self.txtSceneName shouldChangeCharactersInRange:NSMakeRange(0, 10) replacementString:@""];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark UITextField Methods

-(void)textFieldDidChange :(UITextField *)theTextField {
    if ([theTextField.text length]==0) {
        [self.btnCreateScene setUserInteractionEnabled:NO];
        [self.btnCreateScene setAlpha:0.8f];
    }
    else{
        [self.btnCreateScene setUserInteractionEnabled:YES];
        [self.btnCreateScene setAlpha:1.0f];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [switchArr count]+[dimmerArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([switchArr count]>indexPath.row) {
        cell=(AddSceneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellSwitch"];
        [cell.lblSwitchName setText:[[switchArr objectAtIndex:indexPath.row] objectAtIndex:2]];
        [cell.lblSwitchMachineName setText:[[switchArr objectAtIndex:indexPath.row] objectAtIndex:6]];
        [cell.btnDeleteSwitch setTag:indexPath.row];
        [cell.machineSwitch setTag:indexPath.row];
        [cell.btnDeleteSwitch addTarget:self
                                 action:@selector(btnDeleteSwitch:) forControlEvents:UIControlEventTouchDown];
        [cell.machineSwitch addTarget:self
                               action:@selector(btnChangeMchineSwitchState:) forControlEvents:UIControlEventValueChanged];
        if ([[switchDict objectForKey:[[switchArr objectAtIndex:indexPath.row]objectAtIndex:0]] isEqualToString:@"00"]) {
            cell.machineSwitch.on =NO;
        }
        else{
            cell.machineSwitch.on =YES;
            
        }
        
        [cell.machineSwitch setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
        if ([[[switchArr objectAtIndex:indexPath.row]objectAtIndex:9] isEqualToString:@"0"]) {
            [cell.viewSwitch setHidden:NO];
        }
        else {
            [cell.viewSwitch setHidden:YES];
        }
    }
    else{
        cell=(AddSceneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellDimmer"];
        [cell.lblDimmerName setText:[[dimmerArr objectAtIndex:indexPath.row-[switchArr count]] objectAtIndex:2]];
        [cell.lblDimmerMachineName setText:[[dimmerArr objectAtIndex:indexPath.row-[switchArr count]] objectAtIndex:6]];
        [cell.btnDeleteDimmer setTag:indexPath.row-[switchArr count]];
        [cell.btnDeleteDimmer addTarget:self
                                 action:@selector(btnDeleteDimmer:) forControlEvents:UIControlEventTouchDown];
        [cell.machineDimmer setTag:indexPath.row-[switchArr count]];
        [cell.machineDimmer addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
        cell.lblDimmerRating.text=[dimmerDict valueForKey:[[dimmerArr objectAtIndex:indexPath.row-[switchArr count]] objectAtIndex:0]];
        cell.machineDimmer.value=[[dimmerDict valueForKey:[[dimmerArr objectAtIndex:indexPath.row-[switchArr count]] objectAtIndex:0]] floatValue];
        cell.viewDimmerRating.layer.cornerRadius=13.0f;
        if ([[[dimmerArr objectAtIndex:indexPath.row-[switchArr count]]objectAtIndex:9] isEqualToString:@"0"]) {
            [cell.viewDimmer setHidden:NO];
        }
        else {
            [cell.viewDimmer setHidden:YES];
        }
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight;
    if ([switchArr count]>indexPath.row) {
        cellHeight=61.0;
    }
    else{
        cellHeight=108.0f;
    }
    return cellHeight;
}
-(void)btnDeleteSwitch:(UIButton*)sender {
    
    [switchDict removeObjectForKey:[[switchArr objectAtIndex:sender.tag]objectAtIndex:0]];
    [switchArr removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
}

-(void)btnDeleteDimmer:(UIButton*)sender {
    
    [dimmerDict removeObjectForKey:[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0]];
    [dimmerArr removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
}
-(void)btnChangeMchineSwitchState:(UIButton*)sender {
    
    UISwitch *switchControl = (UISwitch *)sender;
    if (switchControl.on==YES) {
        [switchDict setObject:@"01" forKey:[[switchArr objectAtIndex:sender.tag]objectAtIndex:0]];
    }
    else{
        [switchDict setObject:@"00" forKey:[[switchArr objectAtIndex:sender.tag]objectAtIndex:0]];
    }
    [self.tableView reloadData];
}

-(void)sliderChangeValue:(UISlider *)sender {
    
    NSInteger sliderValue = (int)sender.value;
    if (sliderValue==100) {
        [dimmerDict setObject:@"99" forKey:[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0]];
    }
    else{
        
        [dimmerDict setObject:[NSString stringWithFormat:@"%.2ld",sliderValue+1] forKey:[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0]];
    }
    [self.tableView reloadData];
}

#pragma - mark UIButton IBAction

- (IBAction)btnDimmer:(id)sender {
    
    for (int i=0; i<[dimmerArr count]; i++) {
        [selectedComponet addObject:[[dimmerArr objectAtIndex:i]objectAtIndex:0]];
    }
    SelectComponentViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SELECT_COMPONENT"];
    popover.strComponentType=@"dimmer";
    popover.selectionArr=selectedComponet;
    popover.delegate = self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];
    
}

- (IBAction)btnSwitch:(id)sender {
    for (int i=0; i<[switchArr count]; i++) {
        [selectedComponet addObject:[[switchArr objectAtIndex:i]objectAtIndex:0]];
    }
    
    SelectComponentViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SELECT_COMPONENT"];
    popover.strComponentType=@"switch";
    popover.selectionArr=selectedComponet;
    popover.delegate = self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];
}

- (IBAction)btnHeaderBack:(id)sender{
    if ([self.txtSceneName.text length]!=0) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"D² Brain" message:@"Do you want to save the scene?" delegate:(id)self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertView setTag:2];
        [alertView show];
    }
    else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(getBackFromAddSceneController)])
        {
            [_delegate getBackFromAddSceneController];
        }
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"switchArr"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dimmerArr"];
    }
}
- (IBAction)btnCreateScene:(id)sender {
    [self saveSceneToDatabase];
   
}
-(void)saveSceneToDatabase {
    
    if ([switchArr count]+[dimmerArr count]==0) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"D²Brain" message:@"No Component Added. Do You Want To Exit Without Creating The Scene?" delegate:(id)self cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil];
        [alertView setTag:1];
        [alertView show];
    }
    else{
        NSString *insertQuery = [NSString stringWithFormat:@"insert into Scene (scene_name,isActive) values ('%@',%@)",self.txtSceneName.text,[NSNumber numberWithInteger:0]];
               [self.dbHandler insertDataWithQuesy:insertQuery];
        
        NSString *selectQuery=@"SELECT scene_id FROM Scene ORDER BY scene_id DESC LIMIT 1";
        NSArray *arr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:1];
        NSInteger scene_id=[[[arr objectAtIndex:0] objectAtIndex:0] integerValue];
        
        for (int i=0; i<[switchArr count]; i++) {
            
            NSString *insertQuery = [NSString stringWithFormat:@"insert into Scene_Component (scene_id,component_id,def_value) values (%ld,%ld,'%@')",scene_id,[[[switchArr objectAtIndex:i]objectAtIndex:0] integerValue],[switchDict objectForKey:[[switchArr objectAtIndex:i] objectAtIndex:0]]];
            [self.dbHandler insertDataWithQuesy:insertQuery];
            
        }
        for (int i=0; i<[dimmerArr count]; i++) {
            
            
            NSString *insertQuery = [NSString stringWithFormat:@"insert into Scene_Component (scene_id,component_id,def_value) values (%ld,%ld,'%@')",scene_id,[[[dimmerArr objectAtIndex:i]objectAtIndex:0] integerValue],[dimmerDict objectForKey:[[dimmerArr objectAtIndex:i] objectAtIndex:0]]];
            [self.dbHandler insertDataWithQuesy:insertQuery];
            
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(getBackFromAddSceneController)])
        {
            [_delegate getBackFromAddSceneController];
        }
    }
    [self.view makeToast:@"Scene is successfully saved."];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            if ([_delegate respondsToSelector:@selector(getBackFromAddSceneController)])
            {
                [_delegate getBackFromAddSceneController];
            }
        }
    }
    if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            if ([_delegate respondsToSelector:@selector(getBackFromAddSceneController)])
            {
                [_delegate getBackFromAddSceneController];
            }
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"switchArr"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dimmerArr"];
        }
        else if(buttonIndex == 1)
        {
            [self saveSceneToDatabase];
        }
    }
}

- (void)switchDataFromController:(NSMutableArray *)data  {

    switchArr=data;
    
    NSMutableArray *ary=[[NSMutableArray alloc]init];
    NSMutableArray *ary1=[[NSMutableArray alloc]init];
    [ary removeAllObjects];
    [ary1 removeAllObjects];
    
    for (int i=0; i<[switchArr count]; i++) {
        [ary addObject:[[switchArr objectAtIndex:i] objectAtIndex:0]];
        [ary1 addObject:[[switchArr objectAtIndex:i] objectAtIndex:0]];
    }
    for (NSString *key in [switchDict allKeys]) {
        
        for (NSString *mystr in ary) {
            if ([mystr isEqualToString:key]) {
                [ary1 removeObject:mystr];
            }
        }
    }
    
    for (int i=0; i<[ary1 count]; i++) {
        [switchDict setObject:@"00" forKey:[ary1 objectAtIndex:i]];
    }
       [self.tableView reloadData];
}

- (void)dimmerDataFromController:(NSMutableArray *)data  {
   
    dimmerArr=data;
    
    NSMutableArray *ary=[[NSMutableArray alloc]init];
    NSMutableArray *ary1=[[NSMutableArray alloc]init];
    [ary removeAllObjects];
    [ary1 removeAllObjects];
    
    for (int i=0; i<[dimmerArr count]; i++) {
        [ary addObject:[[dimmerArr objectAtIndex:i] objectAtIndex:0]];
        [ary1 addObject:[[dimmerArr objectAtIndex:i] objectAtIndex:0]];
    }
    for (NSString *key in [dimmerDict allKeys]) {
        
        for (NSString *mystr in ary) {
            if ([mystr isEqualToString:key]) {
                [ary1 removeObject:mystr];
            }
        }
    }
    for (int i=0; i<[ary1 count]; i++) {
        [dimmerDict setObject:@"00" forKey:[ary1 objectAtIndex:i]];
    }
    [self.tableView reloadData];

}

-(IBAction)btnSettings:(id)sender {
    
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
