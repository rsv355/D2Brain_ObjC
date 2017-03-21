//
//  MachineEditViewController.m
//  D2brain
//
//  Created by webmyne systems on 05/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "MachineEditViewController.h"
#import "UIView+Toast.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AppConstant.h"

@interface MachineEditViewController ()
{
    NSMutableArray *machineArr;
    NSString *hitURL;
    NSString *machineName,*machine_ip,*worldwide_id,*isActive,*DA,*DSN,*DV,*DPC,*DCT,*txtSerialNo1;
    NSInteger switcheCount,dimmerCount,motorCount,sensorCount,machine_id;
    NSInteger validateProductCode;
    Reachability *reachability;
    NetworkStatus networkStatus;
    MBProgressHUD *hud;

}
@end

@implementation MachineEditViewController
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
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];

    reachability =[Reachability reachabilityWithHostname:@"www.google.com"];
    self.txtDeviceIP.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)) {
        self.txtDeviceIP.keyboardType = UIKeyboardTypeDecimalPad;
    }
    machine_id=[[[NSUserDefaults standardUserDefaults]objectForKey:@"machine_ID"] integerValue];
    self.txtDeviceIP.delegate=(id)self;
     self.txtSerialNo.delegate=(id)self;
     self.txtWorldWideIP.delegate=(id)self;
     self.txtMachineName.delegate=(id)self;
    validateProductCode =0;
    machineArr=[[NSMutableArray alloc]init];
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    [self fetchMachineDataFromDatabase];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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


-(void)fetchMachineDataFromDatabase{
    
    NSString *selectQuery = [NSString stringWithFormat:@"select *from MachineConfig where machine_id=%ld",machine_id];
   
    machineArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];
    
    [self.txtDeviceIP setText:[[machineArr objectAtIndex:0] objectAtIndex:2]];
    [self.txtMachineName setText:[[machineArr objectAtIndex:0] objectAtIndex:1]];
    [self.txtWorldWideIP setText:[[machineArr objectAtIndex:0] objectAtIndex:3]];
    txtSerialNo1=[[machineArr objectAtIndex:0] objectAtIndex:6];
    [self.txtSerialNo setText:[[machineArr objectAtIndex:0] objectAtIndex:6]];
    [self.txtSerialNo setUserInteractionEnabled:NO];
    if ([[[machineArr objectAtIndex:0] objectAtIndex:10] integerValue] == 1 ) {
        [self.txtDeviceIP setUserInteractionEnabled:NO];
    }
    else{
        [self.txtDeviceIP setUserInteractionEnabled:YES];
    }
}
-(IBAction)btnClose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnNext:(id)sender{
    [self.view endEditing:YES];
    networkStatus = [reachability currentReachabilityStatus];
    hitURL=[[NSMutableString alloc]init];
    if([self.txtDeviceIP.text length]==0 ||[self.txtMachineName.text length]==0||[self.txtSerialNo.text length]==0)
        {
            [self.view makeToast: @"Please Enter All Fields"];
        }
        else if ([self ipValidationUsingRegex:[self.txtDeviceIP text]]==NO)
        {
            [self.view makeToast: @"Invalid IP Address"];
        }
        else{
            if ([[[machineArr objectAtIndex:0] objectAtIndex:10] integerValue] == 1 ) {
                networkStatus = [reachability currentReachabilityStatus];
                
                if (networkStatus == ReachableViaWWAN||networkStatus == ReachableViaWiFi)
                {
                    hitURL = [NSString stringWithFormat:@"http://%@",[self.txtWorldWideIP text]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud show:YES];
                        
                    });
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{

                    [self requestMethod1];
                         });
                }
                else{
                    [self.view makeToast:@"You aren't connected to internet."];
                }
            }
            else{
                networkStatus = [reachability currentReachabilityStatus];
                if (networkStatus == ReachableViaWiFi)
                {
                    hitURL = [NSString stringWithFormat:@"http://%@/debt.xml",[self.txtDeviceIP text]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud show:YES];
                        
                    });
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self requestMethod1];
                         });
                }
                else{
                    [self.view makeToast:@"You aren't connected to Wi-Fi."];
                }
            
            }
    }

}

