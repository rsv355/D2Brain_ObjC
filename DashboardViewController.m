//
//  DashboardViewController.m
//  D2brain
//
//  Created by webmyne systems on 02/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardCollectionViewCell.h"
#import "CustomAnimationAndTransiotion.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "SceneViewController.h"
#import "SwitchViewController.h"
#import "DimmerViewController.h"
#import "AddSceneViewController.h"
#import "SceneViewController.h"
#import "FavouriteViewController.h"
#import "SchedulerListViewController.h"
#import "TouchPanelViewController.h"
#import "AddMachineViewController.h"
#import "AppConstant.h"

@interface DashboardViewController () <MainViewControllerDelegate, MainSceneViewControllerDelegate, MainAddSceneViewControllerDelegate,DimmerViewControllerDelegate,FavouriteViewControllerDelegate,SchedulerViewControllerDelegate,PanelViewControllerDelegate>
{
    
    DashboardCollectionViewCell *cell;
    Reachability *reachability;
    NetworkStatus networkStatus;
    MBProgressHUD *hud;
    NSInteger switchCounter,motorCounter,dimmerCounter,sensorCounter,totalCount,sceneCount,switches,motors,dimmers,sensors;
    UIColor *colorGreen,*colouBlue,*yellowCol;
    NSArray *colouArr;
    NSMutableArray *iconArr,*counterArr,*nameArr;
    NSMutableArray *machineArray,*identifierArr;
    NSTimer *timer;
    NSInteger activeMachine,totalMachine;
    int count;
    NSMutableDictionary *switchDict, *dimmmerDict;
   // NSMutableDictionary *urlDict;
    NSInteger callStatus;
    NSArray *sceneArr;
    NSMutableArray *urlOnArr,*urlOffArr;
    NSArray *myArr;
}
@property (nonatomic,strong) CustomAnimationAndTransiotion *customTransitionController;
@property(nonatomic) CGPoint startPoint;

@end

@implementation DashboardViewController

@synthesize mstrXMLString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    NSString *deviceName=[[UIDevice currentDevice]name];
    if ([deviceName containsString:@"iPad"]) {
        CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
        [self.view setTransform:transform];
    }
    else
    {
    }
    switchCounter=0;
    motorCounter=0;
    dimmerCounter=0;
    sensorCounter=0;
    sceneCount=0;
    totalCount=switchCounter+motorCounter+dimmerCounter+sensorCounter;
    identifierArr=[[NSMutableArray alloc]initWithObjects:@"SWITCHES",@"MOTORS",@"DIMMERS",@"SENSORS", nil];
    
    yellowCol=[UIColor colorWithRed:(237/255.0) green:(190/255.0) blue:(76/255.0) alpha:1.0];
    colouBlue=[UIColor colorWithRed:(24/255.0) green:(81/255.0) blue:(110/255.0) alpha:1.0];
    colorGreen=[UIColor colorWithRed:(0/255.0) green:(153/255.0) blue:(135/255.0) alpha:0.8];
    [self setButtonDisplay];
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    [self fetchDataCount];
    [self fetchMachineDataFromDatabase];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:MACHINE_BACKGROUND_TIMER target:self selector:@selector(fetchMachineStatus:) userInfo:nil repeats:YES];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"onStatus"];
    
    //-------POWER BUTTON
    callStatus=0;
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    switchDict=[[NSMutableDictionary alloc]init];
    dimmmerDict=[[NSMutableDictionary alloc]init];
    //urlDict=[[NSMutableDictionary alloc]init];
    urlOnArr=[[NSMutableArray alloc]init];
    urlOffArr=[[NSMutableArray alloc]init];
    
    
    [self.viewPowerOff setHidden:YES];
    self.btnPower.tag=0;
    [self.viewBottom setBackgroundColor:[UIColor clearColor]];
    [self fetchSceneData];
}

