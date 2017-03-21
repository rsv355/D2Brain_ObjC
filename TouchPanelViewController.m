//
//  TouchPanelViewController.m
//  D2brain
//
//  Created by webmyne systems on 08/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "TouchPanelViewController.h"
#import "TouchPanelCollectionViewCell.h"
#import "UIView+Toast.h"
#import "TouchPanelTableViewCell.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "SaveDialogueViewController.h"
#import "TryAgainDialogueViewController.h"

@interface TouchPanelViewController () <SaveDialogueViewControllerDelegate, TryAgainDialogueViewControllerDelegate>
{
    TouchPanelCollectionViewCell *cell;
    TouchPanelTableViewCell *tCell;
   
    MBProgressHUD *hud;
    Reachability *reachability;
    NetworkStatus networkStatus;
    
    NSArray *componentArr,*touchPanelArr;
    UIColor *selectedColor, *selectedComponentColor, *onColor, *upColour, *downColor, *cellColor, *cellComponentColor;
    
    NSMutableArray *cellColorArr, *touchPanelColorArr, *touchPanelStatusArr;
    NSMutableDictionary *touchPanelColourDict, *touchPanelStatusDict,*dict;
   
    NSInteger switchCount, onCount, upCount, downCount;
    NSString *component_type, *functionType;
    
    NSMutableDictionary *positionDict;
    NSMutableArray *positionArr, *onArr, *downArr, *upArr;
    NSString *component_id, *machine_id, *component_number, *machine_ip, *c_num;
    NSArray *machineArr;
    NSInteger saveInt,swCount;
    NSMutableArray *dataArr;
    NSString *strPayload;
}
@end

@implementation TouchPanelViewController
@synthesize mstrXMLString;

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view. upColour= [UIColor colorWithRed:(33/255.0) green:(113/255.0) blue:(156/255.0) alpha:0.7f];
    
    selectedColor = [UIColor colorWithRed:(84/255.0) green:(109/255.0) blue:(126/255.0) alpha:1.0f];
    selectedComponentColor = [UIColor colorWithRed:(84/255.0) green:(109/255.0) blue:(126/255.0) alpha:1.0f];
    onColor= [UIColor colorWithRed:(127/255.0) green:(225/255.0) blue:(61/255.0) alpha:1.0f];
    upColour= [UIColor colorWithRed:(20/255.0) green:(70/255.0) blue:(99/255.0) alpha:0.7f];
    downColor= [UIColor colorWithRed:(170/255.0) green:(112/255.0) blue:(23/255.0) alpha:1.0f];
    cellColor = [UIColor colorWithRed:(37/255.0) green:(126/255.0) blue:(172/255.0) alpha:1.0f];
    cellComponentColor = [UIColor colorWithRed:(37/255.0) green:(126/255.0) blue:(172/255.0) alpha:1.0f];
    
    cellColorArr = [[NSMutableArray alloc]init];
    touchPanelColorArr = [[NSMutableArray alloc]init];
    touchPanelColourDict = [[NSMutableDictionary alloc]init];
    touchPanelStatusArr = [[NSMutableArray alloc]init];
    touchPanelStatusDict = [[NSMutableDictionary alloc]init];
    dict = [[NSMutableDictionary alloc]init];
    positionDict =[[NSMutableDictionary alloc]init];
    positionArr = [[NSMutableArray alloc]init];
    upArr=[[NSMutableArray alloc]init];
    downArr= [[NSMutableArray alloc]init];
    onArr= [[NSMutableArray alloc]init];
    dataArr=[[NSMutableArray alloc]init];
    
    switchCount=0;
    onCount=0;
    downCount=0;
    upCount=0;
    saveInt=1;
    
    [self boldFontForLabel:self.btnOn forSize:13];
    [self boldFontForLabel:self.btnUp forSize:10];
    [self boldFontForLabel:self.btnDown forSize:10];
    
    reachability =[Reachability reachabilityWithHostname:@"www.google.com"];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    
    component_type=@"switch";
    functionType=@"on";
    
    [self setViewOnLoad];
  
    [self fetchMachineDataFromDatabase];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setViewOnLoad {
    
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    self.btnHeaderBack.layer.borderWidth=1.5f;
    self.btnHeaderBack.layer.cornerRadius=13.0f;
    self.btnHeaderBack.layer.borderColor=[UIColor whiteColor].CGColor;
    
    self.viewOnOff.layer.cornerRadius=10.0f;
    self.viewUp.layer.cornerRadius=10.0f;
    self.viewDown.layer.cornerRadius=10.0f;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.viewFunction.hidden=YES;
    self.viewFunctionHeightConstant.constant=0.0;
    self.tableViewHeightConstant.constant=0.0;
    [self.btnSave setUserInteractionEnabled:NO];
}

-(void)btnHeaderBack:(id)sender {
   
    if (saveInt==0) {
        
        SaveDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SAVE_DIALOGUE"];
        popover.delegate = self;
        popover.strDialogue=@"0";
        popover.modalPresentationStyle = UIModalPresentationCustom;
        [popover setTransitioningDelegate:_customTransitionController];
        [self presentViewController:popover animated:YES completion:nil];
    }
    
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(getBackFromController)])
        {
            [_delegate getBackFromController];
        }

    }
    
}

