//
//  DimmerViewController.m
//  D2brain
//
//  Created by webmyne systems on 19/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "DimmerViewController.h"
#import "DimmerTableViewCell.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "CustomAnimationAndTransiotion.h"
#import "Reachability.h"
#import "SchedulerDialogueViewController.h"
#import "AppConstant.h"

@interface DimmerViewController ()<BackToViewDelegate>
{
    DimmerTableViewCell *cell;
    Reachability *reachability;
    NetworkStatus networkStatus;
    NSMutableArray *segmentTitles,*machineArr,*segmentIdArr,*dimmerArr;
    NSInteger component_id;
    NSTimer *timer;
    NSMutableArray *machineArray,*dimmerStatusArr,*dimmerRateArr;
    NSInteger totalMachine,activeMachine,isActiveStatus;
    NSMutableArray *arr;
    NSInteger dimmers;
    MBProgressHUD *hud;
    NSData *responseData;
    
}
@property (nonatomic,strong) CustomAnimationAndTransiotion *customTransitionController;

@end

@implementation DimmerViewController
@synthesize mstrXMLString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    NSString *deviceName=[[UIDevice currentDevice]name];
    if ([deviceName containsString:@"iPad"]) {
               CGAffineTransform transform = CGAffineTransformMakeScale(1.6, 1.6);
        [self.view setTransform:transform];
    }
    else
    {
            }

    //----NETWORK CONNECTION
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];

    self.btnHeaderBack.layer.borderWidth=1.5f;
    self.btnHeaderBack.layer.cornerRadius=13.0f;
    self.btnHeaderBack.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.viewRenameDimmer setHidden:YES];
    [self.viewDisableComponent setHidden:YES];
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    machineArray=[[NSMutableArray alloc]init];
    machineArr=[[NSMutableArray alloc]init];
    segmentTitles=[[NSMutableArray alloc]init];
    segmentIdArr=[[NSMutableArray alloc]init];
    dimmerArr=[[NSMutableArray alloc]init];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [self showHud];
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self fetchMachineDataFromDatabase];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    
        [self.segmentControl setSelectedSegmentIndex:0];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self fetchDimmersForSelectedMachine:[segmentIdArr objectAtIndex:0]];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self fetchActiveMachineForSwitchAction:[segmentIdArr objectAtIndex:0]];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
     
        [self.tableView setHidden:YES];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
   
        [self requestDimmerStatusForSelectedMachine:self.segmentControl.selectedSegmentIndex];
    });
    
    [self.txtDimmerName setDelegate:(id)self];
    [self callTimer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) callTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:DIMMER_BACKGROUND_TIMER target:self selector:@selector(fetchMachineStatus:) userInfo:nil repeats:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)btnHeaderBack:(id)sender{
    [timer invalidate];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"onStatus"];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(getBackFromController)])
    {
        [_delegate getBackFromController];
    }

}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dimmerArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(DimmerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.viewDimmerRating.layer.cornerRadius=13.0f;
    [cell.sliderDimmer setThumbImage:[UIImage imageNamed:@"slider2.png"] forState:UIControlStateNormal];
    cell.lblDimmerName.text=[[dimmerArr objectAtIndex:indexPath.row]objectAtIndex:2];
    if ([[[dimmerArr objectAtIndex:indexPath.row]objectAtIndex:4]isEqualToString:@"0"]) {
        [cell.btnFavourite setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.btnFavourite setImage:[UIImage imageNamed:@"fav_orange.png"] forState:UIControlStateNormal];
    }
    
    if ([[dimmerStatusArr objectAtIndex:indexPath.row]isEqualToString:@"00"]) {
        cell.dimmerMachine.on=NO;
    }
    else{
        cell.dimmerMachine.on=YES;
    }
    
    if ([[dimmerRateArr objectAtIndex:indexPath.row] floatValue] ==0) {
         cell.sliderDimmer.value=[[dimmerRateArr objectAtIndex:indexPath.row] floatValue];
    }
    else {
         cell.sliderDimmer.value=[[dimmerRateArr objectAtIndex:indexPath.row] floatValue]+1;
    }
    cell.lblDimmerRating.text=[NSString stringWithFormat:@"%.2d",(int)cell.sliderDimmer.value];

    [cell.btnRename setTag:indexPath.row];
    [cell.btnFavourite setTag:indexPath.row];
    [cell.dimmerMachine setTag:indexPath.row];
    [cell.btnScene setTag:indexPath.row];
    [cell.btnScheduler setTag:indexPath.row];
    [cell.sliderDimmer setTag:indexPath.row];
    [cell.btnRename addTarget:self
                       action:@selector(btnRename:) forControlEvents:UIControlEventTouchDown];
    [cell.btnFavourite addTarget:self
                          action:@selector(btnFavourite:) forControlEvents:UIControlEventTouchDown];
    [cell.dimmerMachine addTarget:self
                           action:@selector(btnChangeMchineDimmerState:) forControlEvents:UIControlEventValueChanged];
    [cell.btnScene addTarget:self action:@selector(btnScene:) forControlEvents:UIControlEventTouchDown];
    [cell.btnScheduler addTarget:self action:@selector(btnScheduler:) forControlEvents:UIControlEventTouchDown];

    [cell.sliderDimmer addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside];

    return cell;
}
#pragma mark - Machine status related method

