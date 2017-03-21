//
//  SceneListViewController.m
//  D2brain
//
//  Created by webmyne systems on 07/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "SceneListViewController.h"
#import "SceneTableViewCell.h"
#import "SceneViewController.h"
#import "UIView+Toast.h"
#import "SchedulerDialogueViewController.h"
#import "MBProgressHUD.h"
#import "AddSceneViewController.h"
#import "AppConstant.h"

@interface SceneListViewController () <MainAddSceneViewControllerDelegate, MainSceneViewControllerDelegate>
{
    SceneTableViewCell *cell;
    NSArray *sceneArr;
    NSString *scene_id, *scene_name;
    MBProgressHUD *hud;
    NSMutableArray *urlArr;
}
@end

@implementation SceneListViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
   
    urlArr=[[NSMutableArray alloc]init];
    [self.viewRename setHidden:YES];
    [self fetchAllSceneFromDatabase];

    [self textField:self.txtRename shouldChangeCharactersInRange:NSMakeRange(0, 10) replacementString:@""];
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
    return [sceneArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(SceneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.lblSceneListName setText:[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:1]];
    
    [cell.btnEditScene setTag:[indexPath row]];
    [cell.btnScehduleScene setTag:[indexPath row]];
    [cell.btnDeleteScene setTag:[indexPath row]];
    [cell.switchScene setTag:[indexPath row]];
    
    [cell.btnEditScene addTarget:self action:@selector(btnEditScene:) forControlEvents:UIControlEventTouchDown];
    [cell.btnScehduleScene addTarget:self action:@selector(btnScehduleScene:) forControlEvents:UIControlEventTouchDown];
    [cell.btnDeleteScene addTarget:self action:@selector(btnDeleteScene:) forControlEvents:UIControlEventTouchDown];
    [cell.switchScene addTarget:self action:@selector(changeSceneSwitch:) forControlEvents:UIControlEventValueChanged];
    
    if([[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:2] isEqualToString:@"0"]) {
        [cell.switchScene setOn:NO];
    }
    else {
        [cell.switchScene setOn:YES];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

        SceneViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"SCENE"];
        viewController.strSceneId=[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:0];
        viewController.strSceneName=[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:1];
    viewController.delegate=(id)self;
        [self presentViewController:viewController animated:YES completion:nil];

}

-(void)btnEditScene:(UIButton *)sender {
    NSLog(@"---------%@",[sceneArr objectAtIndex:sender.tag]);
    [self.viewRename setHidden:NO];
    scene_id=[[sceneArr objectAtIndex:sender.tag]objectAtIndex:0];
    [self.txtRename setText:[[sceneArr objectAtIndex:sender.tag]objectAtIndex:1]];
}

-(void)btnScehduleScene:(UIButton *)sender {
    
    scene_id=[[sceneArr objectAtIndex:sender.tag]objectAtIndex:0];
    scene_name=[[sceneArr objectAtIndex:sender.tag]objectAtIndex:1];
    
    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:scene_id forKey:@"component_id"];
    [dataDict setObject:scene_name forKey:@"component_name"];
    [dataDict setObject:@"scene" forKey:@"component_type"];
    
    SchedulerDialogueViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SCEHDULER_DIALOGUE"];
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    popover.dataDict=dataDict;
    popover.delegate=(id)self;
    [self presentViewController:popover animated:YES completion:nil];

}
-(void)btnDeleteScene:(UIButton *)sender {
      scene_id=[[sceneArr objectAtIndex:sender.tag]objectAtIndex:0];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to delete the Scene?" delegate:(id)self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertView.tag=2;
    [alertView show];
    
}
-(void)changeSceneSwitch:(UIButton *)sender {
   
    UISwitch *switchControl = (UISwitch *)sender;
    scene_id=[[sceneArr objectAtIndex:sender.tag]objectAtIndex:0];
    if (switchControl.on==NO) {
        NSString *updateQuery = [NSString stringWithFormat:@"update Scene set isActive='%@' where scene_id=%ld",@"0",[[[sceneArr objectAtIndex:sender.tag]objectAtIndex:0] integerValue]];
        [self.dbHandler UpdateDataWithQuesy:updateQuery];
    }
    else {
        NSString *updateQuery = [NSString stringWithFormat:@"update Scene set isActive='%@' where scene_id=%ld",@"1",[[[sceneArr objectAtIndex:sender.tag]objectAtIndex:0] integerValue]];
        [self.dbHandler UpdateDataWithQuesy:updateQuery];
    }
    [self showHud];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [urlArr removeAllObjects];
        NSString *selectSwitchQuery = [NSString stringWithFormat:@"select sc.scene_component_id, sc.component_id, sc.def_value,   c.*, m.machine_name, m.machine_ip, m.worldwide_ip, m.isActive,m.isWWIPActive from Scene_Component As sc JOIN Components As c  ON sc.component_id=c.component_id  JOIN MachineConfig As m ON c.machine_id=m.machine_id where sc.scene_id=%ld",[scene_id integerValue]];
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
                
                if (switchControl.on==NO) {
                   
                    
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
                if (switchControl.on==NO) {
                    
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
            NSLog(@"------>>%@",[urlArr objectAtIndex:i]);
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
            
        });
    });

}
#pragma - mark UIAlertView Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        if(buttonIndex == 1)
        {
            NSString *deleteScene =[NSString stringWithFormat:@"delete from Scene where scene_id=%ld",[scene_id integerValue]];
            [self.dbHandler DeleteDataWithQuesy:deleteScene];
            NSString *deleteSceneComponent =[NSString stringWithFormat:@"delete from Scene_Component where scene_id=%ld",[scene_id integerValue]];
            [self.dbHandler DeleteDataWithQuesy:deleteSceneComponent];
            [self showHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self fetchAllSceneFromDatabase];
            });
            [self hideHud];
        }
    }
}
#pragma - mark UIButton IBAction

-(void)fetchAllSceneFromDatabase {
    
    NSString *selectSwitchQuery = @"select * from Scene";
    sceneArr = [self.dbHandler selectAllDataFromTablewithQuery:selectSwitchQuery ofColumn:3];
    [self.tableView reloadData];
    if ([sceneArr count]==0) {
        [self.viewNoScene setHidden:NO];
    }
    else {
         [self.viewNoScene setHidden:YES];
    }
}

- (IBAction)btnCreateScene:(id)sender {
    
    AddSceneViewController *viewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"ADD_SCENE"];
    viewController.delegate=(id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)bntCloseRenameView:(id)sender {
    [self.viewRename setHidden:YES];
    [self.txtRename setText:@""];
}

- (IBAction)btnRename:(id)sender {
    
    NSString *updateQuery = [NSString stringWithFormat:@"update Scene set scene_name='%@' where scene_id=%ld",[self.txtRename text],[scene_id integerValue]];
    [self.dbHandler UpdateDataWithQuesy:updateQuery];
    [self.viewRename setHidden:YES];
    [self.txtRename setText:@""];
    [self.view makeToast:@"Scene name is successfully updated."];
    [self fetchAllSceneFromDatabase];

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


#pragma -  mark Delegate methods

-(void)getBackFromAddSceneController
{
    [self viewDidLoad];
}
-(void)getBackFromController {
    [self viewDidLoad];
}



#pragma - mark UITextField Limit method

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
