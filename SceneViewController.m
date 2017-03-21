//
//  SceneViewController.m
//  D2brain
//
//  Created by webmyne systems on 02/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "SceneViewController.h"
#import "DataBaseFile.h"
#import "CustomAnimationAndTransiotion.h"
#import "UIView+Toast.h"
#import "SelectComponentViewController.h"
#import "SceneTableViewCell.h"
#import "SchedulerDialogueViewController.h"
#import "MBProgressHUD.h"
#import "AppConstant.h"

@interface SceneViewController ()<SecondViewControllerDelegate>
{
   
    SceneTableViewCell *cell;
    MBProgressHUD *hud;
    NSMutableArray *switchStatus,*dimmerRate,*componentIdArr,*componentArr,*selectedComponet;
    NSMutableDictionary *switchDict,*dimmerDict;
    NSMutableArray *urlArr;
    NSInteger showDialogue;
}

@end

@implementation SceneViewController
@synthesize switchArr,dimmerArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //switch
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    self.btnHeaderBack.layer.borderWidth=1.5f;
    self.btnHeaderBack.layer.cornerRadius=13.0f;
    self.btnHeaderBack.layer.borderColor=[UIColor whiteColor].CGColor;
    
    [self.lblHeaderTitle setText:_strSceneName];
    [self.sceneSwitch setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    
    switchStatus=[[NSMutableArray alloc]init];
    dimmerRate=[[NSMutableArray alloc]init];
    componentIdArr=[[NSMutableArray alloc]init];
    componentArr=[[NSMutableArray alloc]init];
    switchArr=[[NSMutableArray alloc]init];
    dimmerArr=[[NSMutableArray alloc]init];
    selectedComponet=[[NSMutableArray alloc]init];
    urlArr=[[NSMutableArray alloc]init];
    switchDict=[[NSMutableDictionary alloc]init];
    dimmerDict=[[NSMutableDictionary alloc]init];
    
    [self.viewRename setHidden:YES];
    showDialogue=0;
    
    [self fetchSceneComponentsFromDatabase:[_strSceneId integerValue]];
    
    [self.btnSaveScene setAlpha:0.8f];
    [self.btnSaveScene setUserInteractionEnabled:NO];
    
    if ([self fetchSceneStatusFromDAtabase:[_strSceneId integerValue]]==0) {
        [self.sceneSwitch setOn:NO];
    }
    else{
        [self.sceneSwitch setOn:YES];
    }
    
    [self textField:self.txtSceneName shouldChangeCharactersInRange:NSMakeRange(0, 10) replacementString:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell=(SceneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellSwitch"];
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
        if ([[[switchArr objectAtIndex:indexPath.row] objectAtIndex:9]isEqualToString:@"0"]) {
            [cell.viewSwitch setHidden:NO];
        }
        else{
            [cell.viewSwitch setHidden:YES];
        }
    }
    else{
       
        cell=(SceneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellDimmer"];
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
        if ([[[dimmerArr objectAtIndex:indexPath.row-[switchArr count]] objectAtIndex:9]isEqualToString:@"0"]) {
            [cell.viewDimmer setHidden:NO];
        }
        else{
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
    
    showDialogue=1;
    [self.btnSaveScene setAlpha:1.0f];
    [self.btnSaveScene setUserInteractionEnabled:YES];
    [switchDict removeObjectForKey:[[switchArr objectAtIndex:sender.tag]objectAtIndex:0]];
    [switchArr removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
    [self.btnSaveScene setAlpha:1.0f];
    [self.btnSaveScene setUserInteractionEnabled:YES];
}

-(void)btnDeleteDimmer:(UIButton*)sender {
    
    showDialogue=1;
    [dimmerDict removeObjectForKey:[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0]];
     [dimmerArr removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
    [self.btnSaveScene setAlpha:1.0f];
    [self.btnSaveScene setUserInteractionEnabled:YES];
    NSLog(@"DICT--------->>%@",dimmerDict);
}
-(void)btnChangeMchineSwitchState:(UIButton*)sender {
    
    showDialogue=1;
    
    UISwitch *switchControl = (UISwitch *)sender;
    if (switchControl.on==YES) {
        [switchDict setObject:@"01" forKey:[[switchArr objectAtIndex:sender.tag]objectAtIndex:0]];
    }
    else{
        [switchDict setObject:@"00" forKey:[[switchArr objectAtIndex:sender.tag]objectAtIndex:0]];
    }
    [self.tableView reloadData];

    [self.btnSaveScene setAlpha:1.0f];
    [self.btnSaveScene setUserInteractionEnabled:YES];
}

-(void)sliderChangeValue:(UISlider *)sender {
    
    showDialogue=1;

    NSInteger sliderValue = (int)sender.value;
    if (sliderValue==100) {
        [dimmerDict setObject:@"99" forKey:[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0]];
    }
    else{
        
        [dimmerDict setObject:[NSString stringWithFormat:@"%.2ld",sliderValue] forKey:[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0]];
    }
    [self.tableView reloadData];
    [self.btnSaveScene setAlpha:1.0f];
    [self.btnSaveScene setUserInteractionEnabled:YES];
}

#pragma - mark UIButton IBAction

-(IBAction)btnDimmer:(id)sender {

    showDialogue=1;
    
    [selectedComponet removeAllObjects];
    for (int i=0; i<[dimmerArr count]; i++) {
        [selectedComponet addObject:[[dimmerArr objectAtIndex:i]objectAtIndex:0]];
    }
    SelectComponentViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SELECT_COMPONENT"];
    popover.strComponentType=@"dimmer";
    popover.selectionArr=selectedComponet;
    popover.delegate = (id)self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];

}

-(IBAction)btnSwitch:(id)sender {
    showDialogue=1;

    [selectedComponet removeAllObjects];
    for (int i=0; i<[switchArr count]; i++) {
        [selectedComponet addObject:[[switchArr objectAtIndex:i]objectAtIndex:0]];
    }
    SelectComponentViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SELECT_COMPONENT"];
    popover.strComponentType=@"switch";
    popover.selectionArr=selectedComponet;
    popover.delegate = (id)self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];

}

-(IBAction)btnSettings:(id)sender   {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:(id)self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Add to Scehdular",@"Rename",@"Delete", nil];
    [actionSheet showInView:self.view];
}

-(IBAction)btnSaveScene:(id)sender  {
    showDialogue=0;
    [self saveSceneToDatabase];
}

-(void)saveSceneToDatabase {
    NSString *deleteQuery =[NSString stringWithFormat:@"delete from Scene_Component where scene_id=%ld",[_strSceneId integerValue]];
    
    [self.dbHandler DeleteDataWithQuesy:deleteQuery];
    
    for (int i=0; i<[switchArr count]; i++) {
        
        NSString *insertQuery = [NSString stringWithFormat:@"insert into Scene_Component (scene_id,component_id,def_value) values (%ld,%ld,'%@')",[_strSceneId integerValue],[[[switchArr objectAtIndex:i]objectAtIndex:0] integerValue],[switchDict objectForKey:[[switchArr objectAtIndex:i] objectAtIndex:0]]];
    
        [self.dbHandler insertDataWithQuesy:insertQuery];
        
    }
    for (int i=0; i<[dimmerArr count]; i++) {
        
        
        NSString *insertQuery = [NSString stringWithFormat:@"insert into Scene_Component (scene_id,component_id,def_value) values (%ld,%ld,'%@')",[_strSceneId integerValue],[[[dimmerArr objectAtIndex:i]objectAtIndex:0] integerValue],[dimmerDict objectForKey:[[dimmerArr objectAtIndex:i] objectAtIndex:0]]];
        [self.dbHandler insertDataWithQuesy:insertQuery];
        
    }
    [self.view makeToast:@"Scene is successfully saved."];
}

-(IBAction)btnHeaderBack:(id)sender {
   
    if (showDialogue==1) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"D² Brain" message:@"Do you want to save the scene?" delegate:(id)self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertView setTag:2];
        [alertView show];
    }
    else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"switchArr"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dimmerArr"];
        if ([_delegate respondsToSelector:@selector(getBackFromController)])
        {
            [_delegate getBackFromController];
        }

    }
    
}

#pragma - mark UIAlertView Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            [self dismissViewControllerAnimated:YES completion:nil];

            if ([_delegate respondsToSelector:@selector(getBackFromController)])
            {
                [_delegate getBackFromController];
            }

        }
        else if(buttonIndex == 1)
        {
            [self saveSceneToDatabase];
            [self dismissViewControllerAnimated:YES completion:nil];
            if ([_delegate respondsToSelector:@selector(getBackFromController)])
            {
                [_delegate getBackFromController];
            }

        }
    }
    if (alertView.tag==6) {
        if (buttonIndex == 1) {
            
            NSString *deleteScene =[NSString stringWithFormat:@"delete from Scene where scene_id=%ld",[_strSceneId integerValue]];
            [self.dbHandler DeleteDataWithQuesy:deleteScene];
            NSString *deleteSceneComponent =[NSString stringWithFormat:@"delete from Scene_Component where scene_id=%ld",[_strSceneId integerValue]];
            [self.dbHandler DeleteDataWithQuesy:deleteSceneComponent];
            [self dismissViewControllerAnimated:YES completion:nil];
            if ([_delegate respondsToSelector:@selector(getBackFromController)])
            {
                [_delegate getBackFromController];
            }
        }
    }
}