-(void)fetchMachineDataFromDatabase{
    
    NSString *selectQuery = [NSString stringWithFormat:@"select * from MachineConfig"];
    
    machineArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];
    for (int i=0; i<[machineArr count]; i++) {
        
        NSString *selectSwitch = [NSString stringWithFormat:@"select count(*) from Components where  machine_id=%ld AND component_type='%@'",[[[machineArr objectAtIndex:i] objectAtIndex:0] integerValue],@"dimmer"];
        if([[self.dbHandler MathOperationInTable:selectSwitch] integerValue] == 0){
            
            [machineArr removeObjectAtIndex:i];
        }
        else {
            
            [segmentTitles addObject:[[machineArr objectAtIndex:i]objectAtIndex:1]];
            [segmentIdArr addObject:[[machineArr objectAtIndex:i]objectAtIndex:0]];
        }
    }
    [self.segmentControl removeAllSegments];
    for (NSString *segment in segmentTitles) {
        [self.segmentControl insertSegmentWithTitle:segment atIndex:self.segmentControl.numberOfSegments animated:NO];
    }
}
- (IBAction)btnCloseRenameView:(id)sender {
    [self.viewRenameDimmer setHidden:YES];
}

- (IBAction)btnRenameDimmer:(id)sender {
    [self.view endEditing:YES];
    if ([self.txtDimmerName.text length]==0) {
        [self.view makeToast:@"Enter Dimmer name"];
    }
    else{
        [self.viewRenameDimmer setHidden:YES];
        
        NSString *updateQuery = [NSString stringWithFormat:@"update Components set component_name='%@' where component_id=%ld",[self.txtDimmerName text],component_id];
        [self.dbHandler UpdateDataWithQuesy:updateQuery];
        [self fetchDimmersForSelectedMachine:[segmentIdArr objectAtIndex:self.segmentControl.selectedSegmentIndex]];
        [self.tableView reloadData];
    }
}
#pragma - mark UISegment IBAction method

- (IBAction)segmentControl:(id)sender {
    
    [timer invalidate];
    [self.viewRenameDimmer setHidden:YES];
    
    [self showHud];
    dispatch_async(dispatch_get_main_queue(), ^{
   
         [self fetchDimmersForSelectedMachine:[segmentIdArr objectAtIndex:self.segmentControl.selectedSegmentIndex]];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self fetchActiveMachineForSwitchAction:[segmentIdArr objectAtIndex:self.segmentControl.selectedSegmentIndex]];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self requestDimmerStatusForSelectedMachine:self.segmentControl.selectedSegmentIndex];
    });

    [self callTimer];
}
-(void)fetchDimmersForSelectedMachine :(NSString *)machineID{
    
    NSString *selectQuery = [NSString stringWithFormat:@"select * from Components where machine_id=%ld AND component_type='%@'",[machineID integerValue],@"dimmer"];
    
    dimmerArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:5];
    [self.tableView reloadData];
}

-(void)fetchActiveMachineForSwitchAction:(NSString *)machineID{
    
    NSString *selectQuery = [NSString stringWithFormat:@"select isActive from MachineConfig where machine_id=%ld",[machineID integerValue]];
    
    isActiveStatus = [[[[self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:1] objectAtIndex:0] objectAtIndex:0] integerValue];
   
    if (isActiveStatus==0) {
        [self.viewDisableComponent setHidden:NO];
    }
    else{
        [self.viewDisableComponent setHidden:YES];
    }
}

#pragma - mark UITableView UIButton click methods

-(void)btnRename:(UIButton*)sender
{
    component_id=[[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0]integerValue];
    [self.txtDimmerName setText:[[dimmerArr objectAtIndex:sender.tag]
                                 objectAtIndex:2]];
    [self.viewRenameDimmer setHidden:NO];
}

