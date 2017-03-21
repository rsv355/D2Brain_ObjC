//
//  AddMachineViewController.m
//  D2brain
//
//  Created by webmyne systems on 05/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "AddMachineViewController.h"
#import "AddMachineTableViewCell.h"
#import "CustomAnimationAndTransiotion.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "MachineEditViewController.h"
#import "AddMachineDialogueViewController.h"

@interface AddMachineViewController () <EditMachineViewControllerDelegate,MachineDialogueViewControllerDelegate>
{
    AddMachineTableViewCell *cell;
    NSMutableArray *machineArr;
    NSInteger machine_id;
    Reachability *reachability;
    NetworkStatus networkStatus;
    NSString *worldWideIP,*serialNo,*productCode,*devieIP;
    NSInteger validateProductCode;
    MBProgressHUD *hud;
    NSInteger disableMachineCount,switchNO;
}
@property (nonatomic,strong) CustomAnimationAndTransiotion *customTransitionController;

@end

@implementation AddMachineViewController
@synthesize mstrXMLString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *deviceName=[[UIDevice currentDevice]name];
    if ([deviceName containsString:@"iPad"]) {
        //NSLog(@"it's an iPad");
        CGAffineTransform transform = CGAffineTransformMakeScale(1.6, 1.6);
        [self.view setTransform:transform];
    }
    else
    {
        // NSLog(@"It's an iPhone");
    }
    
    self.btnHeaderBack.layer.borderWidth=1.5f;
    self.btnHeaderBack.layer.cornerRadius=13.0f;
    self.btnHeaderBack.layer.borderColor=[UIColor whiteColor].CGColor;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    reachability =[Reachability reachabilityWithHostname:@"www.google.com"];
    [self.containerView setHidden:YES];
    // Do any additional setup after loading the view.
    machineArr=[[NSMutableArray alloc]init];
    
    //----NETWORK CONNECTION
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    
    //------DATABASE CLASS OBJECT ALLOC
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    [self fetchMachineDataFromDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [machineArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(AddMachineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ([[[machineArr objectAtIndex:indexPath.row]objectAtIndex:3] length]==0) {
        [cell.switchWorldWide setHidden:YES];
        [cell.viewWorldWideHeightConst setConstant:0.0f];
        [cell.viewLineHeightconst setConstant:0.0f];
    }
    else{
        [cell.switchWorldWide setHidden:NO];
        [cell.viewWorldWideHeightConst setConstant:49.0f];
        [cell.viewLineHeightconst setConstant:1.0f];
        
    }
    cell.switchMachine.transform = CGAffineTransformMakeScale(0.75, 0.75);
    cell.switchWorldWide.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    if ([[[machineArr objectAtIndex:indexPath.row]objectAtIndex:4] integerValue]==0) {
        cell.switchMachine.on=NO;
    }
    else{
        cell.switchMachine.on=YES;
    }
    if ([[[machineArr objectAtIndex:indexPath.row]objectAtIndex:10] integerValue]==0) {
        cell.switchWorldWide.on=NO;
    }
    else{
        cell.switchWorldWide.on=YES;
        
    }
    [cell.lblMachineName setText:[[machineArr objectAtIndex:indexPath.row]objectAtIndex:1]];
    [cell.lblMachinIPAddress setText:[[machineArr objectAtIndex:indexPath.row]objectAtIndex:2]];
    [cell.lblMachinSerialNo setText:[[machineArr objectAtIndex:indexPath.row]objectAtIndex:6]];
    [cell.lblWorldWideIP setText:[[machineArr objectAtIndex:indexPath.row]objectAtIndex:3]];
    [cell.btnDelete setTag:indexPath.row];
    [cell.btnEdit setTag:indexPath.row];
    [cell.switchMachine setTag:indexPath.row];
    [cell.switchWorldWide setTag:indexPath.row];
    
    [cell.btnDelete addTarget:self
                       action:@selector(btnDeleteMachine:) forControlEvents:UIControlEventTouchDown];
    [cell.btnEdit addTarget:self
                     action:@selector(btnEditMachine:) forControlEvents:UIControlEventTouchDown];
    [cell.switchMachine addTarget:self
                           action:@selector(btnSwitchMachine:) forControlEvents:UIControlEventValueChanged];
    
    [cell.switchWorldWide addTarget:self
                             action:@selector(btnSwitchWorldwide:) forControlEvents:UIControlEventValueChanged];
    if ([machineArr count]==1) {
        cell.btnDeleteWidthConst.constant=0.0f;
    }
    else {
        cell.btnDeleteWidthConst.constant=26.0f;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    if ([[[machineArr objectAtIndex:indexPath.row]objectAtIndex:3] length]==0) {
        cellHeight=120.0f;
    }
    else{
        cellHeight=165.0;
    }
    return cellHeight;
}

#pragma - mark UIButton IBAction

-(void)btnDeleteMachine:(UIButton*)sender
{
    NSLog(@"I Clicked Delete %ld",sender.tag);
    machine_id=sender.tag;
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to delete the machine?" delegate:(id)self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertView setTag:1];
    [alertView show];
}
-(void)btnEditMachine:(UIButton*)sender
{
    NSLog(@"I Clicked Edit %ld",sender.tag);
    machine_id=sender.tag;
    [[NSUserDefaults standardUserDefaults]setObject:[[machineArr objectAtIndex:machine_id] objectAtIndex:0]  forKey:@"machine_ID"];
    MachineEditViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"ADD_MACHINE_EDIT"];
    popover.delegate=(id)self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];
}


-(void)btnSwitchMachine:(UIButton*)sender{
    UISwitch *switchControl = (UISwitch *)sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    networkStatus = [reachability currentReachabilityStatus];
    if (switchControl.on==YES) {
        
        if (networkStatus == ReachableViaWiFi)
        {
            NSLog(@"WIFI IS ON");
            if ([[[machineArr objectAtIndex:sender.tag] objectAtIndex:10] integerValue]==1) {
                [self requestMethodoForWorldWide:[[[machineArr objectAtIndex:sender.tag] objectAtIndex:0] integerValue]];
            }
            else{
                
                NSString *str=[[machineArr objectAtIndex:sender.tag]objectAtIndex:2];
                // [self.view makeToast:str];
                devieIP=[NSString stringWithFormat:@"http://%@/debt.xml",str];
                serialNo=[[machineArr objectAtIndex:sender.tag]objectAtIndex:6];
                NSLog(@"-66--->>%@",serialNo);
                productCode=[[machineArr objectAtIndex:sender.tag]objectAtIndex:8];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud show:YES];
                    
                });
                
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self requestMethodoForDeviceIP:[[[machineArr objectAtIndex:sender.tag]objectAtIndex:0] integerValue]];
                });
                
            }
        }
        else{
            [self.view makeToast:@"You aren't connected your WIFI"];
            [self fetchMachineDataFromDatabase];
            [self.tableView reloadData];
        }
        
    }
    else{
        NSString *updateQuery = [NSString stringWithFormat:@"update MachineConfig set isActive='%@' where machine_id=%ld",[NSNumber numberWithInteger:0],[[[machineArr objectAtIndex:sender.tag]objectAtIndex:0]integerValue]];
        NSLog(@"--->> %@",updateQuery);
        [self.dbHandler UpdateDataWithQuesy:updateQuery];
    }
    
}