#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger arrCount;
   
    if (collectionView==self.componentCollectionView) {
        arrCount=[componentArr count];
    }
    else {
        arrCount=[touchPanelArr count];
    }
    
    return arrCount;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.componentCollectionView) {
        
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lblComponentName.text=[[componentArr objectAtIndex:indexPath.row]objectAtIndex:2];
        cell.layer.cornerRadius=5.0f;
        if ([[cellColorArr objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            cell.backgroundColor=cellComponentColor;
        }
        else {
            cell.backgroundColor=selectedComponentColor;
        }
    }
    else if (collectionView==self.touchPanelCollectionView) {
        
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        cell.viewOne.layer.cornerRadius=5.0f;
        cell.viewTwo.layer.cornerRadius=5.0f;
        cell.viewThree.layer.cornerRadius=5.0f;
        cell.viewFour.layer.cornerRadius=5.0f;
        cell.viewFive.layer.cornerRadius=5.0f;
        cell.viewSix.layer.cornerRadius=5.0f;
        cell.viewSeven.layer.cornerRadius=5.0f;
        cell.viewEight.layer.cornerRadius=5.0f;
        cell.lblTouchPanelName.text=[NSString stringWithFormat:@"Touch Panel %@",[[touchPanelArr objectAtIndex:indexPath.row] objectAtIndex:2]];
        
        [cell.btnPos1 setTag:indexPath.row];
        [cell.btnPos2 setTag:indexPath.row];
        [cell.btnPos3 setTag:indexPath.row];
        [cell.btnPos4 setTag:indexPath.row];
        [cell.btnPos5 setTag:indexPath.row];
        [cell.btnPos6 setTag:indexPath.row];
        [cell.btnPos7 setTag:indexPath.row];
        [cell.btnPos8 setTag:indexPath.row];
        
        [cell.btnPos1 addTarget:self
                         action:@selector(btnPos1:) forControlEvents:UIControlEventTouchDown];
        [cell.btnPos2 addTarget:self
                         action:@selector(btnPos2:) forControlEvents:UIControlEventTouchDown];
        [cell.btnPos3 addTarget:self
                         action:@selector(btnPos3:) forControlEvents:UIControlEventTouchDown];
        [cell.btnPos4 addTarget:self
                         action:@selector(btnPos4:) forControlEvents:UIControlEventTouchDown];
        [cell.btnPos5 addTarget:self
                         action:@selector(btnPos5:) forControlEvents:UIControlEventTouchDown];
        [cell.btnPos6 addTarget:self
                         action:@selector(btnPos6:) forControlEvents:UIControlEventTouchDown];
        [cell.btnPos7 addTarget:self
                         action:@selector(btnPos7:) forControlEvents:UIControlEventTouchDown];
        [cell.btnPos8 addTarget:self
                         action:@selector(btnPos8:) forControlEvents:UIControlEventTouchDown];
        
        cell.viewOne.backgroundColor=[[touchPanelStatusArr objectAtIndex:indexPath.row]objectForKey:@"1"];
        cell.viewTwo.backgroundColor=[[touchPanelStatusArr objectAtIndex:indexPath.row]objectForKey:@"2"];
        cell.viewThree.backgroundColor=[[touchPanelStatusArr objectAtIndex:indexPath.row]objectForKey:@"3"];
        cell.viewFour.backgroundColor=[[touchPanelStatusArr objectAtIndex:indexPath.row]objectForKey:@"4"];
        cell.viewFive.backgroundColor=[[touchPanelStatusArr objectAtIndex:indexPath.row]objectForKey:@"5"];
        cell.viewSix.backgroundColor=[[touchPanelStatusArr objectAtIndex:indexPath.row]objectForKey:@"6"];
        cell.viewSeven.backgroundColor=[[touchPanelStatusArr objectAtIndex:indexPath.row]objectForKey:@"7"];
        cell.viewEight.backgroundColor=[[touchPanelStatusArr objectAtIndex:indexPath.row]objectForKey:@"8"];
        
    }
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    if (collectionView==self.componentCollectionView) {
        
        CGSize collectionviewSize=self.componentCollectionView.frame.size;
        if (collectionView==self.componentCollectionView) {
            
            side1=collectionviewSize.width/3-15;
            side2=side1-30;
        }
    }
    else if (collectionView==self.touchPanelCollectionView) {
        
        CGSize collectionviewSize=self.touchPanelCollectionView.frame.size;
        if (collectionView==self.touchPanelCollectionView) {
            
            side1=collectionviewSize.width-15;
            // side2=collectionviewSize.height-20;
            side2=207;
        }
    }
    return CGSizeMake(side1, side2);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    if (collectionView == self.componentCollectionView) {
        
        if (saveInt==0) {
            SaveDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SAVE_DIALOGUE"];
            popover.delegate = self;
            popover.strDialogue=@"1";
            popover.modalPresentationStyle = UIModalPresentationCustom;
            [popover setTransitioningDelegate:_customTransitionController];
            [self presentViewController:popover animated:YES completion:nil];
        }
//        else {
        component_number=[[componentArr objectAtIndex:indexPath.row]objectAtIndex:5];
        [positionArr removeAllObjects];
        
        [self changeSelectedComponentCellColour:indexPath.row];
        
        component_id=[[componentArr objectAtIndex:indexPath.row]objectAtIndex:0];
        
        switchCount=0;
        [onArr removeAllObjects];
        [upArr removeAllObjects];
        [downArr removeAllObjects];
        [positionArr removeAllObjects];
        NSString *selectQuery = [NSString stringWithFormat:@"select * from TouchPanel where machine_id=%ld",[machine_id integerValue]];
        
        touchPanelArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:3];
        if ([touchPanelArr count]>0) {
            [self.viewTouchPanel setHidden:YES];
        }
        else {
            [self.viewTouchPanel setHidden:NO];
        }
            [touchPanelColourDict removeAllObjects];
            [touchPanelColorArr removeAllObjects];
            [touchPanelStatusDict removeAllObjects];
            [touchPanelStatusArr removeAllObjects];
            [dataArr removeAllObjects];
            for (int i=0; i<8; i++) {
                [touchPanelColourDict setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i+1]];
                [touchPanelStatusDict setObject:cellColor forKey:[NSString stringWithFormat:@"%d",i+1]];
            }
            for (int i=0; i<[touchPanelArr count]; i++) {
                
                [touchPanelColorArr addObject:touchPanelColourDict];
                [touchPanelStatusArr addObject:touchPanelStatusDict];
            }
            [self.touchPanelCollectionView setHidden:NO];
            [self.touchPanelCollectionView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud show:YES];
           
            hud.detailsLabelText = @"Please Wait";
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([component_type isEqualToString:@"switch"]) {
               
                 c_num=[component_number substringWithRange:NSMakeRange(2, 2)];
                 [self fetchPayloadForComponentNumber:[component_number substringWithRange:NSMakeRange(2, 2)]];
            }
            
            else{
               
                NSString *selectSwitch = [NSString stringWithFormat:@"select count(*) from Components where  component_type='%@' AND machine_id=%ld",@"switch",[machine_id integerValue]];
                swCount = [[self.dbHandler MathOperationInTable:selectSwitch] integerValue];
                
                NSInteger cnum=[[component_number substringWithRange:NSMakeRange(2, 2)] integerValue];
                c_num=[NSString stringWithFormat:@"%.2ld",cnum+swCount];
                
                NSLog(@"DIMMER NUMBER-------%@",c_num);
                [self fetchPayloadForComponentNumber:c_num];
                
            }
            
        });
        //}
    //collectionView condition completed
    }
  
    
    
}


#pragma - mark UICollectionView UIButton IBAction

- (IBAction)btnPos1:(UIButton *)sender {
    NSLog(@"------>>%@",functionType);
    saveInt=0;
    [self.btnSave setUserInteractionEnabled:YES];
    [self changetouchPanelColourForSwitch:sender.tag forPosition:1 forComponentType:component_type];
}