-(void)setButtonDisplay
{
    self.btnFavouriteContainer.layer.borderWidth=1.5f;
    self.btnAddSceneContainer.layer.borderWidth=1.5f;
    self.btnUpContainer.layer.borderWidth=1.5f;
    self.btnAddSceneContainer.layer.cornerRadius=20.0f;
    self.btnFavouriteContainer.layer.cornerRadius=20.0f;
    self.btnUpContainer.layer.cornerRadius=20.0f;
    self.btnFavouriteContainer.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnAddSceneContainer.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnUpContainer.layer.borderColor=[UIColor colorWithRed:(0/255.0) green:(153/255.0) blue:(135/255.0) alpha:1.0].CGColor;
    [self.btnBottom setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
    [self.btnFavourite setImage:[UIImage imageNamed:@"w_heart13.png"] forState:UIControlStateNormal];
    [self.btnScheduler setImage:[UIImage imageNamed:@"w_add98.png"] forState:UIControlStateNormal];
    
    
    _btnViewWidthConstraints.constant =0;
    [self.btnTouchPanel setAlpha:0.0];
    [self.btnMachine setAlpha:0.0];
    [self.btnCreateScene
     setAlpha:0.0];
    [self.lblTouchPane setAlpha:0.0];
    [self.lblMachine setAlpha:0.0];
    [self.lblCreateScene
     setAlpha:0.0];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==self.collectionView) {
        return totalCount;
    }
    else{
        return [sceneArr count];
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.collectionView) {
        [self setCollectionViewCellBackgroundColour];
        [self setCollectionViewIcons];
        
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        cell.imageComponent.image = [cell.imageComponent.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.imageComponent.tintColor=[UIColor whiteColor];
        cell.imageComponent.image=[UIImage imageNamed:[iconArr objectAtIndex:indexPath.row]];
        cell.imageContainerView.layer.cornerRadius=20.0f;
        cell.imageContainerView.layer.borderWidth=0.8f;
        cell.imageContainerView.layer.borderColor=[UIColor colorWithRed:(237/255.0) green:(190/255.0) blue:(76/255.0) alpha:1.0f].CGColor;
        cell.backgroundColor=[colouArr objectAtIndex:indexPath.row];
        [cell.lblCount setText:[counterArr objectAtIndex:indexPath.row]];
        [cell.lblComponentName setText:[nameArr objectAtIndex:indexPath.row]];
    }
    else{
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CellScene" forIndexPath:indexPath];
        cell.imageSceneComponent.image = [cell.imageSceneComponent.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.imageSceneComponent.tintColor=[UIColor whiteColor];
        cell.lblSceneName.text=[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:1];
        cell.imageSceneContainerView.layer.cornerRadius=20.0f;
        cell.imageSceneContainerView.layer.borderWidth=0.8f;
        cell.imageSceneContainerView.layer.borderColor=[UIColor colorWithRed:(237/255.0) green:(190/255.0) blue:(76/255.0) alpha:1.0f].CGColor;
        cell.layer.cornerRadius=45.0f;
    }
    
    return  cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    CGSize collectionviewSize=self.collectionView.frame.size;
    if (collectionView==self.collectionView) {
        
        if (switchCounter==0||motorCounter==0) {
            if (dimmerCounter==0||sensorCounter==0) {
                side1=collectionviewSize.width-10;
                side2=collectionviewSize.width/2-30;
                _collectionViewHeightConstaints.constant= [[NSNumber numberWithDouble:(totalCount*side2+20)] floatValue];
                
            }
            else{
                if (indexPath.row==0) {
                    side1=collectionviewSize.width-10;
                    side2=collectionviewSize.width/2-30;
                    _collectionViewHeightConstaints.constant= [[NSNumber numberWithDouble:(totalCount*side2-80)] floatValue];
                }
                else{
                    side1=collectionviewSize.width/2-8;
                    side2=collectionviewSize.width/2-8;
                }
            }
        }
        else if (dimmerCounter==0||sensorCounter==0) {
            if (switchCounter==0||motorCounter==0) {
                side1=collectionviewSize.width-10;
                side2=collectionviewSize.width/2-30;
                _collectionViewHeightConstaints.constant= [[NSNumber numberWithDouble:(totalCount*side2+20)] floatValue];
            }
            else{
                if (indexPath.row==0||indexPath.row==1) {
                    side1=collectionviewSize.width/2-10;
                    side2=collectionviewSize.width/2-10;
                    _collectionViewHeightConstaints.constant= [[NSNumber numberWithDouble:(totalCount*side2-140)] floatValue];
                }
                else{
                    side1=collectionviewSize.width-10;
                    side2=collectionviewSize.width/2-30;
                }
            }
        }
        else{
            side1=collectionviewSize.width/2-10;
            side2=collectionviewSize.width/2-10;
            _collectionViewHeightConstaints.constant= [[NSNumber numberWithDouble:(totalCount*side2-270)] floatValue];
        }
    }
    else{
        side1=90;
        side2=90;
    }
    
    
    return CGSizeMake(side1, side2);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [timer invalidate];
     timer = nil;
    if (collectionView==self.collectionView) {
        
        NSString *selectedId;
        
        if ([[nameArr objectAtIndex:indexPath.row]isEqualToString:@"Switch"]) {
            selectedId=@"SWITCHES";
            SwitchViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:selectedId];
            viewController.delegate=(id)self;
            [self presentViewController:viewController animated:YES completion:nil];
            
        }
        else if ([[nameArr objectAtIndex:indexPath.row]isEqualToString:@"Motor"]) {
            selectedId=@"MOTORS";
            
        }
        else if ([[nameArr objectAtIndex:indexPath.row]isEqualToString:@"Dimmer"]) {
            selectedId=@"DIMMERS";
            DimmerViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:selectedId];
            viewController.delegate=(id)self;
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else if ([[nameArr objectAtIndex:indexPath.row]isEqualToString:@"Sensor"]) {
            selectedId=@"SENSORS";
        }
    }
    else if (collectionView == self.collectionSceneView)    {
        
        SceneViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SCENE"];
        viewController.strSceneId=[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:0];
        viewController.strSceneName=[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:1];
        viewController.delegate=self;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
}

-(void)setCollectionViewCellBackgroundColour{
    
    if (switchCounter==0||motorCounter==0) {
        if (dimmerCounter==0||sensorCounter==0) {
            colouArr=[[NSArray alloc]initWithObjects:colorGreen,colouBlue, nil];
        }
        else{
            colouArr=[[NSArray alloc]initWithObjects:colorGreen,colouBlue,colouBlue, nil];}
    }
    else if (dimmerCounter==0||sensorCounter==0)
    {
        if (switchCounter==0||motorCounter==0) {
            colouArr=[[NSArray alloc]initWithObjects:colorGreen,colouBlue, nil];
        }
        else{
            colouArr=[[NSArray alloc]initWithObjects:colorGreen,colorGreen,colouBlue, nil];
        }
        
    }
    else{
        colouArr=[[NSArray alloc]initWithObjects:colorGreen,colouBlue,colouBlue,colorGreen, nil];
    }
    
}
-(void)setCollectionViewIcons{
    iconArr=[[NSMutableArray alloc]init];
    if (switchCounter>0) {
        [iconArr addObject:@"switch22x.png"];
    }
    if (motorCounter>0) {
        [iconArr addObject:@"ic_motors.png"];
    }
    if (dimmerCounter>0) {
        [iconArr addObject:@"ic_sliders.png"];
    }
    if (sensorCounter>0) {
        [iconArr addObject:@"drawer_sensors.png"];
    }
}



#pragma mark - Machine status related method

-(void)fetchMachineDataFromDatabase{
    
    NSString *selectQuery = [NSString stringWithFormat:@"select *from MachineConfig where isActive=1"];
    
    machineArray = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];
    
}

-(void)fetchMachineStatus:(NSTimer*)t{
    
    NSMutableArray *mutableArr=[[NSMutableArray alloc]init];
    
    NSLog(@"DASHBOARD TIMER STARTS..........");
    
    [self fetchMachineDataFromDatabase];
    dispatch_group_t group = dispatch_group_create();
    
    for (int i=0; i < [machineArray count]; i++) {
        dispatch_group_enter(group);
        NSString *url = [[NSMutableString alloc] init];
        if ([[[machineArray objectAtIndex:i] objectAtIndex:10] integerValue] == 1 ) {
            url = [NSString stringWithFormat:@"http://%@",[[machineArray objectAtIndex:i] objectAtIndex:3]];
            
        }else{
            url = [NSString stringWithFormat:@"http://%@/debt.xml",[[machineArray objectAtIndex:i] objectAtIndex:2]];
        }
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:MACHINE_TIME_OUT];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if ([data length] > 0 && error == nil) {
                
            }
            else if ( error != nil){
                
                //--------Find request URL and update Active status for the same
                 [mutableArr addObject:[[machineArray objectAtIndex:i] objectAtIndex:2]];
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

        NSString *selAllMachine = [NSString stringWithFormat:@"select count(*) from MachineConfig"];
        totalMachine = [[self.dbHandler MathOperationInTable:selAllMachine] integerValue];
        
        NSString *selActiveMachine=[NSString stringWithFormat:@"select count(*) from MachineConfig where isActive=1"];
        activeMachine = [[self.dbHandler MathOperationInTable:selActiveMachine] integerValue];
        
        if(activeMachine==0){
            [timer invalidate];
             timer = nil;
            UIViewController *popover=[self.storyboard instantiateViewControllerWithIdentifier:@"DISABLE_DIALOGUE"];
            popover.modalPresentationStyle = UIModalPresentationCustom;
            [popover setTransitioningDelegate:_customTransitionController];
            [self presentViewController:popover animated:YES completion:nil];
        }
        else
        {
            
            if (activeMachine < totalMachine) {
                //[timer invalidate];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"One of your machine is disabled" delegate:(id)self cancelButtonTitle:nil otherButtonTitles:@"OK" , nil];
                //[alertView setTag:4];
                [alertView setTag:14];
                [alertView show];
            }
            
        }
        
    });
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 4)
    {
        if(buttonIndex == 0)
        {
//            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"viewShow"];
            [[NSUserDefaults standardUserDefaults]
             setObject:@"ADD_MACHINE" forKey:@"storyboardID"];
            UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MENU_DRAWER"];
            [self presentViewController:viewController animated:YES completion:nil];
            
        }
    }
}

