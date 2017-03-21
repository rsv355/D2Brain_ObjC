//
//  AddMachineDialogueViewController.h
//  D2brain
//
//  Created by webmyne systems on 05/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "RPFloatingPlaceholderTextField.h"

@protocol MachineDialogueViewControllerDelegate <NSObject>

@required
- (void)getBackToMyController;

@end

@interface AddMachineDialogueViewController : UIViewController

@property (nonatomic, weak) id<MachineDialogueViewControllerDelegate> delegate;

@property(strong,nonatomic)DataBaseFile *dbHandler;

- (IBAction)btnClose:(id)sender;
- (IBAction)btnNext:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtWorldWideIP;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtMachineName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtSerialNo;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtDeviceIP;

@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlData;
@end
