//
//  AddSceneTableViewCell.h
//  D2brain
//
//  Created by webmyne systems on 31/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSceneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblSwitchName;
@property (weak, nonatomic) IBOutlet UILabel *lblSwitchMachineName;

@property (weak, nonatomic) IBOutlet UILabel *lblDimmerName;
@property (weak, nonatomic) IBOutlet UILabel *lblDimmerMachineName;

@property (weak, nonatomic) IBOutlet UISwitch *machineSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblDimmerRating;
@property (weak, nonatomic) IBOutlet UISlider *machineDimmer;

@property (weak, nonatomic) IBOutlet UIButton *btnDeleteSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteDimmer;
@property (weak, nonatomic) IBOutlet UIView *viewDimmerRating;
@property (weak, nonatomic) IBOutlet UIView *viewSwitch;
@property (weak, nonatomic) IBOutlet UIView *viewDimmer;
@end