- (IBAction)btnPos2:(UIButton *)sender {
    
    saveInt=0;
    [self.btnSave setUserInteractionEnabled:YES];
    [self changetouchPanelColourForSwitch:sender.tag forPosition:2 forComponentType:component_type];
}

- (IBAction)btnPos3:(UIButton *)sender {
    
    saveInt=0;
    [self.btnSave setUserInteractionEnabled:YES];
    [self changetouchPanelColourForSwitch:sender.tag forPosition:3 forComponentType:component_type];
}

- (IBAction)btnPos4:(UIButton *)sender {
    
    saveInt=0;
    [self.btnSave setUserInteractionEnabled:YES];
    [self changetouchPanelColourForSwitch:sender.tag forPosition:4 forComponentType:component_type];
}

- (IBAction)btnPos5:(UIButton *)sender {
    
    saveInt=0;
    [self.btnSave setUserInteractionEnabled:YES];
    [self changetouchPanelColourForSwitch:sender.tag forPosition:5 forComponentType:component_type];
}

- (IBAction)btnPos6:(UIButton *)sender {
    
    saveInt=0;
    [self.btnSave setUserInteractionEnabled:YES];
    [self changetouchPanelColourForSwitch:sender.tag forPosition:6 forComponentType:component_type];
}

- (IBAction)btnPos7:(UIButton *)sender {
    
    saveInt=0;
    [self.btnSave setUserInteractionEnabled:YES];
    [self changetouchPanelColourForSwitch:sender.tag forPosition:7 forComponentType:component_type];
}

- (IBAction)btnPos8:(UIButton *)sender {
    
    saveInt=0;
    [self.btnSave setUserInteractionEnabled:YES];
    [self changetouchPanelColourForSwitch:sender.tag forPosition:8 forComponentType:component_type];
}

#pragma - mark UIButton IBAction

- (IBAction)btnComponent:(id)sender {
   
    if ([sender tag]==0) {
        
        [self.viewTouchPanel setHidden:NO];
        self.viewFunction.hidden=YES;
        self.viewFunctionHeightConstant.constant=0.0;
        [self fetchAllComponents:@"switch"];
        component_type=@"switch";
        selectedColor=[UIColor colorWithRed:(84/255.0) green:(109/255.0) blue:(126/255.0) alpha:1.0f];
        [self.touchPanelCollectionView setHidden:YES];
    }
    else if ([sender tag]==1) {
       
        [self.btnOn setTextColor:[UIColor whiteColor]];
        [self.btnUp setTextColor:[UIColor grayColor]];
        [self.btnDown setTextColor:[UIColor grayColor]];
        
        [self.viewTouchPanel setHidden:NO];
        self.viewFunction.hidden=NO;
        self.viewFunctionHeightConstant.constant=60.0;
        [self fetchAllComponents:@"dimmer"];
        component_type=@"dimmer";
        functionType=@"on";
        selectedColor=onColor;
        [self.touchPanelCollectionView setHidden:YES];
    }
}

- (IBAction)btnSelectionFunctionType:(id)sender {
    if ([sender tag]==0) {
        functionType=@"on";
        selectedColor=onColor;
        [self.btnOn setTextColor:[UIColor whiteColor]];
        [self.btnUp setTextColor:[UIColor grayColor]];
        [self.btnDown setTextColor:[UIColor grayColor]];
        [self boldFontForLabel:self.btnOn forSize:13];
        [self boldFontForLabel:self.btnUp forSize:10];
        [self boldFontForLabel:self.btnDown forSize:10];
        NSLog(@"ON");
    }
    else if ([sender tag]==1) {
        functionType=@"up";
        selectedColor=upColour;
        [self.btnOn setTextColor:[UIColor grayColor]];
        [self.btnUp setTextColor:[UIColor whiteColor]];
        [self.btnDown setTextColor:[UIColor grayColor]];
        [self boldFontForLabel:self.btnOn forSize:10];
        [self boldFontForLabel:self.btnUp forSize:13];
        [self boldFontForLabel:self.btnDown forSize:10];
        NSLog(@"UP");
    }
    else if ([sender tag]==2) {
        functionType=@"down";
        selectedColor=downColor;
        [self.btnOn setTextColor:[UIColor grayColor]];
        [self.btnUp setTextColor:[UIColor grayColor]];
        [self.btnDown setTextColor:[UIColor whiteColor]];
        [self boldFontForLabel:self.btnOn forSize:10];
        [self boldFontForLabel:self.btnUp forSize:10];
        [self boldFontForLabel:self.btnDown forSize:13];

        NSLog(@"DOWN%@",downColor);
        
    }
}

- (IBAction)btnSave:(id)sender {

    networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus != ReachableViaWiFi) {
        
        [self.view makeToast:@"You aren't connected to Wi-Fi"];
    }
    else{
            
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [hud show:YES];
                
        });
            
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            [self saveTouchPanelDataToDatabase];
        
        });
        
    }

}


