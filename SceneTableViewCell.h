//
//  SceneTableViewCell.h
//  D2brain
//
//  Created by webmyne systems on 02/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSwitchName;
@property (weak, nonatomic) IBOutlet UILabel *lblSwitchMachineName;
@property (weak, nonatomic) IBOutlet UIView *viewSwitch;

@property (weak, nonatomic) IBOutlet UILabel *lblDimmerName;
@property (weak, nonatomic) IBOutlet UILabel *lblDimmerMachineName;

@property (weak, nonatomic) IBOutlet UISwitch *machineSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblDimmerRating;
@property (weak, nonatomic) IBOutlet UISlider *machineDimmer;

@property (weak, nonatomic) IBOutlet UIButton *btnDeleteSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteDimmer;
@property (weak, nonatomic) IBOutlet UIView *viewDimmerRating;
@property (weak, nonatomic) IBOutlet UIView *viewDimmer;


@property (weak, nonatomic) IBOutlet UILabel *lblAllSceneName;
@property (weak, nonatomic) IBOutlet UILabel *lblSceneListName;
@property (weak, nonatomic) IBOutlet UIButton *btnEditScene;
@property (weak, nonatomic) IBOutlet UIButton *btnScehduleScene;
@property (weak, nonatomic) IBOutlet UISwitch *switchScene;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteScene;


@end