#pragma mark - Fetch Database Data

-(void)fetchDataCount
{
    NSString *selectSwitch = [NSString stringWithFormat:@"select count(*) from Components where  component_type='%@'",@"switch"];
    switches = [[self.dbHandler MathOperationInTable:selectSwitch] integerValue];
    
    NSString *selectMotor = [NSString
                             stringWithFormat:@"select count(*) from Components where  component_type='%@'",@"motor"];
    motors = [[self.dbHandler MathOperationInTable:selectMotor] integerValue];
    
    NSString *selectDimmer = [NSString stringWithFormat:@"select count(*) from Components where  component_type='%@'",@"dimmer"];
    dimmers = [[self.dbHandler MathOperationInTable:selectDimmer] integerValue];
    
    NSString *selectSensor = [NSString stringWithFormat:@"select count(*) from Components where  component_type='%@'",@"sensor"];
    sensors = [[self.dbHandler MathOperationInTable:selectSensor] integerValue];
    
    counterArr=[[NSMutableArray alloc]init];
    nameArr=[[NSMutableArray alloc]init];
    if (switches>0) {
        switchCounter=1;
        [counterArr addObject:[NSString stringWithFormat:@"%ld",switches]];
        [nameArr addObject:@"Switch"];
    }
    if (motors>0) {
        motorCounter=1;
        [counterArr addObject:[NSString stringWithFormat:@"%ld",motors]];
        [nameArr addObject:@"Motor"];
    }
    if (dimmers>0) {
        dimmerCounter=1;
        [counterArr addObject:[NSString stringWithFormat:@"%ld",dimmers]];
        [nameArr addObject:@"Dimmer"];
    }
    if (sensors>0) {
        sensorCounter=1;
        [counterArr addObject:[NSString stringWithFormat:@"%ld",sensors]];
        [nameArr addObject:@"Sensor"];
    }
    totalCount=switchCounter+motorCounter+dimmerCounter+sensorCounter;
    [self.collectionView reloadData];
}
-(void)removeAll{
    count = 0;
    [timer invalidate];
    timer = nil;
}