-(void)btnSwitchWorldwide:(UIButton*)sender{
    
    networkStatus = [reachability currentReachabilityStatus];
    UISwitch *switchControl = (UISwitch *)sender;
    // NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    if (switchControl.on==YES) {
        switchNO=sender.tag;
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Are you you want to user World Wide IP?" delegate:(id)self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert setTag:5];
        [alert show];
        
    }
    else{
        NSString *updateQuery = [NSString stringWithFormat:@"update MachineConfig set isWWIPActive='%@' where machine_id=%ld",[NSNumber numberWithInteger:0],[[[machineArr objectAtIndex:sender.tag]objectAtIndex:0]integerValue]];
        NSLog(@"--->> %@",updateQuery);
        [self.dbHandler UpdateDataWithQuesy:updateQuery];
    }
}
-(void)userWorldWideIPMethod:(NSInteger)sendertag{
    if (networkStatus == ReachableViaWWAN||networkStatus == ReachableViaWiFi)
    {
        // [self.view makeToast:@"U R connected to internet."];
        
        NSString *str=[[machineArr objectAtIndex:sendertag]objectAtIndex:3];
        //[self.view makeToast:str];
        worldWideIP=[NSString stringWithFormat:@"http://%@",str];
        serialNo=[[machineArr objectAtIndex:sendertag]objectAtIndex:6];
        productCode=[[machineArr objectAtIndex:sendertag]objectAtIndex:8];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud show:YES];
            
        });
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self requestMethodoForWorldWide:[[[machineArr objectAtIndex:sendertag]objectAtIndex:0] integerValue]];
        });
    }
    else{
        [self.view makeToast:@"You aren't connected to internet."];
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            [self showHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSString *selectQuery = [NSString stringWithFormat:@"select component_id from Components where machine_id=%ld",[[[machineArr objectAtIndex:machine_id] objectAtIndex:0] integerValue]];
                NSArray *arrComponentId = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:1];
               
                NSString *deleteTouchPanel =[NSString stringWithFormat:@"delete from TouchPanel where machine_id=%ld",[[[machineArr objectAtIndex:machine_id] objectAtIndex:0] integerValue]];
                [self.dbHandler DeleteDataWithQuesy:deleteTouchPanel];
                
                for (int i=0; i<[arrComponentId count]; i++) {
                    
                    NSString *deleteComponentsQuery =[NSString stringWithFormat:@"delete from Scene_Component where component_id=%ld",[[[arrComponentId objectAtIndex:i] objectAtIndex:0] integerValue]];
                    
                    [self.dbHandler DeleteDataWithQuesy:deleteComponentsQuery];
                    
                    NSString *deleteComponentsQuery1 =[NSString stringWithFormat:@"delete from Scheduler where component_id=%ld",[[[arrComponentId objectAtIndex:i] objectAtIndex:0] integerValue]];
                    [self.dbHandler DeleteDataWithQuesy:deleteComponentsQuery1];
                   
                   
                    
                }
                NSString *selectSceneQuery = [NSString stringWithFormat:@"select * from Scene"];
                NSArray *sceneArray = [self.dbHandler selectAllDataFromTablewithQuery:selectSceneQuery ofColumn:3];
                
                for (int i=0; i<[sceneArray count]; i++) {
                    NSString *selectScene = [NSString stringWithFormat:@"select count(*) from Scene_Component where  scene_id=%ld",[[[sceneArray objectAtIndex:i] objectAtIndex:0] integerValue]];
                    NSInteger sceneCount = [[self.dbHandler MathOperationInTable:selectScene] integerValue];
                    
                    if (sceneCount==0) {
                        NSString *deleteSceneQuery =[NSString stringWithFormat:@"delete from Scene where scene_id=%ld",[[[sceneArray objectAtIndex:i] objectAtIndex:0] integerValue]];
                        
                        [self.dbHandler DeleteDataWithQuesy:deleteSceneQuery];
                    }
                }
                NSString *deleteMachineQuery =[NSString stringWithFormat:@"delete from MachineConfig where machine_id=%ld",[[[machineArr objectAtIndex:machine_id] objectAtIndex:0] integerValue]];
                [self.dbHandler DeleteDataWithQuesy:deleteMachineQuery];
                
                NSString *deleteComponentsQuery =[NSString stringWithFormat:@"delete from Components where machine_id=%ld",[[[machineArr objectAtIndex:machine_id] objectAtIndex:0] integerValue]];
                [self.dbHandler DeleteDataWithQuesy:deleteComponentsQuery];
                
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self fetchMachineDataFromDatabase];
            });
            
            [self hideHud];
            
        }
        
    }
    
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            [self fetchMachineDataFromDatabase];
            [self.tableView reloadData];
            [self hideHud];
        }
    }
    else if(alertView.tag == 3)
    {
        if(buttonIndex == 0)
        {
            [self fetchMachineDataFromDatabase];
            [self.tableView reloadData];
            [self hideHud];
        }
    }
    else if(alertView.tag == 5)
    {
        if(buttonIndex == 1)
        {
            NSLog(@"userWOrldWideIP method------");
            [self userWorldWideIPMethod:switchNO];
            
        }
        else if(buttonIndex == 0)
        {
            [self fetchMachineDataFromDatabase];
            [self.tableView reloadData];
        }
    }
}
#pragma - mark Add Machine Methods