-(void)saveTouchPanelDataToDatabase {
    
    if ([component_type isEqualToString:@"switch"]) {
         NSLog(@"PAYLOAD------>>%@",positionArr);
        
        NSInteger counter=[positionArr count];
        for (int i=0; i<6-counter; i++) {
            [positionArr addObject:@"0000"];
        }
        
        [positionDict setObject:[positionArr objectAtIndex:0] forKey:@"pos1"];
        [positionDict setObject:[positionArr objectAtIndex:1] forKey:@"pos2"];
        [positionDict setObject:[positionArr objectAtIndex:2] forKey:@"pos3"];
        [positionDict setObject:[positionArr objectAtIndex:3] forKey:@"pos4"];
        [positionDict setObject:[positionArr objectAtIndex:4] forKey:@"pos5"];
        [positionDict setObject:[positionArr objectAtIndex:5] forKey:@"pos6"];
      
        strPayload=[NSString stringWithFormat:@"%@%@%@%@%@%@",[positionDict objectForKey:@"pos1"],[positionDict objectForKey:@"pos2"],[positionDict objectForKey:@"pos3"],[positionDict objectForKey:@"pos4"],[positionDict objectForKey:@"pos5"],[positionDict objectForKey:@"pos6"]];
        
       
        c_num=[component_number substringWithRange:NSMakeRange(2, 2)];
        
        NSString *hitURL=[NSString stringWithFormat:@"http://%@/ctchcon.cgi?TSW=%@%@",machine_ip,c_num,strPayload];
        
         //NSString *hitURL=[NSString stringWithFormat:@"http://192.168.1.221/ctchcon.cgi?TSW=%@%@",component_number,strPayload];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:hitURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if ([data length] > 0 && error == nil) {
                                          NSString *deleteQuery =[NSString stringWithFormat:@"delete from TouchPanel_Component where touchpanel_id=%ld AND component_id=%ld",[machine_id integerValue],[component_id integerValue]];
                                          [self.dbHandler DeleteDataWithQuesy:deleteQuery];
                                          
                                                  NSString *insertQuery = [NSString stringWithFormat:@"insert into TouchPanel_Component (touchpanel_id,Pos_1,Pos_2,Pos_3,Pos_4,Pos_5,Pos_6,component_id,component_name,payload) values (%ld,'%@','%@','%@','%@','%@','%@',%ld,'%@','%@')",[machine_id integerValue],[positionDict objectForKey:@"pos1"],[positionDict objectForKey:@"pos2"],[positionDict objectForKey:@"pos3"],[positionDict objectForKey:@"pos4"],[positionDict objectForKey:@"pos5"],[positionDict objectForKey:@"pos6"],[component_id integerValue],[component_number substringWithRange:NSMakeRange(2, 2)],strPayload];
                                          
                                                  [self.dbHandler insertDataWithQuesy:insertQuery];
                                          
                                          dispatch_async(dispatch_get_main_queue()
                                                         , ^{
                                                             [self.view makeToast:@"Component is successfully assigned."];
                                                             saveInt=1;
                                                             [self.btnSave setUserInteractionEnabled:NO];
                                                         });
                                          dispatch_async(dispatch_get_main_queue()
                                                         , ^{
                                                             [hud hide:YES];
                                                             
                                                         });
                                          saveInt=1;
                                         
                                          [self.btnSave setUserInteractionEnabled:NO];
                                      }
                                      else if ([data length] == 0 || error == nil){
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              TryAgainDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TRY_AGAIN_DIALOGUE"];
                                              popover.delegate = self;
                                              popover.strDialogue=@"0";
                                              popover.modalPresentationStyle = UIModalPresentationCustom;
                                              [popover setTransitioningDelegate:_customTransitionController];
                                              [self presentViewController:popover animated:YES completion:nil];                                          dispatch_async(dispatch_get_main_queue()
                                                         , ^{
                                                             [hud hide:YES];
                                                             
                                                         });
                                              });
                                      }
                                      
                                      else if (error != nil){
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              TryAgainDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TRY_AGAIN_DIALOGUE"];
                                              popover.delegate = self;
                                              popover.strDialogue=@"0";
                                              popover.modalPresentationStyle = UIModalPresentationCustom;
                                              [popover setTransitioningDelegate:_customTransitionController];
                                              [self presentViewController:popover animated:YES completion:nil];                                                 dispatch_async(dispatch_get_main_queue()
                                                             , ^{
                                                                 [hud hide:YES];
                                                                 
                                                             });
                                          });
                                      }
                                  }];
        
        [task resume];

    }
    
    else if ([component_type isEqualToString:@"dimmer"]) {
        
        NSInteger counter1=[onArr count];
        for (int i=0; i<2-counter1; i++) {
            [onArr addObject:@"0000"];
        }
        NSInteger counter2=[upArr count];
        for (int i=0; i<2-counter2; i++) {
            [upArr addObject:@"0000"];
        }
        NSInteger counter3=[downArr count];
        for (int i=0; i<2-counter3; i++) {
            [downArr addObject:@"0000"];
        }
        NSString *selectSwitch = [NSString stringWithFormat:@"select count(*) from Components where  component_type='%@' AND machine_id=%ld",@"switch",[machine_id integerValue]];
        swCount = [[self.dbHandler MathOperationInTable:selectSwitch] integerValue];
        
        NSLog(@"SW-------%ld    Component_number-------%@",swCount,component_number);
        NSInteger cnum=[[component_number substringWithRange:NSMakeRange(2, 2)] integerValue];
        c_num=[NSString stringWithFormat:@"%ld",cnum+swCount];
        
        [positionDict setObject:[onArr objectAtIndex:0] forKey:@"pos1"];
        [positionDict setObject:[upArr objectAtIndex:0] forKey:@"pos2"];
        [positionDict setObject:[downArr objectAtIndex:0] forKey:@"pos3"];
        [positionDict setObject:[onArr objectAtIndex:1] forKey:@"pos4"];
        [positionDict setObject:[upArr objectAtIndex:1] forKey:@"pos5"];
        [positionDict setObject:[downArr objectAtIndex:1] forKey:@"pos6"];
        
       strPayload=[NSString stringWithFormat:@"%@%@%@%@%@%@",[positionDict objectForKey:@"pos1"],[positionDict objectForKey:@"pos2"],[positionDict objectForKey:@"pos3"],[positionDict objectForKey:@"pos4"],[positionDict objectForKey:@"pos5"],[positionDict objectForKey:@"pos6"]];
        
        NSString *hitURL=[NSString stringWithFormat:@"http://%@/ctchcon.cgi?TSW=%@%@",machine_ip,c_num,strPayload];
        //NSString *hitURL=[NSString stringWithFormat:@"http://192.168.1.221/ctchcon.cgi?TSW=%@%@",component_number,strPayload];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:hitURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if ([data length] > 0 && error == nil) {
                                          NSString *deleteQuery =[NSString stringWithFormat:@"delete from TouchPanel_Component where touchpanel_id=%ld AND component_id=%ld",[machine_id integerValue],[component_id integerValue]];
                                          [self.dbHandler DeleteDataWithQuesy:deleteQuery];
                                          
                                          NSString *insertQuery = [NSString stringWithFormat:@"insert into TouchPanel_Component (touchpanel_id,Pos_1,Pos_2,Pos_3,Pos_4,Pos_5,Pos_6,component_id,component_name,payload) values (%ld,'%@','%@','%@','%@','%@','%@',%ld,'%@','%@')",[machine_id integerValue],[positionDict objectForKey:@"pos1"],[positionDict objectForKey:@"pos2"],[positionDict objectForKey:@"pos3"],[positionDict objectForKey:@"pos4"],[positionDict objectForKey:@"pos5"],[positionDict objectForKey:@"pos6"],[component_id integerValue],component_number,strPayload];
                                          
                                          [self.dbHandler insertDataWithQuesy:insertQuery];
                                          dispatch_async(dispatch_get_main_queue()
                                                         , ^{
                                                             [self.view makeToast:@"Component is successfully assigned."];
                                                             saveInt=1;
                                                             [self.btnSave setUserInteractionEnabled:NO];
                                                         });

                                          dispatch_async(dispatch_get_main_queue()
                                                         , ^{
                                                             [hud hide:YES];
                                                             
                                                         });
                                        
                                      }
                                      else if ([data length] == 0 || error == nil){
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              TryAgainDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TRY_AGAIN_DIALOGUE"];
                                              popover.delegate = self;
                                              popover.strDialogue=@"0";
                                              popover.modalPresentationStyle = UIModalPresentationCustom;
                                              [popover setTransitioningDelegate:_customTransitionController];
                                              [self presentViewController:popover animated:YES completion:nil];
                                              dispatch_async(dispatch_get_main_queue()
                                                             , ^{
                                                                 [hud hide:YES];
                                                                 
                                                             });
                                          });
                                      }
                                      
                                      else if (error != nil){
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              TryAgainDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TRY_AGAIN_DIALOGUE"];
                                              popover.delegate = self;
                                              popover.strDialogue=@"0";
                                              popover.modalPresentationStyle = UIModalPresentationCustom;
                                              [popover setTransitioningDelegate:_customTransitionController];
                                              [self presentViewController:popover animated:YES completion:nil];
                                              dispatch_async(dispatch_get_main_queue()
                                                             , ^{
                                                                 [hud hide:YES];
                                                                 
                                                             });
                                          });
                                      }
                                  }];
        
        [task resume];
        

        
    }
}

