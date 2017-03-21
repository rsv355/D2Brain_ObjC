//
//  TouchPanelTableViewCell.h
//  D2brain
//
//  Created by webmyne systems on 10/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchPanelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMachineName;



//-------setting page

@property (weak, nonatomic) IBOutlet UILabel *lblSettingName;
@property (weak, nonatomic) IBOutlet UISwitch *settingSwitch;
@end