- (void)requestMethod1 {
    
    NSLog(@"------->>%@",hitURL);
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:hitURL]];
    [xmlparser setDelegate:(id)self];
    
    BOOL success = [xmlparser parse];
    
    if(success==YES){
       
        [xmlparser parse];
        if ([self.xmlData count]>0) {
            if ([[self.xmlData valueForKey:@"DSN"] isEqualToString:txtSerialNo1]) {
                
                [self codeCharacter:[self.xmlData valueForKey:@"DPC"]];
                if(validateProductCode ==9)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [self insertMachineData];
                        });
                }
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{

                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Wrong serial number" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                [self hideHud];
                    });
            }
        }
        
    }
    else{
       
        dispatch_async(dispatch_get_main_queue(), ^{

       
        UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:nil message:@"Wrong IP Address" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert1 show];
            [self hideHud];
            
        });
    }
    
}

-(BOOL)ipValidationUsingRegex:(NSString *)ipAddressStr
{
    NSString *ipValidStr = ipAddressStr;
    NSString *ipRegEx =
    @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:ipValidStr];
    
    return myStringMatchesRegEx;
}


-(void)codeCharacter:(NSString *)letters{
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
                    switcheCount=[[letterArray objectAtIndex:i] integerValue]*11;
                    
                    validateProductCode+=1;
                    break;
                    
                case 2:
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"0"]||[[letterArray objectAtIndex:i] isEqualToString:@"1"]||[[letterArray objectAtIndex:i] isEqualToString:@"2"]||[[letterArray objectAtIndex:i] isEqualToString:@"3"]) {
                        dimmerCount=[[letterArray objectAtIndex:i] integerValue]*11;
                       
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
                        motorCount=[[letterArray objectAtIndex:i] integerValue]*11;
                       
                        validateProductCode+=1;
                    }
                    else{
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        
                        validateProductCode-=1;
                    }
                    break;
                    

                    
                case 4:
                    sensorCount=[[letterArray objectAtIndex:i] integerValue]*11;
                    validateProductCode+=1;
                    
                    break;
                    
                case 5:
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"-"]) {
                        validateProductCode+=1;
                        
                    }
                    else{
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                       
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
                        
                        validateProductCode-=1;
                    }
                    break;
                    
                case 7:
                    
                    break;
                    
                case 8:
                    
                    if ([[letterArray objectAtIndex:i] isEqualToString:@"7"]||[[letterArray objectAtIndex:i] isEqualToString:@"8"]||[[letterArray objectAtIndex:i] isEqualToString:@"9"]) {
                        
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        
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
                    else{
                        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:nil message:@"Invalid Product Code" delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        validateProductCode-=1;
                    }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        
    }
   
}

-(void)insertMachineData{
    
    DA=[self.xmlData valueForKey:@"DA"];
    DSN=[self.xmlData valueForKey:@"DSN"];
    DV=[self.xmlData valueForKey:@"DV"];
    DPC=[self.xmlData valueForKey:@"DPC"];
    DCT=[self.xmlData valueForKey:@"DCT"];
    machine_ip=[self.txtDeviceIP text];
    worldwide_id=[self.txtWorldWideIP text];
    machineName=[self.txtMachineName text];
    
    NSString *updateQuery = [NSString stringWithFormat:@"update MachineConfig set machine_name='%@',machine_ip='%@',worldwide_ip='%@',DA='%@',DSN='%@',DV='%@',DPC='%@',DCT='%@' where machine_id=%ld",machineName,machine_ip,worldwide_id ,DA,DSN,DV,DPC,DCT,machine_id];
   
    [self.dbHandler UpdateDataWithQuesy:updateQuery];
    NSNumber *value=[[NSUserDefaults standardUserDefaults]objectForKey:@"showIt"];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"showIt"]isEqualToString:@"0"]||value==nil) {
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"viewShow"];
    }
    else{
//        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"viewShow"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [hud hide:YES];
        
    });
    [[NSUserDefaults standardUserDefaults]setObject:@"ADD_MACHINE" forKey:@"storyboardID"];
//    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MENU_DRAWER"];
//    [self presentViewController:viewController animated:YES completion:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(getBackToController)])
        {
            [_delegate getBackToController];
        }
    [self.view makeToast:@"Machine is successfully updated."];
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
                
                   });
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