-(void)btnFavourite: (UIButton*) sender{
    component_id=[[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0]integerValue];
    if ([[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:4]isEqualToString:@"0"]) {
        
        NSString *updateQuery = [NSString stringWithFormat:@"update Components set isFavourite='%@' where component_id=%ld",@"1",component_id];
        
        [self.dbHandler UpdateDataWithQuesy:updateQuery];
        [self fetchDimmersForSelectedMachine:[segmentIdArr objectAtIndex:self.segmentControl.selectedSegmentIndex]];
        [self.tableView reloadData];
    }
    else{
        NSString *updateQuery = [NSString stringWithFormat:@"update Components set isFavourite='%@' where component_id=%ld",@"0",component_id];
        
        [self.dbHandler UpdateDataWithQuesy:updateQuery];
        [self fetchDimmersForSelectedMachine:[segmentIdArr objectAtIndex:self.segmentControl.selectedSegmentIndex]];
        [self.tableView reloadData];
    }
}

-(void)btnScene:(UIButton*)sender {
    
    [timer invalidate];
    AllSceneViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ALL_SCENE"];
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    popover.component_id=[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0];
    [self presentViewController:popover animated:YES completion:nil];
}

-(void)btnScheduler:(UIButton *)sender {
    
    [timer invalidate];
    
    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:0] forKey:@"component_id"];
    [dataDict setObject:[[dimmerArr objectAtIndex:sender.tag]objectAtIndex:2]  forKey:@"component_name"];
    [dataDict setObject:@"dimmer" forKey:@"component_type"];
    
    SchedulerDialogueViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"SCEHDULER_DIALOGUE"];
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    popover.dataDict=dataDict;
    popover.delegate=(id)self;
    [self presentViewController:popover animated:YES completion:nil];
}

-(BOOL)checkInternetConnectivity{
    BOOL isConnected;
    if ([[[machineArr objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:10] integerValue] == 1 ) {
        networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus != ReachableViaWWAN||networkStatus == ReachableViaWiFi)
        {
            isConnected=YES;
        }
        else{
            isConnected=NO;
        }
    }
    else{
        networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus == ReachableViaWiFi)
        {
            isConnected=YES;
        }
        else{
            isConnected=NO;
        }
    }
    return isConnected;
}

