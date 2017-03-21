//
//  SystemConfigurationViewController.h
//  D2brain
//
//  Created by webmyne systems on 29/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "ViewController.h"
#import "RPFloatingPlaceholderTextField.h"
#import "DataBaseFile.h"

@interface SystemConfigurationViewController : ViewController <NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtWorldWideIP;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtMachineName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtSerialNo;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtDeviceIP;
- (IBAction)btnNext:(id)sender;
@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlData;
@property(strong,nonatomic)DataBaseFile *dbHandler;
/*
 <DeDt>
 <led0>0</led0>
 <DA>128</DA>
 <DSN>01160001</DSN>
 <DV>V02.00</DV>
 <DPC>52110-1100</DPC>
 <DCT>DDMMYYHRMNSC</DCT>
 <QueryC>93865</QueryC>
 </DeDt>
 */

@end