- (IBAction)btnAddMachine:(id)sender {
    
    AddMachineDialogueViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"ADD_MACHINE_DIALOGUE"];
    popover.delegate=(id)self;
    popover.modalPresentationStyle = UIModalPresentationCustom;
    [popover setTransitioningDelegate:_customTransitionController];
    [self presentViewController:popover animated:YES completion:nil];
}


-(void)fetchMachineDataFromDatabase{
    
    NSString *selectQuery = [NSString stringWithFormat:@"select *from MachineConfig"];
    
    machineArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];
    [self.tableView reloadData];
    if ([machineArr count]>=5) {
        [self.btnAddMachine setHidden:YES];
    }
    else{
        [self.btnAddMachine setHidden:NO];
    }
}

- (void)requestMethodoForWorldWide :(NSInteger) machineID{
    //http://stackoverflow.com/questions/1849513/nsxmlparser-initwithcontentsofurl-timeout
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"WORLD_WIDE_IP------%@",worldWideIP);
    
    
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/debt.xml",worldWideIP]]];
    [xmlparser setDelegate:(id)self];
    
    
    BOOL success = [xmlparser parse];
    
    if(success==YES){
        NSLog(@"No Errors");
        [xmlparser parse];
        if ([self.xmlData count]>0) {
            
            if ([[self.xmlData valueForKey:@"DSN"] isEqualToString:serialNo])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSInteger ia= [self codeCharacter:[self.xmlData valueForKey:@"DPC"]];
                    NSLog(@"----%ld",ia);
                    if(ia ==9)
                    {
                        
                        NSString *updateQuery = [NSString stringWithFormat:@"update MachineConfig set isWWIPActive='%@' where machine_id=%ld",[NSNumber numberWithInteger:1],machineID];
                        NSLog(@"--->> %@",updateQuery);
                        [self.dbHandler UpdateDataWithQuesy:updateQuery];
                    }
                    NSLog(@"---------------%ld",ia);
                    [self hideHud];
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:@"Serial number doesn't match"];
                    
                    [self fetchMachineDataFromDatabase];
                    [self.tableView reloadData];
                    [self hideHud];
                });
                
            }
        }
        
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Error Error Error!!!");
            UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:nil message:@"Your device isn't responding" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert1 setTag:2];
            [alert1 show];
        });
        
    }
    
}
- (void)requestMethodoForDeviceIP :(NSInteger) machineID{
    //http://stackoverflow.com/questions/1849513/nsxmlparser-initwithcontentsofurl-timeout
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:devieIP]];
    [xmlparser setDelegate:(id)self];
    
    BOOL success = [xmlparser parse];
    
    if(success==YES){
        NSLog(@"No Errors");
        [xmlparser parse];
        
        if ([[self.xmlData valueForKey:@"DSN"] isEqualToString:serialNo]) {
            
            [self hideHud];
            
            NSLog(@"Serial no matched");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSInteger validateCount= [self codeCharacter:[self.xmlData valueForKey:@"DPC"]];
                if(validateCount==9)
                {
                    
                    NSString *updateQuery = [NSString stringWithFormat:@"update MachineConfig set isActive='%@' where machine_id=%ld",[NSNumber numberWithInteger:1],machineID];
                    NSLog(@"--->> %@",updateQuery);
                    [self.dbHandler UpdateDataWithQuesy:updateQuery];
                }
                NSLog(@"---------------%ld",validateCount);
                [self hideHud];
            });
        }
        else{
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    [hud hide:YES];
            //
            //                });
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"Serial number doesn't match"];
                
                [self fetchMachineDataFromDatabase];
                [self.tableView reloadData];
                [self hideHud];
            });
            
            
        }
        // }
        
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Error Error Error!!!");
            UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:nil message:@"Check your Machine" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert1 setTag:3];
            [alert1 show];
        });
        //        [self fetchMachineDataFromDatabase];
        //        [self.tableView reloadData];
    }
    
}