#pragma - mark SelectComponentViewController Delegate method 

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
    NSLog(@"DICT--------->>%@",dimmerDict);
}

#pragma - mark Database Operation
-(NSInteger)fetchSceneStatusFromDAtabase: (NSInteger)sceneID {
   
    NSString *selectSwitchQuery = [NSString stringWithFormat:@"select isActive from Scene where scene_id=%ld",sceneID];
     NSArray *activArr = [self.dbHandler selectAllDataFromTablewithQuery:selectSwitchQuery ofColumn:1];
    return [[[activArr objectAtIndex:0] objectAtIndex:0] integerValue];
}
-(void)fetchSceneComponentsFromDatabase: (NSInteger)sceneID {
    
    NSString *selectSwitchQuery = [NSString stringWithFormat:@"select component_id,def_value from Scene_Component where scene_id=%ld",sceneID];
    componentIdArr = [self.dbHandler selectAllDataFromTablewithQuery:selectSwitchQuery ofColumn:2];
   
     for (int i=0; i<[componentIdArr count]; i++) {
        
        NSString *selectSwitchQuery = [NSString stringWithFormat:@"select c.* , m.machine_name, m.machine_ip, m.worldwide_ip, m.isActive,m.isWWIPActive from Components As c JOIN MachineConfig As m where c.machine_id = m.machine_id AND c.component_id=%ld",[[[componentIdArr objectAtIndex:i] objectAtIndex:0] integerValue]];
        NSArray *ary=[self.dbHandler selectAllDataFromTablewithQuery:selectSwitchQuery ofColumn:11];
        [componentArr addObject:[ary objectAtIndex:0]];
    }
    for (int i=0; i<[componentArr count]; i++) {
        if ([[[componentArr objectAtIndex:i] objectAtIndex:3] isEqualToString:@"switch"]) {
             [switchArr addObject:[componentArr objectAtIndex:i]];
        }
        else if ([[[componentArr objectAtIndex:i] objectAtIndex:3] isEqualToString:@"dimmer"]) {
            [dimmerArr addObject:[componentArr objectAtIndex:i]];
        }
    }
    for (int i=0; i<[componentIdArr count]; i++) {
        for (int j=0; j<[switchArr count]; j++){
            if ([[[switchArr objectAtIndex:j]objectAtIndex:0] isEqualToString:[[componentIdArr objectAtIndex:i]objectAtIndex:0]]) {
                
                [switchDict setObject:[[componentIdArr objectAtIndex:i]objectAtIndex:1] forKey:[[componentIdArr objectAtIndex:i]objectAtIndex:0]];
                }
        }
        for (int j=0; j<[dimmerArr count]; j++){
            if ([[[dimmerArr objectAtIndex:j]objectAtIndex:0] isEqualToString:[[componentIdArr objectAtIndex:i]objectAtIndex:0]]) {
               
                [dimmerDict setObject:[[componentIdArr objectAtIndex:i]objectAtIndex:1] forKey:[[componentIdArr objectAtIndex:i]objectAtIndex:0]];
            }
        }
    }
    [self.tableView reloadData];
   
}

