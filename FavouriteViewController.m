//
//  FavouriteViewController.m
//  D2brain
//
//  Created by webmyne systems on 23/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavouriteTableViewCell.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIView+Toast.h"

@interface FavouriteViewController ()
{
    FavouriteTableViewCell *cell;
    NSArray *componentArr, *machineArray;
    Reachability *reachability;
    NetworkStatus networkStatus;
    MBProgressHUD *hud;
    NSMutableArray *machineURL;
    NSMutableArray *dataArr;
    NSMutableDictionary *dataDict,*myDict;
    NSMutableArray *componentStatus;
    NSString *componentId;
}
@end

@implementation FavouriteViewController
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
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    self.btnHeaderBack.layer.borderWidth=1.5f;
    self.btnHeaderBack.layer.cornerRadius=13.0f;
    self.btnHeaderBack.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.viewNoFavourite setHidden:YES];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    machineURL=[[NSMutableArray alloc]init];
    componentStatus=[[NSMutableArray alloc]init];
    dataDict=[[NSMutableDictionary alloc]init];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [self showHud];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self fetchAllFavouriteComponent];
    });
     dispatch_async(dispatch_get_main_queue(), ^{
       
         [self fetchMachineFromDatabase];
     });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([componentArr count]==0) {
        [self.viewNoFavourite setHidden:NO];
    }
    else{
        [self.viewNoFavourite setHidden:YES];
    }
    return [componentStatus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[componentArr objectAtIndex:indexPath.row] objectAtIndex:3]isEqualToString:@"switch"]) {
        
        cell=(FavouriteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellSwitch"];
       
        if ([[componentStatus objectAtIndex:indexPath.row] isEqualToString:@"00"]) {
            cell.switchSwitches.on=NO;
        }
        else {
            cell.switchSwitches.on=YES;
        }
        [cell.switchSwitches setTag:indexPath.row];
        [cell.switchSwitches addTarget:self
                                action:@selector(btnChangeMachineSwitchState:) forControlEvents:UIControlEventValueChanged];
        [cell.lblSwitchName setText:[[componentArr objectAtIndex:indexPath.row]objectAtIndex:2]];
        [cell.lblSwitchMachineName setText:[[componentArr objectAtIndex:indexPath.row]objectAtIndex:7]];
        cell.deleteSwitch.tag=indexPath.row;
        [cell.deleteSwitch addTarget:self
                              action:@selector(btnDeleteComponent:) forControlEvents:UIControlEventTouchDown];
    }
    else {
        
        cell=(FavouriteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellDimmer"];
        
        if ([[[componentStatus objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"00"]) {
            cell.switchDimmers.on=NO;
        }
        else {
            cell.switchDimmers.on=YES;
        }
        if ([[[componentStatus objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(2, 2)] floatValue]==0) {
            
            cell.sliderDimmer.value=[[[componentStatus objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(2, 2)] floatValue];
            cell.lblDimmerRating.text=[NSString stringWithFormat:@"%.2ld",[[[componentStatus objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(2, 2)] integerValue]];
        }
        else {
            
            cell.sliderDimmer.value=[[[componentStatus objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(2, 2)] floatValue]+1;
            cell.lblDimmerRating.text=[NSString stringWithFormat:@"%.2ld",[[[componentStatus objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(2, 2)] integerValue]+1];
        }
        
        [cell.switchDimmers setTag:indexPath.row];
        [cell.sliderDimmer setTag:indexPath.row];
        
        [cell.switchDimmers addTarget:self
                               action:@selector(btnChangeDimmerSwitchState:) forControlEvents:UIControlEventValueChanged];
        [cell.lblDimmerName setText:[[componentArr objectAtIndex:indexPath.row]objectAtIndex:2]];
        [cell.lblDimmerMachineName setText:[[componentArr objectAtIndex:indexPath.row]objectAtIndex:7]];
        [cell.sliderDimmer addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
        cell.deleteDimmer.tag=indexPath.row;
        [cell.deleteDimmer addTarget:self
                              action:@selector(btnDeleteComponent:) forControlEvents:UIControlEventTouchDown];
    }
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight;
    if ([[[componentArr objectAtIndex:indexPath.row] objectAtIndex:3]isEqualToString:@"switch"]) {
        cellHeight=61.0;
    }
    else{
        cellHeight=108.0f;
    }
    return cellHeight;
}


#pragma - mark UIAlertView Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            
        }
        else if(buttonIndex == 1)
        {
            NSString *updateQuery = [NSString stringWithFormat:@"update Components set isFavourite=%@ where  component_id=%ld",@"0",[componentId integerValue]];
            [self.dbHandler UpdateDataWithQuesy:updateQuery];
        
            [self viewDidLoad];
        }
    }
}

#pragma - mark UITableView IBAction methods

-(BOOL)checkInternetConnectivity :(NSString *)strValue{
    BOOL isConnected;
    if ([strValue isEqualToString:@"1"]) {
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
-(void)btnChangeMachineSwitchState:(UIButton*)sender {
    
   
    if ([self checkInternetConnectivity:[[componentArr objectAtIndex:sender.tag] objectAtIndex:10]] ==YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud show:YES];
            
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UISwitch *switchControl = (UISwitch *)sender;
            NSString *switchNo=[[[componentArr objectAtIndex:sender.tag] objectAtIndex:5]substringWithRange:NSMakeRange(2, 2)];
            
            NSString *switchState=[[NSMutableString alloc]init];
            
            if (switchControl.on==YES) {
                switchState=@"01";
                
            }
            else{
                switchState=@"00";
            }
             NSString *callURL;
           
            if ([[[componentArr objectAtIndex:sender.tag]objectAtIndex:10] isEqualToString:@"1"]) {
                
                callURL=[NSString stringWithFormat:@"http://%@/cswcr.cgi?SW=%@%@",[[componentArr objectAtIndex:sender.tag]objectAtIndex:8],switchNo,switchState];
            }
            else {
                callURL=[NSString stringWithFormat:@"http://%@/cswcr.cgi?SW=%@%@",[[componentArr objectAtIndex:sender.tag]objectAtIndex:6],switchNo,switchState];
            }
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:callURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if ([data length] > 0 && error == nil)
                {
                     [componentStatus replaceObjectAtIndex:sender.tag withObject:switchState];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideHud];
                        [self.tableView reloadData];
                    });
                }
                else if (error != nil){
                    if ([switchState isEqualToString:@"00"]) {
                        [componentStatus replaceObjectAtIndex:sender.tag withObject:@"01"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideHud];
                            [self.tableView reloadData];
                        });
                    }
                    else {
                        [componentStatus replaceObjectAtIndex:sender.tag withObject:@"00"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideHud];
                            [self.tableView reloadData];
                        });
                    }
                }
            
            }];
            [task resume];
            
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [self hideHud];
            [self.view makeToast:@"Please check your Internet connectivity"];
        });
    }
}
-(void)btnChangeDimmerSwitchState:(UIButton*)sender {
    
    
    if ([self checkInternetConnectivity:[[componentArr objectAtIndex:sender.tag] objectAtIndex:10]] ==YES) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud show:YES];
            
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UISwitch *switchControl = (UISwitch *)sender;
            NSString *switchNo=[[[componentArr objectAtIndex:sender.tag] objectAtIndex:5]substringWithRange:NSMakeRange(2, 2)];
            
            NSString *switchState=[[NSMutableString alloc]init];
            
            if (switchControl.on==YES) {
                
                switchState=@"01";
            }
            else{
                
                switchState=@"00";
            }
            NSString *callURL;
            
            if ([[[componentArr objectAtIndex:sender.tag]objectAtIndex:10] isEqualToString:@"1"]) {
                
                callURL=[NSString stringWithFormat:@"http://%@/cdmcr.cgi?DM=%@%@%@",[[componentArr objectAtIndex:sender.tag]objectAtIndex:8],switchNo,switchState,[[componentStatus objectAtIndex:sender.tag] substringWithRange:NSMakeRange(2, 2)]];
            }
            else {
                callURL=[NSString stringWithFormat:@"http://%@/cdmcr.cgi?DM=%@%@%@",[[componentArr objectAtIndex:sender.tag]objectAtIndex:6],switchNo,switchState,[[componentStatus objectAtIndex:sender.tag] substringWithRange:NSMakeRange(2, 2)]];
            }
           
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:callURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if ([data length] > 0 && error == nil)
                {
                    [componentStatus replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%@%@",switchState,[[componentStatus objectAtIndex:sender.tag]substringWithRange:NSMakeRange(2, 2)]]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideHud];
                        [self.tableView reloadData];
                    });
                }
                else if (error != nil){
                    
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideHud];
                            [self.tableView reloadData];
                        });
                }
                
            }];
            [task resume];
            
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.tableView reloadData];
            [self hideHud];
            [self.view makeToast:@"Please check your Internet connectivity"];
        });
        
    }
}
-(void)sliderChangeValue:(UISlider *)sender{
    
    
    if ([self checkInternetConnectivity:[[componentArr objectAtIndex:sender.tag] objectAtIndex:10]] ==YES) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud show:YES];
            
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
            NSString *dimmerNo=[[[componentArr objectAtIndex:sender.tag] objectAtIndex:5]substringWithRange:NSMakeRange(2, 2)];
            NSString *dimmerValue;
            
            NSString *switchState=[[NSMutableString alloc]init];
            if ((int)sender.value ==0) {
                switchState=@"00";
            }
            else{
                switchState=@"01";
            }
            
            dimmerValue=[NSString stringWithFormat:@"%.2d",(int)sender.value];
            if ((int)sender.value==100) {
                dimmerValue=@"99";
            }
            else {
                dimmerValue=[NSString stringWithFormat:@"%.2d",(int)sender.value-1];
            }
            
            NSString *callURL;

            if ([[[componentArr objectAtIndex:sender.tag]objectAtIndex:10] isEqualToString:@"1"]) {
                
               callURL=[NSString stringWithFormat:@"http://%@/cdmcr.cgi?DM=%@%@%@",[[componentArr objectAtIndex:sender.tag]objectAtIndex:8],dimmerNo,switchState,dimmerValue];
            }
            else {
               
                callURL=[NSString stringWithFormat:@"http://%@/cdmcr.cgi?DM=%@%@%@",[[componentArr objectAtIndex:sender.tag]objectAtIndex:6],dimmerNo,switchState,dimmerValue];
            }

            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:callURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if ([data length] > 0 && error == nil)
                {
                    [componentStatus replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%@%@",[[componentStatus objectAtIndex:sender.tag]substringWithRange:NSMakeRange(2, 2)],dimmerValue]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        [self hideHud];
                    });
                }
                else if (error != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        [self hideHud];
                    });
                }
                
            }];
            [task resume];
            [self hideHud];
            
            
        });
    }
    else{
        [self.view makeToast:@"Please check your internet connectivity"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self hideHud];
        });
    }
    
}