-(void)btnChangeMchineDimmerState:(UIButton*)sender{
    [timer invalidate];
    
    if ([self checkInternetConnectivity] ==YES) {

    dispatch_async(dispatch_get_main_queue(), ^{
        [hud show:YES];
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
        NSString *dimmerNo=[NSString stringWithFormat:@"%.2ld",sender.tag+1];
        UISwitch *switchControl = (UISwitch *)sender;
        NSString *switchState=[[NSMutableString alloc]init];
        if (switchControl.on==YES) {
            switchState=@"01";
        }
        else{
            switchState=@"00";
        }
        
        NSString *strIP = [[NSMutableString alloc] init];
        
        if ([[[machineArr objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:10] integerValue] == 1 ) {
            strIP =[[machineArr objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:3];
            
        }else{
            strIP = [[machineArr objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:2];
        }
        NSString *callURL=[NSString stringWithFormat:@"http://%@/cdmcr.cgi?DM=%@%@%@",strIP,dimmerNo,switchState,[dimmerRateArr objectAtIndex:sender.tag]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:callURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if ([data length] > 0 && error == nil)
            {
                if ([dimmerStatusArr count]>0) {
                    [dimmerStatusArr replaceObjectAtIndex:sender.tag withObject:switchState];
                }
            }
            else if (error != nil){
                
            }
            
        }];
        [task resume];
        [self hideHud];
        
        
    });
    }
    else{
        [self.view makeToast:@"Please check your internet connectivity"];
        [dimmerStatusArr replaceObjectAtIndex:sender.tag withObject:@"00"];
        [self.tableView reloadData];
    }
    [self callTimer];


}

-(void)sliderChangeValue:(UISlider *)sender{
    
    [timer invalidate];
    
    if ([self checkInternetConnectivity] ==YES) {

    NSString *switchState;
    
    NSInteger sliderValue = (int)sender.value;
    if (sliderValue ==0) {
        switchState=@"00";
    }
    else{
        switchState=@"01";
    }
    if (sliderValue==100) {
    
        sliderValue=99;
    }
    else {
        sliderValue-=1;
    }
    [dimmerRateArr replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%.2ld",sliderValue]];
    [dimmerStatusArr replaceObjectAtIndex:sender.tag withObject:switchState];
    
    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud show:YES];
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *dimmerNo=[NSString stringWithFormat:@"%.2ld",sender.tag+1];
               NSString *strIP = [[NSMutableString alloc] init];
                if ([[[machineArr objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:10] integerValue] == 1 ) {
            strIP =[[machineArr objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:3];
            
        }else{
            strIP = [[machineArr objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:2];
        }
        NSString *callURL=[NSString stringWithFormat:@"http://%@/cdmcr.cgi?DM=%@%@%.2ld",strIP,dimmerNo,switchState,sliderValue];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:callURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if ([data length] > 0 && error == nil)
            {
                if ([dimmerRateArr count]>0 && [dimmerStatusArr count]>0) {
                    [dimmerRateArr replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%ld",sliderValue]];
                    [dimmerStatusArr replaceObjectAtIndex:sender.tag withObject:switchState];
                }
                
            }
            else if (error != nil){
                
            }
            
        }];
        [task resume];
        [self hideHud];
        
        
    });
    }
    else{
        [self.view makeToast:@"Please check your internet connectivity"];
        [self.tableView reloadData];
    }
    [self callTimer];
    

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

#pragma mark - Machine status related method

-(void)fetchActiveMachineDataFromDatabase{
    
    NSString *selectQuery = [NSString stringWithFormat:@"select *from MachineConfig where isActive=1"];
    
    machineArray = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];
}

-(void)fetchMachineStatus:(NSTimer*)t{
    
    NSMutableArray *mutableArr=[[NSMutableArray alloc]init];

    [self fetchActiveMachineDataFromDatabase];
   
    dispatch_group_t group = dispatch_group_create();
    
    for (int i=0; i < [machineArray count]; i++) {
        dispatch_group_enter(group);
        NSString *url = [[NSMutableString alloc] init];
        
        if ([[[machineArray objectAtIndex:i] objectAtIndex:10] integerValue] == 1 ) {
            url = [NSString stringWithFormat:@"http://%@/dmcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:3]];
            
        }else{
            url = [NSString stringWithFormat:@"http://%@/dmcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:2]];
        }
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:DIMMER_TIME_OUT];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if ([data length] > 0 && error == nil) {
                
                NSString *stringURL;
                if ([machineArray count]>self.segmentControl.selectedSegmentIndex) {

                if ([[[machineArray objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:10] integerValue] == 1 ) {
                    stringURL = [[machineArray objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:3];
                    
                }else{
                    stringURL = [[machineArray objectAtIndex:self.segmentControl.selectedSegmentIndex] objectAtIndex:2];
                }
                
                if ([url containsString:stringURL]) {
                    responseData=data;
                    
                }
                }
            }else if (error != nil){
                
               [mutableArr addObject:[[machineArr objectAtIndex:i] objectAtIndex:2]];
                
            }
            dispatch_group_leave(group);
        }];
        [task resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        
        for (int j=0; j<[mutableArr count]; j++) {
            
            NSString *updateQuery = [NSString stringWithFormat:@"update MachineConfig set isActive='%@' where machine_ip='%@'",[NSNumber numberWithInteger:0],[mutableArr objectAtIndex:j]];
            [self.dbHandler UpdateDataWithQuesy:updateQuery];
        }
        NSString *selectQuery = [NSString stringWithFormat:@"select * from MachineConfig"];
        
        machineArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];

        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:responseData];
        [xmlParser setDelegate:(id)self];
        [xmlParser parse];
        
        if ([self.xmlData count]>0) {
            
            [self fetchDimmerCount:0];
            for (int i=0; i<dimmers; i++) {
                NSString *str=[NSString stringWithFormat:@"DM%.2i",i+1];
                
                [dimmerStatusArr addObject:[[self.xmlData valueForKey:str] substringWithRange:NSMakeRange(0, [[self.xmlData valueForKey:str] length]-2)]];
                [dimmerRateArr addObject:[[self.xmlData valueForKey:str] substringWithRange:NSMakeRange(2, [[self.xmlData valueForKey:str] length]-2)]];
            }

        }
        [self showHud];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.tableView reloadData];
            [self hideHud];
        });
        
        [self fetchActiveMachineForSwitchAction:[segmentIdArr objectAtIndex:self.segmentControl.selectedSegmentIndex]];
        
        NSString *selAllMachine = [NSString stringWithFormat:@"select count(*) from MachineConfig"];
        totalMachine = [[self.dbHandler MathOperationInTable:selAllMachine] integerValue];
        
        NSString *selActiveMachine=[NSString stringWithFormat:@"select count(*) from MachineConfig where isActive=1"];
        activeMachine = [[self.dbHandler MathOperationInTable:selActiveMachine] integerValue];
        
        if(activeMachine==0){
            [timer invalidate];
            UIViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"DISABLE_DIALOGUE"];
            popover.modalPresentationStyle = UIModalPresentationCustom;
            [popover setTransitioningDelegate:_customTransitionController];
            [self presentViewController:popover animated:YES completion:nil];
        }
        else
        {
            if (activeMachine < totalMachine) {
                [timer invalidate];
                [self.viewDisableComponent makeToast:@"This machine is disabled"];
            }
            
        }
        
    });
}