-(NSInteger)codeCharacter:(NSString *)letters{
    NSMutableArray *letterArray = [NSMutableArray array];
    
    [letters enumerateSubstringsInRange:NSMakeRange(0, [letters length])
                                options:(NSStringEnumerationByComposedCharacterSequences)
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                 [letterArray addObject:substring];
                             }];
    
    if([letterArray count]==9){
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"INVAlid Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
    }
    else{
        for (int i=0; i<[letterArray count]; i++) {
            switch (i) {
                case 0:
                    
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"0"]||[[letterArray objectAtIndex:i] isEqualToString:@"1"]||[[letterArray objectAtIndex:i] isEqualToString:@"2"]||[[letterArray objectAtIndex:i] isEqualToString:@"3"]||[[letterArray objectAtIndex:i] isEqualToString:@"4"]||[[letterArray objectAtIndex:i] isEqualToString:@"5"]||[[letterArray objectAtIndex:i] isEqualToString:@"6"]||[[letterArray objectAtIndex:i] isEqualToString:@"7"]||[[letterArray objectAtIndex:i] isEqualToString:@"8"]||[[letterArray objectAtIndex:i] isEqualToString:@"9"]) {
                        validateProductCode+=1;
                    }

                    else{
                        
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        validateProductCode-=1;
                        
                    }
                    break;
                    
                case 1:
                    validateProductCode+=1;
                    break;
                    
                case 2:
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"0"]||[[letterArray objectAtIndex:i] isEqualToString:@"1"]||[[letterArray objectAtIndex:i] isEqualToString:@"2"]||[[letterArray objectAtIndex:i] isEqualToString:@"3"]) {
                        
                        validateProductCode+=1;
                    }
                    else{
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        
                        validateProductCode-=1;
                    }
                    break;
                    
                case 3:
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"0"]||[[letterArray objectAtIndex:i] isEqualToString:@"1"]||[[letterArray objectAtIndex:i] isEqualToString:@"2"]||[[letterArray objectAtIndex:i] isEqualToString:@"3"]) {
                        validateProductCode+=1;
                    }
                    else{
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        
                        validateProductCode-=1;
                    }
                    break;
                    
                    
                case 4:
                    validateProductCode+=1;
                    break;
                    
                case 5:
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"-"]) {
                        validateProductCode+=1;
                        
                    }
                    else{
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        NSLog(@"%d------>> %@",i,[letterArray objectAtIndex:i]);
                        validateProductCode-=1;
                        
                    }
                    
                    break;
                    
                case 6:
                    
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"0"]||[[letterArray objectAtIndex:i] isEqualToString:@"1"]||[[letterArray objectAtIndex:i] isEqualToString:@"2"]||[[letterArray objectAtIndex:i] isEqualToString:@"3"]) {
                        validateProductCode+=1;
                        
                    }
                    else{
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        NSLog(@"%d------>> %@",i,[letterArray objectAtIndex:i]);
                        validateProductCode-=1;
                    }
                    break;
                    
                case 7:
                    //validateProductCode+=1;
                    break;
                    
                case 8:
                    
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"7"]||[[letterArray objectAtIndex:i] isEqualToString:@"8"]||[[letterArray objectAtIndex:i] isEqualToString:@"9"]) {
                        
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        NSLog(@"%d------>> %@",i,[letterArray objectAtIndex:i]);
                        validateProductCode-=1;
                    }
                    else{
                        validateProductCode+=1;
                    }
                    break;
                    
                case 9:
                    
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"0"]) {
                        validateProductCode+=1;
                    }
                    //                    else{
                    //                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    //                        [alrt show];
                    //                        validateProductCode-=1;
                    //                    }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        
        
    }
    NSLog(@"varified---%ld",validateProductCode);
    return validateProductCode;
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"DeDt"]) {
        self.xmlData = [[NSMutableDictionary alloc] init];
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
    if (![elementName isEqualToString:@"DeDt"]) {
        [self.xmlData setValue:[mstrXMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:elementName];
    }
    mstrXMLString = nil;
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
                       //[hud removeFromSuperview];
                       
                       
                   });
}