#pragma - mark Bottum UIButton IBAction

- (IBAction)btnFavourite:(id)sender {
    [timer invalidate];
     timer = nil;
    FavouriteViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"FAVOURITE"];
    viewController.delegate=(id)self;
    [self presentViewController:viewController animated:YES completion:nil];
    
}
- (IBAction)btnAddScene:(id)sender {
    
    [timer invalidate];
     timer = nil;
    self.btnBottom.tag=0;
    AddSceneViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ADD_SCENE"];
    viewController.delegate=self;
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (IBAction)btnBottom:(id)sender {
    
    NSInteger w=(self.view.frame.size.width-32);
    
    if (self.btnBottom.tag==0) {
        
        self.btnBottom.tag=1;
        [UIView animateWithDuration:0.8
                         animations:^{
                             
                             _btnViewWidthConstraints.constant +=w;
                             [self.view layoutIfNeeded];
                             [self.btnTouchPanel setAlpha:1.0];
                             [self.btnMachine setAlpha:1.0];
                             [self.btnCreateScene
                              setAlpha:1.0];
                             [self.lblTouchPane setAlpha:1.0];
                             [self.lblMachine setAlpha:1.0];
                             [self.lblCreateScene
                              setAlpha:1.0];
                         }];
        
    }
    else if (self.btnBottom.tag==1) {
        self.btnBottom.tag=0;
        [UIView animateWithDuration:0.8
                         animations:^{
                             
                             _btnViewWidthConstraints.constant -=w;
                             [self.view layoutIfNeeded];
                             [self.btnTouchPanel setAlpha:0.0];
                             [self.btnMachine setAlpha:0.0];
                             [self.btnCreateScene
                              setAlpha:0.0];
                             [self.lblTouchPane setAlpha:0.0];
                             [self.lblMachine setAlpha:0.0];
                             [self.lblCreateScene
                              setAlpha:0.0];
                         }];
        
    }
    
}

- (IBAction)btnScheduler:(id)sender {
    [timer invalidate];
     timer = nil;
    SchedulerListViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"SCHEDULER_LIST"];
    viewController.delegate=(id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)btnBottumMachine:(id)sender {
    [timer invalidate];
     timer = nil;
//    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"viewShow"];
    self.btnBottom.tag=0;
    AddMachineViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ADD_MACHINE"];
    viewController.strDismiss=@"1";
    viewController.delegate=(id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)btnPower:(id)sender {
    
    [timer invalidate];
     timer = nil;
    if (self.btnPower.tag==0)
    {
    
        [self showHud];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self componentStatusMethod];
        });
    
        self.btnPower.tag=1;
        [self.btnPower setImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateNormal];
        [self.viewPowerOff setHidden:NO];
        self.viewBottom.backgroundColor=[UIColor colorWithRed:(60/255.0) green:(77/255.0) blue:(89/255.0) alpha:0.8];
        [self.btnFavourite setUserInteractionEnabled:NO];
        [self.btnBottom setUserInteractionEnabled:NO];
        [self.btnScheduler setUserInteractionEnabled:NO];
        
    }
    
    else if (self.btnPower.tag==1) {
        
       
        self.btnPower.tag=0;
        [self.btnPower setImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
        [self.viewPowerOff setHidden:YES];
        self.viewBottom.backgroundColor=[UIColor clearColor];
        
        [self.btnFavourite setUserInteractionEnabled:YES];
        [self.btnBottom setUserInteractionEnabled:YES];
        [self.btnScheduler setUserInteractionEnabled:YES];
        
        [self showHud];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self callMyURL:urlOffArr];
        });
    }
    
}