#pragma - mark Switch method call method

-(void) requestDimmerStatusForSelectedMachine:(NSInteger)indexNo {
    
    [timer invalidate];
    
    [self.tableView setHidden:YES];
    
    if ([[[machineArr objectAtIndex:indexNo] objectAtIndex:4] integerValue] == 1) {

    NSString *url = [[NSMutableString alloc] init];
    
    if ([[[machineArr objectAtIndex:indexNo] objectAtIndex:10] integerValue] == 1 ) {
        networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus == ReachableViaWWAN||networkStatus == ReachableViaWiFi)
        {
        url = [NSString stringWithFormat:@"http://%@/dmcr.xml",[[machineArr objectAtIndex:indexNo] objectAtIndex:3]];
        }
        else{
            networkStatus = [reachability currentReachabilityStatus];
            if (networkStatus == ReachableViaWiFi)
            {
            [self.view makeToast:@"You aren't connected to internet."];
            }
            else{
            
                [self.view makeToast:@"You aren't connected to Wi-Fi."];
            }
        }

    }else{
        url = [NSString stringWithFormat:@"http://%@/dmcr.xml",[[machineArr objectAtIndex:indexNo] objectAtIndex:2]];
    }
   
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ([data length] > 0 && error == nil) {
            [self hideHud];
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            [xmlParser setDelegate:(id)self];
            [xmlParser parse];
            if ([self.xmlData count]>0) {
                
                [self fetchDimmerCount:0];
                for (int i=0; i<dimmers; i++) {
                    NSString *str=[NSString stringWithFormat:@"DM%.2i",i+1];
                    
                    [dimmerStatusArr addObject:[[self.xmlData valueForKey:str] substringWithRange:NSMakeRange(0, [[self.xmlData valueForKey:str] length]-2)]];
                    [dimmerRateArr addObject:[[self.xmlData valueForKey:str] substringWithRange:NSMakeRange(2, [[self.xmlData valueForKey:str] length]-2)]];

                }
                
            }
            [self showHud];
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self fetchActiveMachineForSwitchAction:[segmentIdArr objectAtIndex:self.segmentControl.selectedSegmentIndex]];
                  [self.tableView reloadData];
                  [self.tableView setHidden:NO];
                  [self hideHud];
              });
        }
        else if ([data length] == 0 || error == nil){
            [self hideHud];
        
        }
        else if (error != nil){
            [self hideHud];
        }
    }];
    [task resume];
    }
    else{
        [self hideHud];
        
    }

}

-(void)fetchDimmerCount:(NSInteger)indexNo{
    NSString *selectSwitch = [NSString stringWithFormat:@"select count(*) from Components where  component_type='%@' AND machine_id=%ld",@"dimmer",[[[machineArr objectAtIndex:indexNo] objectAtIndex:0] integerValue]];
    dimmers = [[self.dbHandler MathOperationInTable:selectSwitch] integerValue];

}

#pragma - mark  NSXMLParser Delegate methods

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    if ([elementName isEqualToString:@"DMCR"]) {
        self.xmlData = [[NSMutableDictionary alloc] init];
        dimmerStatusArr=[[NSMutableArray alloc]init];
        dimmerRateArr=[[NSMutableArray alloc]init];
        arr=[[NSMutableArray alloc]init];
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (!mstrXMLString) {
        mstrXMLString = [[NSMutableString alloc] initWithString:string];
    }else{
        [mstrXMLString appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if (![elementName isEqualToString:@"SWCR"]) {
        [self.xmlData setValue:[mstrXMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:elementName];
        
    }
    mstrXMLString = nil;
}

-(void)reloadDataFromController {
    [self callTimer];
}

@end