- (IBAction)btnHeaderBack:(id)sender {
    
    if (_strDismiss ==nil) {
        NSLog(@"nil----------");
        [self fetchActiveMachinesFromDatabase];
        if (disableMachineCount==[machineArr count]) {
            //[self dismissViewControllerAnimated:YES completion:nil];
            UIViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"DISABLE_DIALOGUE"];
            popover.modalPresentationStyle = UIModalPresentationCustom;
            [popover setTransitioningDelegate:_customTransitionController];
            [self presentViewController:popover animated:YES completion:nil];
            
        }
        else{
            [[NSUserDefaults standardUserDefaults] setObject:@"MAINCONTAINER1" forKey:@"storyboardID"];
            NSLog(@"Main Container");
            UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MENU_DRAWER"];
            [self presentViewController:viewController animated:YES completion:nil];
              [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"showStartUpSceen1"];
        }

    }
    else {
        NSLog(@"Dismiss----------");
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(getBackFromController)])
        {
            [_delegate getBackFromController];
        }
    }
    
}
//-(void)fetchActiveMachinesFromDatabase{
//    //select count(*) from MachineConfig where  isActive=1
//
//    NSString *selectQuery = [NSString stringWithFormat:@"select count(*) from MachineConfig where  isActive=0"];
//
//    disableMachineCount = [[self.dbHandler MathOperationInTable:selectQuery] integerValue];
//
//}

-(void)fetchActiveMachinesFromDatabase{
    //select count(*) from MachineConfig where  isActive=1
    
    NSString *selectQuery = [NSString stringWithFormat:@"select count(*) from MachineConfig where  isActive=0"];
    
    disableMachineCount = [[self.dbHandler MathOperationInTable:selectQuery] integerValue];
    
    if (disableMachineCount==[machineArr count]) {
        
        UIViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"DISABLE_DIALOGUE"];
        popover.modalPresentationStyle = UIModalPresentationCustom;
        [popover setTransitioningDelegate:_customTransitionController];
        [self presentViewController:popover animated:YES completion:nil];
    }
}

-(void)getBackToController {
    [self.view makeToast:@"Machine updated successfully."];
    [self viewDidLoad];
}
-(void)getBackToMyController {
    [self.view makeToast:@"Machine added successfully."];
    [self viewDidLoad];
}

@end
