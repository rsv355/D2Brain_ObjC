//
//  SwitchTableViewCell.h
//  D2brain
//
//  Created by webmyne systems on 16/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSwitchName;
@property (weak, nonatomic) IBOutlet UIButton *btnFavourite;
@property (weak, nonatomic) IBOutlet UIButton *btnRename;
@property (weak, nonatomic) IBOutlet UISwitch *switchMachine;
@property (weak, nonatomic) IBOutlet UIButton *btnScene;
@property (weak, nonatomic) IBOutlet UIButton *btnScheduler;

@end