-(void)btnDeleteComponent:(UIButton*)sender {
    componentId=[[componentArr objectAtIndex:sender.tag]objectAtIndex:0];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"D² Brain" message:@"Are you sure you want to remove this component from favourites?" delegate:(id)self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView setTag:1];
    [alertView show];
    
}

#pragma - mark Database Fetch methods

-(void)fetchAllFavouriteComponent{
    
    NSString *selectQuery = [NSString stringWithFormat:@"select c.* ,m.machine_ip, m.machine_name, m.worldwide_ip, m.isActive, m.isWWIPActive from Components As c JOIN MachineConfig As m  where c.machine_id = m.machine_id AND c.isFavourite='1'"];
    
    componentArr= [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];

}

-(void) fetchMachineFromDatabase {
    //select c.machine_id,m.machine_ip, m.worldwide_ip, m.isActive,m.isWWIPActive from Components As c JOIN MachineConfig As m  where c.machine_id = m.machine_id AND c.isFavourite='1' GROUP BY c.machine_id
    NSString *selectQuery = [NSString stringWithFormat:@"select c.machine_id,m.machine_ip, m.worldwide_ip, m.isActive,m.isWWIPActive from Components As c JOIN MachineConfig As m  where c.machine_id = m.machine_id AND c.isFavourite='1' GROUP BY c.machine_id"];
    
    machineArray= [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:5];
  
    for(int i=0; i<[machineArray count];i++) {
        
        if([[[machineArray objectAtIndex:i]objectAtIndex:4]isEqualToString:@"1"]) {
           
            [machineURL addObject:[NSString stringWithFormat:@"http://%@/swcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:2]]];
            [machineURL addObject:[NSString stringWithFormat:@"http://%@/dmcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:2]]];
        }
        else {
            
            [machineURL addObject:[NSString stringWithFormat:@"http://%@/swcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:1]]];
            [machineURL addObject:[NSString stringWithFormat:@"http://%@/dmcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:1]]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
         [self fetchComponentStateFromMachine];
    });
   
}

-(void) fetchComponentStateFromMachine {
    
    dispatch_group_t group = dispatch_group_create();

    for (int i=0; i < [machineURL count]; i++) {
        
        dispatch_group_enter(group);
        
        networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus != ReachableViaWWAN && networkStatus != ReachableViaWiFi) {
            
            [self.view makeToast:@"Please check your Internet Connectivity."];
        }
        else {
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:[machineURL objectAtIndex:i]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if ([data length] > 0 && error == nil) {
                    
                    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
                    [xmlParser setDelegate:(id)self];
                    [xmlParser parse];
                   
                    if ([self.xmlData count]>0) {
                        
                        [dataDict setObject:self.xmlData forKey:[response URL]];
                        
                    }
                }
                else if ([data length] == 0 || error != nil){
                    
                }
                dispatch_group_leave(group);
            }];
            [task resume];

        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSString *keyToFetch;
        
            for (int i=0; i<[componentArr count]; i++) {
                
                if ([[[componentArr objectAtIndex:i]objectAtIndex:3] isEqualToString:@"switch"]) {
                    
                    if ([[[componentArr objectAtIndex:i]objectAtIndex:10] isEqualToString:@"1"]) {
                       
                        keyToFetch=[NSString stringWithFormat:@"http://%@/swcr.xml",[[componentArr objectAtIndex:i]objectAtIndex:8]];
                        
                        for (NSString *key in [dataDict allKeys]) {
                            
                            if ([[NSString stringWithFormat:@"%@",key] isEqualToString:keyToFetch]) {
                             
                                [componentStatus addObject:[[dataDict objectForKey:key] objectForKey:[[componentArr objectAtIndex:i]objectAtIndex:5]]];
                            }
                        }
                    }
                    else {
                        keyToFetch=[NSString stringWithFormat:@"http://%@/swcr.xml",[[componentArr objectAtIndex:i]objectAtIndex:6]];
                        
                        for (NSString *key in [dataDict allKeys]) {
                           
                            if ([[NSString stringWithFormat:@"%@",key] isEqualToString:keyToFetch]) {
                              
                                [componentStatus addObject:[[dataDict objectForKey:key] objectForKey:[[componentArr objectAtIndex:i]objectAtIndex:5]]];
                            }
                        }
                    }
                
                }
                else if ([[[componentArr objectAtIndex:i]objectAtIndex:3] isEqualToString:@"dimmer"]) {
                    
                    if ([[[componentArr objectAtIndex:i]objectAtIndex:10] isEqualToString:@"1"]) {
                       
                        keyToFetch=[NSString stringWithFormat:@"http://%@/dmcr.xml",[[componentArr objectAtIndex:i]objectAtIndex:8]];
                       
                        for (NSString *key in [dataDict allKeys]) {
                            if ([[NSString stringWithFormat:@"%@",key] isEqualToString:keyToFetch]) {
                             
                                [componentStatus addObject:[[dataDict objectForKey:key] objectForKey:[[componentArr objectAtIndex:i]objectAtIndex:5]]];
                            }
                        }
                    }
                    else {
                        
                        keyToFetch=[NSString stringWithFormat:@"http://%@/dmcr.xml",[[componentArr objectAtIndex:i]objectAtIndex:6]];
                        
                        for (NSString *key in [dataDict allKeys]) {
                            if ([[NSString stringWithFormat:@"%@",key] isEqualToString:keyToFetch]) {
                             
                                [componentStatus addObject:[[dataDict objectForKey:key] objectForKey:[[componentArr objectAtIndex:i]objectAtIndex:5]]];
                            }
                        }
                    }
                    
                }
            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        [self hideHud];
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

#pragma - mark  NSXMLParser Delegate methods

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    if ([elementName isEqualToString:@"SWCR"]) {
        
        self.xmlData = [[NSMutableDictionary alloc] init];
    }
    if ([elementName isEqualToString:@"DMCR"]) {
        
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
    if (![elementName isEqualToString:@"SWCR"]) {
        [self.xmlData setValue:[mstrXMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:elementName];
        
    }
    if (![elementName isEqualToString:@"DMCR"]) {
        [self.xmlData setValue:[mstrXMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:elementName];
        
    }
    mstrXMLString = nil;
}
- (IBAction)btnHeaderBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([_delegate respondsToSelector:@selector(getBackFromController)])
    {
        [_delegate getBackFromController];
    }
    
}

@end