#pragma - mark Methods for Power Button

-(void)componentStatusMethod{

    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self fetchMachineDataFromDatabase];
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self callAllURLNOW:[self generateURLForAllComponents]];
   
    });
   
   
}

-(void) callAllURLNOW :(NSMutableDictionary *)dictionary {
    
    dispatch_group_t group = dispatch_group_create();
    
    for( NSString *aKey in [dictionary allKeys] )
    {
        dispatch_group_enter(group);
        
        NSString *url = [[NSMutableString alloc] init];
        url=[dictionary valueForKey:aKey];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if ([data length] > 0 && error == nil) {
                
                // NSURL *urlReq=[response URL];
                NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
                [xmlParser setDelegate:(id)self];
                [xmlParser parse];
                
                if ([self.xmlSwitchData count]>0) {
                    
                    [switchDict setObject:self.xmlSwitchData forKey:[response URL]];
                    
                }
            }
            else if ([data length] == 0 || error != nil){
                
            }
            dispatch_group_leave(group);
        }];
        [task resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        for (NSString *mykey in [switchDict allKeys]) {
            
            if ([[NSString stringWithFormat:@"%@",mykey] containsString:@"swcr"]) {
                
                for (int i=0; i<99; i++)
                {
                    NSString *str=[NSString stringWithFormat:@"SW%.2i",i+1];
                    if ([[[switchDict objectForKey:mykey] valueForKey:str] isEqualToString:@"00"])
                    {
                        [[switchDict objectForKey:mykey] removeObjectForKey:str];
                        
                    }
                    [[switchDict objectForKey:mykey] removeObjectForKey:@"SWCR"];
                }
            }
            if ([[NSString stringWithFormat:@"%@",mykey] containsString:@"dmcr"]) {
                
                for (int i=0; i<33; i++)
                {
                    NSString *str=[NSString stringWithFormat:@"DM%.2i",i+1];
                    if ([[[[switchDict objectForKey:mykey] valueForKey:str]substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"00"])
                    {
                        [[switchDict objectForKey:mykey] removeObjectForKey:str];
                    }
                }
                [[switchDict objectForKey:mykey] removeObjectForKey:@"DMCR"];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self getDATA:switchDict];
        });
    });

}


