//
//  AddMachineTableViewCell.h
//  D2brain
//
//  Created by webmyne systems on 05/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMachineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchMachine;
@property (weak, nonatomic) IBOutlet UILabel *lblMachineName;
@property (weak, nonatomic) IBOutlet UILabel *lblMachinIPAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblMachinSerialNo;
@property (weak, nonatomic) IBOutlet UILabel *lblWorldWideIP;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnDeleteWidthConst;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWorldWideHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLineHeightconst;
@property (weak, nonatomic) IBOutlet UISwitch *switchWorldWide;




@property (weak, nonatomic) IBOutlet UISwitch *switchMachineList;
@property (weak, nonatomic) IBOutlet UILabel *lblMachineNameList;
@property (weak, nonatomic) IBOutlet UILabel *lblMachinIPAddressList;
@property (weak, nonatomic) IBOutlet UILabel *lblMachinSerialNoList;
@property (weak, nonatomic) IBOutlet UILabel *lblWorldWideIPList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnDeleteWidthConstList;

@property (weak, nonatomic) IBOutlet UIButton *btnDeleteList;
@property (weak, nonatomic) IBOutlet UIButton *btnEditList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWorldWideHeightConstList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLineHeightconstList;
@property (weak, nonatomic) IBOutlet UISwitch *switchWorldWideList;
@end