#pragma  - mark Database operation

-(void)fetchAllComponents:(NSString *)componentType {
    
    NSString *selectQuery = [NSString stringWithFormat:@"select c.* , m.machine_name, m.machine_ip, m.worldwide_ip, m.isActive,m.isWWIPActive from Components As c JOIN MachineConfig As m where c.machine_id = m.machine_id AND c.component_type='%@' AND m.machine_id=%ld",componentType,[machine_id integerValue]];
    NSLog(@"----->>%@",selectQuery);
    componentArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];
    [cellColorArr removeAllObjects];
    
    for (int i=0; i<[componentArr count]; i++) {
        
        [cellColorArr addObject:@"0"];
    }
    
   [self.componentCollectionView reloadData];
    
}

-(void) changeSelectedComponentCellColour :(NSInteger)objIndex1 {
    
    for (int i=0; i<[cellColorArr count]; i++) {
        if (i==objIndex1) {
            [cellColorArr replaceObjectAtIndex:i withObject:@"1"];
        }
        else {
            [cellColorArr replaceObjectAtIndex:i withObject:@"0"];
        }
    }
    [self.componentCollectionView reloadData];
    
}

-(void) changetouchPanelColourForSwitch:(NSInteger)objIndex forPosition:(NSInteger)position forComponentType:(NSString *)componentType
{
    
    if ([componentType isEqualToString:@"switch"]) {
        NSString *value;
        UIColor *myColour;
        if ([[[touchPanelColorArr objectAtIndex:objIndex]objectForKey:[NSString stringWithFormat:@"%ld",position]] isEqualToString:@"0"]) {
            value=@"1";
            switchCount+=1;
            myColour=selectedComponentColor;
            [positionArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
        }
        else {
            value=@"0";
            myColour=cellComponentColor;

            for (int i=0; i<[positionArr count]; i++) {
                if ([[positionArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                    [positionArr removeObjectAtIndex:i];
                    switchCount-=1;
                    
                }
            }
        }
        if (switchCount>6) {
            switchCount-=1;
            [self.view makeToast:@"You can't assign component to more than 6 places."];
        }
        else {
            
            NSMutableDictionary *dictC1=[[NSMutableDictionary alloc]init];
            NSMutableDictionary *dictC2=[[NSMutableDictionary alloc]init];
            NSMutableDictionary *dictS1=[[NSMutableDictionary alloc]init];
            NSMutableDictionary *dictS2=[[NSMutableDictionary alloc]init];
            
            dictC1=[touchPanelColorArr objectAtIndex:objIndex];
            dictS1=[touchPanelStatusArr objectAtIndex:objIndex];
            
            for (int i=0; i<8; i++) {
                if (i==position-1) {
                    [dictC2 setObject:value forKey:[NSString stringWithFormat:@"%d",i+1]];
                    [dictS2 setObject:myColour forKey:[NSString stringWithFormat:@"%d",i+1]];
                }
                else {
                    [dictC2 setObject:[dictC1 objectForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:[NSString stringWithFormat:@"%d",i+1]];
                    [dictS2 setObject:[dictS1 objectForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:[NSString stringWithFormat:@"%d",i+1]];
                }
            }
            
            [touchPanelColorArr replaceObjectAtIndex:objIndex withObject:dictC2];
            [touchPanelStatusArr replaceObjectAtIndex:objIndex withObject:dictS2];
            
            [self.touchPanelCollectionView reloadData];
        }
        [self hideHud];
    }
    
    //---------------- FOR DIMMERS --------------
    
    else if ([componentType isEqualToString:@"dimmer"]) {
        
        
        NSString *value;
        UIColor *myColour;
        if ([[[touchPanelColorArr objectAtIndex:objIndex]objectForKey:[NSString stringWithFormat:@"%ld",position]]                                        isEqualToString:@"0"]) {
            
            if ([functionType isEqualToString:@"on"]) {
                if ([onArr count]>=2) {
                    [self.view makeToast:@"You can't assign component to more than 2 places."];

                }
                else {
                  
                    value=@"1";
                    myColour=selectedColor;
                    [onArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
                    
                    for (int i=0; i<[upArr count];i++) {
                        if ([[upArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                            
                            [upArr removeObjectAtIndex:i];
                        }
                    }
                    for (int i=0; i<[downArr count];i++) {
                        if ([[downArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                            
                            [downArr removeObjectAtIndex:i];
                        }
                    }
                    [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
               
                }
            }
            else if ([functionType isEqualToString:@"up"]) {
                if ([upArr count]>=2) {
                    [self.view makeToast:@"You can't assign component to more than 2 places."];
                }
                else {
                   
                    value=@"2";
                    myColour=selectedColor;
                    
                    [upArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
                    for (int i=0; i<[onArr count];i++) {
                        if ([[onArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                            
                            [onArr removeObjectAtIndex:i];
                        }
                    }
                    for (int i=0; i<[downArr count];i++) {
                        if ([[downArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                            
                            [downArr removeObjectAtIndex:i];
                        }
                    }

                      [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
                }
            }
            
            else  if ([functionType isEqualToString:@"down"]) {
                
                if ([downArr count]>=2) {
                    [self.view makeToast:@"You can't assign component to more than 2 places."];
                }
                
                else {
                    
                    value=@"3";
                    myColour=selectedColor;
                    [downArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
                    for (int i=0; i<[onArr count];i++) {
                        if ([[onArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                            
                            [onArr removeObjectAtIndex:i];
                        }
                    }
                    for (int i=0; i<[upArr count];i++) {
                        if ([[upArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                            
                            [upArr removeObjectAtIndex:i];
                        }
                    }
                    [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
                }
        }
            
        //if value is 0 condition
        }
        
        else if ([[[touchPanelColorArr objectAtIndex:objIndex]objectForKey:[NSString stringWithFormat:@"%ld",position]]                                        isEqualToString:@"1"]) {
            
            if ([functionType isEqualToString:@"on"]) {
                value=@"0";
                myColour=cellColor;
               
                for (int i=0; i<[onArr count];i++) {
                    if ([[onArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                        [onArr removeObjectAtIndex:i];
                    }
                }
                [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
            }
            else {
                
                if ([functionType isEqualToString:@"up"]) {
                    if ([upArr count]>=2) {
                        [self.view makeToast:@"You can't assign component to more than 2 places."];
                    }
                    else {
                        value=@"2";
                        myColour=selectedColor;
                        for (int i=0; i<[onArr count];i++) {
                            if ([[onArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                                [onArr removeObjectAtIndex:i];
                            }
                        }
                        [upArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
                        [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
                    }
                }
               else if ([functionType isEqualToString:@"down"]) {
                    if ([downArr count]>=2) {
                        [self.view makeToast:@"You can't assign component to more than 2 places."];
                    }
                    else {
                        value=@"3";
                        myColour=selectedColor;
                        for (int i=0; i<[onArr count];i++) {
                            if ([[onArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                                [onArr removeObjectAtIndex:i];
                            }
                        }
                        [downArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
                        [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
                    }
                }

            }
            
        //if value is 1 condition
        }
        
        else if ([[[touchPanelColorArr objectAtIndex:objIndex]objectForKey:[NSString stringWithFormat:@"%ld",position]]                                        isEqualToString:@"2"]) {
            
            if ([functionType isEqualToString:@"up"]) {
                value=@"0";
                myColour=cellColor;
                
                for (int i=0; i<[upArr count];i++) {
                    if ([[upArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                        [upArr removeObjectAtIndex:i];
                    }
                }
                [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
            }
            
            else {
                
                if ([functionType isEqualToString:@"on"]) {
                    if ([onArr count]>=2) {
                        [self.view makeToast:@"You can't assign component to more than 2 places."];
                    }
                    else {
                        value=@"1";
                        myColour=selectedColor;
                        for (int i=0; i<[upArr count];i++) {
                            if ([[upArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                                [upArr removeObjectAtIndex:i];
                            }
                        }
                        [onArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
                        [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
                    }
                }
                else if ([functionType isEqualToString:@"down"]) {
                    if ([downArr count]>=2) {
                        [self.view makeToast:@"You can't assign component to more than 2 places."];
                    }
                    else {
                        value=@"3";
                        myColour=selectedColor;
                        for (int i=0; i<[upArr count];i++) {
                            if ([[upArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                                [upArr removeObjectAtIndex:i];
                            }
                        }
                        [downArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
                        [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
                    }
                }
                
            }
        //if value is 2 condition
        }
        else if ([[[touchPanelColorArr objectAtIndex:objIndex]objectForKey:[NSString stringWithFormat:@"%ld",position]]                                        isEqualToString:@"3"]) {
            
            if ([functionType isEqualToString:@"down"]) {
                value=@"0";
                myColour=cellColor;
                
                for (int i=0; i<[downArr count];i++) {
                    if ([[downArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                        [downArr removeObjectAtIndex:i];
                    }
                }
                [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
                
            }
            
            else {
                
                if ([functionType isEqualToString:@"on"]) {
                    if ([onArr count]>=2) {
                        [self.view makeToast:@"You can't assign component to more than 2 places."];
                    }
                    else {
                        value=@"2";
                        myColour=selectedColor;
                        for (int i=0; i<[downArr count];i++) {
                            if ([[downArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                                [downArr removeObjectAtIndex:i];
                            }
                        }
                        [onArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
                        [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
                    }
                }
                else if ([functionType isEqualToString:@"up"]) {
                    if ([upArr count]>=2) {
                        [self.view makeToast:@"You can't assign component to more than 2 places."];
                    }
                    else {
                        value=@"3";
                        myColour=selectedColor;
                        for (int i=0; i<[downArr count];i++) {
                            if ([[downArr objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]]) {
                                [downArr removeObjectAtIndex:i];
                            }
                        }
                        [upArr addObject:[NSString stringWithFormat:@"%@%.2ld",[[touchPanelArr objectAtIndex:objIndex] objectAtIndex:2],position]];
                        [self setValuesToArrayAndDictionary:value ForColour:myColour AtIndex:objIndex ForPosition:position];
                    }
                }
                
            }
        //if value is 3 condition
        }
        
        
    //dimmer condition
    }
    
}

-(void) setValuesToArrayAndDictionary:(NSString *)value ForColour: (UIColor *)myColour AtIndex:(NSInteger)objIndex ForPosition:(NSInteger)position{
   
    NSMutableDictionary *dictC1=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dictC2=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dictS1=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dictS2=[[NSMutableDictionary alloc]init];
    
    dictC1=[touchPanelColorArr objectAtIndex:objIndex];
    dictS1=[touchPanelStatusArr objectAtIndex:objIndex];
    
    for (int i=0; i<8; i++) {
        if (i==position-1) {
            [dictC2 setObject:value forKey:[NSString stringWithFormat:@"%d",i+1]];
            [dictS2 setObject:myColour forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        else {
            
            [dictC2 setObject:[dictC1 objectForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:[NSString stringWithFormat:@"%d",i+1]];
            [dictS2 setObject:[dictS1 objectForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    
    [touchPanelColorArr replaceObjectAtIndex:objIndex withObject:dictC2];
    [touchPanelStatusArr replaceObjectAtIndex:objIndex withObject:dictS2];
    
    
    [self.touchPanelCollectionView reloadData];
    
    [self hideHud];
}
- (IBAction)btnEditMachine:(id)sender {
    
    [self fetchMachineDataFromDatabase];
}


#pragma mark - Machine status related method

-(void)fetchMachineDataFromDatabase{
    
    NSString *selectQuery = [NSString stringWithFormat:@"select *from MachineConfig where isActive=1"];
    
    machineArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];
   
    if ([machineArr count]==1) {
        
        machine_id=[[machineArr objectAtIndex:0]objectAtIndex:0];
        [self fetchAllComponents:@"switch"];
        [self.lblHeader setText:[[machineArr objectAtIndex:0]objectAtIndex:1]];
        if ([[[machineArr objectAtIndex:0]objectAtIndex:10] isEqualToString:@"0"]) {
            machine_ip=[[machineArr objectAtIndex:0]objectAtIndex:2];
        }
        else {
            machine_ip=[[machineArr objectAtIndex:0 ]objectAtIndex:3];
            
        }
        [self.btnEdit setHidden:YES];
    }
    
    else {
        [self.btnEdit setHidden:NO];
        [self.tableView reloadData];
        self.tableViewHeightConstant.constant=[machineArr count]*39;
    }
}

#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [machineArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    tCell=(TouchPanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];

    [tCell.lblMachineName setText:[NSString stringWithFormat:@"   %@",[[machineArr objectAtIndex:indexPath.row]objectAtIndex:1]]];
    
    return tCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    self.tableViewHeightConstant.constant=0.0f;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    machine_id=[[machineArr objectAtIndex:indexPath.row]objectAtIndex:0];
    
    if ([[[machineArr objectAtIndex:indexPath.row]objectAtIndex:10] isEqualToString:@"0"]) {
        machine_ip=[[machineArr objectAtIndex:indexPath.row]objectAtIndex:2];
    }
    
    else {
        machine_ip=[[machineArr objectAtIndex:indexPath.row]objectAtIndex:3];
       
    }
    
    [self.lblHeader setText:[[machineArr objectAtIndex:indexPath.row]objectAtIndex:1]];
    [self fetchAllComponents:@"switch"];
    
}

#pragma - mark UIAlertView Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if(buttonIndex == 1)
        {
            [self saveTouchPanelDataToDatabase];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            saveInt=1;
        }
        else if(buttonIndex == 1)
        {
            [self saveTouchPanelDataToDatabase];
        }
    }
    
    else if(alertView.tag == 3)
    {
        if(buttonIndex == 0)
        {
        
        }
        else if(buttonIndex == 1)
        {
           
            networkStatus = [reachability currentReachabilityStatus];
            if (networkStatus != ReachableViaWiFi) {
                [self.view makeToast:@"You aren't connected to Wi-Fi"];
            }
            else{
               
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud show:YES];
                    
                });
                
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    [self callURLAgain];
                });
                
            }

         

        }
    }
}

-(void)callURLAgain {

    NSString *hitURL=[NSString stringWithFormat:@"http://%@/ctchcon.cgi?TSW=%@%@",machine_ip,c_num,strPayload];
    
   // NSString *hitURL=[NSString stringWithFormat:@"http://192.168.1.221/ctchcon.cgi?TSW=%@%@",component_number,strPayload];
    NSLog(@"URL--------%@",hitURL);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:hitURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
                                  if ([data length] > 0 && error == nil) {
                                      NSString *deleteQuery =[NSString stringWithFormat:@"delete from TouchPanel_Component where touchpanel_id=%ld AND component_id=%ld",[machine_id integerValue],[component_id integerValue]];
                                      [self.dbHandler DeleteDataWithQuesy:deleteQuery];
                                      
                                      NSString *insertQuery = [NSString stringWithFormat:@"insert into TouchPanel_Component (touchpanel_id,Pos_1,Pos_2,Pos_3,Pos_4,Pos_5,Pos_6,component_id,component_name,payload) values (%ld,'%@','%@','%@','%@','%@','%@',%ld,'%@','%@')",[machine_id integerValue],[positionDict objectForKey:@"pos1"],[positionDict objectForKey:@"pos2"],[positionDict objectForKey:@"pos3"],[positionDict objectForKey:@"pos4"],[positionDict objectForKey:@"pos5"],[positionDict objectForKey:@"pos6"],[component_id integerValue],[component_number substringWithRange:NSMakeRange(2, 2)],strPayload];
                                      
                                      [self.dbHandler insertDataWithQuesy:insertQuery];
                                      dispatch_async(dispatch_get_main_queue()
                                                     , ^{
                                                         [hud hide:YES];
                                                         
                                                     });
                                      saveInt=1;
                                      
                                      [self.btnSave setUserInteractionEnabled:NO];
                                  }
                                  else if ([data length] == 0 || error == nil){
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          TryAgainDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TRY_AGAIN_DIALOGUE"];
                                          popover.delegate = self;
                                          popover.strDialogue=@"0";
                                          popover.modalPresentationStyle = UIModalPresentationCustom;
                                          [popover setTransitioningDelegate:_customTransitionController];
                                          [self presentViewController:popover animated:YES completion:nil];                                           dispatch_async(dispatch_get_main_queue()
                                                         , ^{
                                                             [hud hide:YES];
                                                             
                                                         });
                                      });                                  }
                                  
                                  else if (error != nil){
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          TryAgainDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TRY_AGAIN_DIALOGUE"];
                                          popover.delegate = self;
                                          popover.strDialogue=@"0";
                                          popover.modalPresentationStyle = UIModalPresentationCustom;
                                          [popover setTransitioningDelegate:_customTransitionController];
                                          [self presentViewController:popover animated:YES completion:nil];
                                          dispatch_async(dispatch_get_main_queue()
                                                         , ^{
                                                             [hud hide:YES];
                                                             
                                                         });
                                      });                                  }
                              }];
    
    [task resume];
}

-(void)fetchPayloadForComponentNumber :(NSString *)componentNo {
    
    NSLog(@"NO-->>-------%@",componentNo);
    NSString *hitURL=[NSString stringWithFormat:@"http://%@/tchcon.xml",machine_ip];
   
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:hitURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
                                  if ([data length] > 0 && error == nil) {
                                      
                                      NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
                                      [xmlParser setDelegate:(id)self];
                                      [xmlParser parse];
                                     
                                      if ([self.xmlData count]>0) {
                                    
                                          NSString *str=[self.xmlData valueForKey:[NSString stringWithFormat:@"TSW%@",componentNo]];
                                          
                                          for (int i=0; i<[str length]-1; i++) {
                                          
                                              if(i%4==0){
                                              
                                                  NSString *ch = [str substringWithRange:NSMakeRange(i, 4)];
                                                  [dataArr addObject:ch];
                                              }
                                          }
                                          
                                        }
                                      NSLog(@"------>--%@",dataArr);
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          if ([component_type isEqualToString:@"switch"]) {
                                              for (int i=0; i<[dataArr count]; i++) {
                                                  if (![[dataArr objectAtIndex:i] isEqualToString:@"0000"]) {
                                                      NSInteger selIndex=[[[dataArr objectAtIndex:i] substringWithRange:NSMakeRange(0,2)] integerValue];
                                                      NSLog(@"Selected Index---------%ld",selIndex);
                                                      NSInteger selPosition=[[[dataArr objectAtIndex:i] substringWithRange:NSMakeRange(2,2)] integerValue];
                                                      if (selIndex-1<[touchPanelArr count] && selIndex-1>=0 && selPosition<=8) {
                                                          [self changetouchPanelColourForSwitch:selIndex-1 forPosition:selPosition forComponentType:@"switch"];
                                                      }
                                                      else {
                                                      
                                                          [self hideHud];
                                                      }
                                                  }
                                                  else {
                                                       [self hideHud];
                                                  }
                                              }
                                              
                                          }
                                          else {
                                              for (int i=0; i<[dataArr count]; i++) {
                                                  if (![[dataArr objectAtIndex:i] isEqualToString:@"0000"]) {
                                                      if (i==0||i==3) {
                                                          NSInteger selIndex=[[[dataArr objectAtIndex:i] substringWithRange:NSMakeRange(0,2)] integerValue];
                                                          NSInteger selPosition=[[[dataArr objectAtIndex:i] substringWithRange:NSMakeRange(2,2)] integerValue];
                                                          functionType=@"on";
                                                          selectedColor=onColor;
                                                          if (selIndex-1<[touchPanelArr count] && selIndex-1>=0 && selPosition<=8) {
                                                              [self changetouchPanelColourForSwitch:selIndex-1 forPosition:selPosition forComponentType:@"dimmer"];
                                                          }
                                                          else {
                                                              
                                                              [self hideHud];
                                                          }

                                                      }
                                                      else if (i==1||i==4) {
                                                          NSInteger selIndex=[[[dataArr objectAtIndex:i] substringWithRange:NSMakeRange(0,2)] integerValue];
                                                          NSInteger selPosition=[[[dataArr objectAtIndex:i] substringWithRange:NSMakeRange(2,2)] integerValue];
                                                          functionType=@"up";
                                                          selectedColor=upColour;
                                                          if (selIndex-1<[touchPanelArr count] && selIndex-1>=0 && selPosition<=8) {
                                                              [self changetouchPanelColourForSwitch:selIndex-1 forPosition:selPosition forComponentType:@"dimmer"];
                                                          }
                                                          else {
                                                              
                                                              [self hideHud];
                                                          }
                                                      }
                                                      else if (i==2||i==5) {
                                                          NSInteger selIndex=[[[dataArr objectAtIndex:i] substringWithRange:NSMakeRange(0,2)] integerValue];
                                                          NSInteger selPosition=[[[dataArr objectAtIndex:i] substringWithRange:NSMakeRange(2,2)] integerValue];
                                                          functionType=@"down";
                                                          selectedColor=downColor;
                                                          if (selIndex-1<[touchPanelArr count] && selIndex-1>=0 && selPosition<=8) {
                                                              [self changetouchPanelColourForSwitch:selIndex-1 forPosition:selPosition forComponentType:@"dimmer"];
                                                          }
                                                          else {
                                                              
                                                              [self hideHud];
                                                          }
                                                      }
                                                  }
                                                  else {
                                                      
                                                      [self hideHud];
                                                  }
                                              }
                                              
                                          }
                                         functionType=@"on";
                                         selectedColor=onColor;
                                         [self boldFontForLabel:self.btnOn forSize:13];
                                         [self boldFontForLabel:self.btnUp forSize:10];
                                         [self boldFontForLabel:self.btnDown forSize:10];
//
                                      });
                                     
                                }
                                  
                                  else if ([data length] == 0 || error == nil){
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                      TryAgainDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TRY_AGAIN_DIALOGUE"];
                                      popover.delegate = self;
                                      popover.strDialogue=@"1";
                                      popover.modalPresentationStyle = UIModalPresentationCustom;
                                      [popover setTransitioningDelegate:_customTransitionController];
                                      [self presentViewController:popover animated:YES completion:nil];
                                  });
                                      [self hideHud];
                                  }
                                  else if ( error != nil){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                      TryAgainDialogueViewController *popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TRY_AGAIN_DIALOGUE"];
                                      popover.delegate = self;
                                      popover.strDialogue=@"1";
                                      popover.modalPresentationStyle = UIModalPresentationCustom;
                                      [popover setTransitioningDelegate:_customTransitionController];
                                      [self presentViewController:popover animated:YES completion:nil];
                                        });
                                      [self hideHud];
                                  }
                                 
    }];
    
    [task resume];
 
}
#pragma - mark  NSXMLParser Delegate methods

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    if ([elementName isEqualToString:@"TCHCON"]) {
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
    if (![elementName isEqualToString:@"TCHCON"]) {
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
                       
                   });
}


#pragma - mark SaveDialogueViewCotrollerDelegate 

-(void)getBackFromController:(NSString *)strData {
    saveInt=1;
    NSLog(@"-----Its %@",strData);
    
    if ([strData isEqualToString:@"yes0"]) {
        
        [self saveTouchPanelDataToDatabase];
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(getBackFromController)])
        {
            [_delegate getBackFromController];
        }
    }
    
    else if ([strData isEqualToString:@"yes1"]) {
        
        [self saveTouchPanelDataToDatabase];
    }
    
    else if([strData isEqualToString:@"no0"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([_delegate respondsToSelector:@selector(getBackFromController)])
        {
            [_delegate getBackFromController];
        }
    }
    }

-(void)getBackFromTryDialogueController:(NSString *)strData {
    NSLog(@"--------%@",strData);
    if ([strData isEqualToString:@"yes0"]){
        networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus != ReachableViaWiFi) {
            [self.view makeToast:@"You aren't connected to Wi-Fi"];
        }
        else{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud show:YES];
                
            });
            
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self callURLAgain];
            });
            
        }
    }
    else if ([strData isEqualToString:@"yes1"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud show:YES];
            
        });
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [self fetchPayloadForComponentNumber:c_num];
        });
    }

}
-(void)boldFontForLabel:(UILabel *)label forSize:(NSInteger)fontSize{
    UIFont *currentFont = label.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@",currentFont.fontName] size:fontSize];
    label.font = newFont;
}

@end