- (IBAction)btnClose:(id)sender {
    [self.viewRename setHidden:YES];
}

- (IBAction)btnRename:(id)sender {
    NSLog(@"---->>%@",self.txtSceneName.text);
    if ([self.txtSceneName.text length]==0) {
        [self.view endEditing:YES];
        [self.view makeToast:@"Please Enter Scene Name"];
    }
    else {
        [self.viewRename setHidden:YES];
    NSString *updateQuery = [NSString stringWithFormat:@"update Scene set scene_name='%@' where scene_id=%ld",[self.txtSceneName text],[_strSceneId integerValue]];
        [self.dbHandler UpdateDataWithQuesy:updateQuery];
        [self.lblHeaderTitle setText:[self.txtSceneName text]];
        
        [self.btnSaveScene setAlpha:1.0f];
        [self.btnSaveScene setUserInteractionEnabled:YES];
    }
}

#pragma - mark UIActionSheet method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
          
        }
            break;
        case 1:
        {
            
            NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
            [dataDict setObject:_strSceneId forKey:@"component_id"];
            [dataDict setObject:_strSceneName forKey:@"component_name"];
            [dataDict setObject:@"scene" forKey:@"component_type"];
            
            SchedulerDialogueViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SCEHDULER_DIALOGUE"];
            popover.modalPresentationStyle = UIModalPresentationCustom;
            [popover setTransitioningDelegate:_customTransitionController];
            popover.dataDict=dataDict;
            popover.delegate=(id)self;
            [self presentViewController:popover animated:YES completion:nil];
        }
            break;
        case 2:
        {
            [self.txtSceneName setText:[self.lblHeaderTitle text]];
            [self.viewRename setHidden:NO];
        }
            break;
        case 3:
        {
        
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"D² Brain" message:@"Are you sure you want to delete the Scene?" delegate:(id)self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alertView.tag=6;
            [alertView show];
        }
            break;
        
        default:
            break;
    }
    
}

