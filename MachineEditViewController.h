//
//  MachineEditViewController.h
//  D2brain
//
//  Created by webmyne systems on 05/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "RPFloatingPlaceholderTextField.h"

@protocol EditMachineViewControllerDelegate <NSObject>

@required
- (void)getBackToController;

@end

@interface MachineEditViewController : UIViewController

@property (nonatomic, weak) id<EditMachineViewControllerDelegate> delegate;

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtSerialNoViewHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtSerialNoBottumSpaceConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtViewHeightConst;

@end