-(void)getDATA:(NSMutableDictionary *) dict{
  
    dimmmerDict=dict;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self requestToAccessComponent:dict];
    });
}

-(void)requestToAccessComponent:(NSMutableDictionary *)dict{
    
    [urlOnArr removeAllObjects];
    [urlOffArr removeAllObjects];
    
    for(NSString *key in [dict allKeys]) {
        
        NSString *switchIP=[[NSMutableString alloc]init];
        if ([[NSString stringWithFormat:@"%@",key] containsString:@"swcr"]) {
            
            for(NSString *mykey in [dict objectForKey:key]){
                
                NSString *myStr=[NSString stringWithFormat:@"%@",key];
                
                for (int i=0; i<[machineArray count]; i++)
                {
                    if ([[[machineArray objectAtIndex:i] objectAtIndex:10] integerValue] == 1 ) {
                        
                        if ([myStr containsString:[[machineArray objectAtIndex:i] objectAtIndex:3]]) {
                            
                            switchIP=[[machineArray objectAtIndex:i] objectAtIndex:3];
                        }
                    }
                    else
                    {
                        
                        if ([myStr containsString:[[machineArray objectAtIndex:i] objectAtIndex:2]]) {
                            switchIP= [[machineArray objectAtIndex:i] objectAtIndex:2];
                        }
                    }
                }
              
                NSString *switchURL=[NSString stringWithFormat:@"http://%@/cswcr.cgi?SW=%@%@",switchIP,[mykey substringWithRange:NSMakeRange(2, 2)],@"00"];
                
                [urlOnArr addObject:switchURL];
                NSString *switchURL1=[NSString stringWithFormat:@"http://%@/cswcr.cgi?SW=%@%@",switchIP,[mykey substringWithRange:NSMakeRange(2, 2)],@"01"];
                
                [urlOffArr addObject:switchURL1];
                
            }
            
        }
                else if ([[NSString stringWithFormat:@"%@",key] containsString:@"dmcr"]) {
        
                    for(NSString *mykey in [dict objectForKey:key]){
        
                        NSString *myStr=[NSString stringWithFormat:@"%@",key];
        
                        for (int i=0; i<[machineArray count]; i++)
                        {
                            if ([[[machineArray objectAtIndex:i] objectAtIndex:10] integerValue] == 1 ) {
        
                                if ([myStr containsString:[[machineArray objectAtIndex:i] objectAtIndex:3]]) {
        
                                    switchIP=[[machineArray objectAtIndex:i] objectAtIndex:3];
                                }
                            }
                            else
                            {
        
                                if ([myStr containsString:[[machineArray objectAtIndex:i] objectAtIndex:2]]) {
                                    switchIP= [[machineArray objectAtIndex:i] objectAtIndex:2];
                                }
                            }
                        }
                        NSString *strToPass=[NSString stringWithFormat:@"%@%@",@"00",[[[dict objectForKey:key] valueForKey:mykey] substringWithRange:NSMakeRange(2, 2)]];
        
                        NSString *dimmerURL=[NSString stringWithFormat:@"http://%@/cdmcr.cgi?DM=%@%@",switchIP,[mykey substringWithRange:NSMakeRange(2, 2)],strToPass];
                        
                        [urlOnArr addObject:dimmerURL];
                        NSString *strToPass1=[NSString stringWithFormat:@"%@%@",@"01",[[[dict objectForKey:key] valueForKey:mykey] substringWithRange:NSMakeRange(2, 2)]];
                        
                        NSString *dimmerURL1=[NSString stringWithFormat:@"http://%@/cdmcr.cgi?DM=%@%@",switchIP,[mykey substringWithRange:NSMakeRange(2, 2)],strToPass1];
                        
                        [urlOffArr addObject:dimmerURL1];

                        
                    }
                    
                    
                }

    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self callMyURL:urlOnArr];
    });
    


}
-(void)callMyURL:(NSMutableArray *)array {
     dispatch_group_t group = dispatch_group_create();

    for (int i=0; i<[array count]; i++) {
        
        dispatch_group_enter(group);

        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:[array objectAtIndex:i]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if ([data length] > 0 && error == nil) {
                
                // NSURL *urlReq=[response URL];
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


}
#pragma - mark Switch method call method

-(NSMutableDictionary *) generateURLForAllComponents{
    
    NSString *url1 = [[NSMutableString alloc] init];
    NSString *url2 = [[NSMutableString alloc] init];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    for (int i=0; i<[machineArray count]; i++)
    {
        
        if ([[[machineArray objectAtIndex:i] objectAtIndex:4] integerValue] == 1) {
            
            if ([[[machineArray objectAtIndex:i] objectAtIndex:10] integerValue] == 1 ) {
                networkStatus = [reachability currentReachabilityStatus];
                if (networkStatus == ReachableViaWWAN||networkStatus == ReachableViaWiFi)
                {
                    url1 = [NSString stringWithFormat:@"http://%@/swcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:3]];
                    url2 = [NSString stringWithFormat:@"http://%@/dmcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:3]];
                    [dictionary setValue:url1 forKey:[NSString stringWithFormat:@"switch%d",i]];
                    [dictionary setValue:url2 forKey:[NSString stringWithFormat:@"dimmer%d",i]];
                }
                else{
                    [self.view makeToast:@"You aren't connected to internet."];
                }
            }
            else{
                networkStatus = [reachability currentReachabilityStatus];
                if (networkStatus == ReachableViaWiFi)
                {
                    url1 = [NSString stringWithFormat:@"http://%@/swcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:2]];
                    url2 = [NSString stringWithFormat:@"http://%@/dmcr.xml",[[machineArray objectAtIndex:i] objectAtIndex:2]];
                    [dictionary setValue:url1 forKey:[NSString stringWithFormat:@"switch%d",i]];
                    [dictionary setValue:url2 forKey:[NSString stringWithFormat:@"dimmer%d",i]];
                }
                else{
                    [self.view makeToast:@"You aren't connected to Wi-Fi."];
                }
                
            }
        }
    }
    return  dictionary;
}

#pragma - mark  NSXMLParser Delegate methods

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    if ([elementName isEqualToString:@"SWCR"]) {
        
        self.xmlSwitchData = [[NSMutableDictionary alloc] init];
    }
    if ([elementName isEqualToString:@"DMCR"]) {
        
        self.xmlSwitchData = [[NSMutableDictionary alloc] init];
        
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
        [self.xmlSwitchData setValue:[mstrXMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:elementName];
        
    }
    if (![elementName isEqualToString:@"DMCR"]) {
        [self.xmlSwitchData setValue:[mstrXMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:elementName];
        
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
                       hud.detailsLabelText=@"Please Wait...";
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

#pragma - mark Scene methods

-(void)fetchSceneData{

    NSString *selectQuery = [NSString stringWithFormat:@"select *from Scene"];
    
    sceneArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:3];
    if ([sceneArr count]!=0) {
        [self.lblSceneStatus setHidden:YES];
    }
    else{
        [self.lblSceneStatus setText:@"No scene created."];
    }
    
    [self.collectionSceneView reloadData];
}

-(void)getBackFromController {
    
    [self viewDidLoad];
    
}
-(void) getBackFromAddSceneController {
    
    [self viewDidLoad];
}
- (IBAction)btnTouchPanel:(id)sender {
    
    [timer invalidate];
     timer = nil;
    self.btnBottom.tag=0;
    TouchPanelViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TOUCH_PANEL"];
    viewController.delegate=(id)self;
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