#pragma - mark XML Parsing methods
- (IBAction)sceneSwitch:(id)sender {
   
    
    [self showHud];
    dispatch_async(dispatch_get_main_queue(), ^{
   
    [urlArr removeAllObjects];
    NSString *selectSwitchQuery = [NSString stringWithFormat:@"select sc.scene_component_id, sc.component_id, sc.def_value,   c.*, m.machine_name, m.machine_ip, m.worldwide_ip, m.isActive,m.isWWIPActive from Scene_Component As sc JOIN Components As c  ON sc.component_id=c.component_id  JOIN MachineConfig As m ON c.machine_id=m.machine_id where sc.scene_id=%ld",[_strSceneId integerValue]];
    NSArray *dataArr = [self.dbHandler selectAllDataFromTablewithQuery:selectSwitchQuery ofColumn:14];
    
    NSString *strIP=[[NSMutableString alloc]init];
    NSString *switchState=[[NSMutableString alloc]init];
    
    for (int i=0; i<[dataArr count]; i++) {
        
        if ([[[dataArr objectAtIndex:i] objectAtIndex:13] isEqualToString:@"1"]) {
            strIP=[[dataArr objectAtIndex:i] objectAtIndex:11];
        }
        else{
           strIP=[[dataArr objectAtIndex:i] objectAtIndex:10];
        }
        
        if ([[[dataArr objectAtIndex:i]objectAtIndex:6] isEqualToString:@"switch"]) {
            
            if (self.sceneSwitch.on==NO) {
               
               
                if ([[[dataArr objectAtIndex:i]objectAtIndex:2] isEqualToString:@"00"]) {
                    switchState=@"00";
                }
                else{
                    switchState=@"00";
                }
            }
            else {
                switchState=[[dataArr objectAtIndex:i]objectAtIndex:2];
            }
            [urlArr addObject:[NSString stringWithFormat:@"http://%@/cswcr.cgi?SW=%@%@",strIP,[[[dataArr objectAtIndex:i]objectAtIndex:8] substringWithRange:NSMakeRange(2, 2)],switchState]];
        }
        else if ([[[dataArr objectAtIndex:i]objectAtIndex:6] isEqualToString:@"dimmer"]) {
            NSString *dimmerState=[[NSMutableString alloc]init];
          
            if ([[[dataArr objectAtIndex:i]objectAtIndex:2] integerValue]>0) {
                dimmerState=@"01";
            }
            else  {
                dimmerState=@"00";
            }
            if (self.sceneSwitch.on==NO) {
                
                if ([dimmerState isEqualToString:@"01"]) {
                    dimmerState=@"00";
                }
                else {
                    dimmerState=@"00";
                }
            }
            
            [urlArr addObject:[NSString stringWithFormat:@"http://%@/cdmcr.cgi?DM=%@%@%@",strIP,[[[dataArr objectAtIndex:i]objectAtIndex:8] substringWithRange:NSMakeRange(2, 2)],dimmerState,[[dataArr objectAtIndex:i]objectAtIndex:2]]];
        }

    }

   
    dispatch_group_t group = dispatch_group_create();
    
    for(int i=0; i<[urlArr count]; i++)
    {
        dispatch_group_enter(group);
        
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:[urlArr objectAtIndex:i]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if ([data length] > 0 && error == nil) {
       
            }
            else if ([data length] == 0 || error != nil){
               
              
            }
            dispatch_group_leave(group);
        }];
        [task resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
       [self hideHud];
        if (self.sceneSwitch.on==NO) {
            NSString *updateQuery = [NSString stringWithFormat:@"update Scene set isActive='%@' where scene_id=%ld",@"0",[_strSceneId integerValue]];
            [self.dbHandler UpdateDataWithQuesy:updateQuery];
        }
        else {
            NSString *updateQuery = [NSString stringWithFormat:@"update Scene set isActive='%@' where scene_id=%ld",@"1",[_strSceneId integerValue]];
            [self.dbHandler UpdateDataWithQuesy:updateQuery];
        }
    });
    });
    
}

#pragma mark -MBProgressHUD methods
-(void)showHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       hud.delegate = (id)self;
                       [self.view addSubview:hud];
                       [hud show:YES];
                       
                   });
}

-(void)hideHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       [hud hide:YES];
                       
                   });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if([textField.text length]<CHARACTER_COUNT)
        return YES;
    else
        return NO;
}

@end
