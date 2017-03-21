//
//  FavouriteTableViewCell.h
//  D2brain
//
//  Created by webmyne systems on 23/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblSwitchName;
@property (weak, nonatomic) IBOutlet UILabel *lblSwitchMachineName;
@property (weak, nonatomic) IBOutlet UILabel *lblDimmerName;
@property (weak, nonatomic) IBOutlet UILabel *lblDimmerMachineName;
@property (weak, nonatomic) IBOutlet UISwitch *switchSwitches;
@property (weak, nonatomic) IBOutlet UISwitch *switchDimmers;
@property (weak, nonatomic) IBOutlet UISlider *sliderDimmer;
@property (weak, nonatomic) IBOutlet UILabel *lblDimmerRating;
@property (weak, nonatomic) IBOutlet UIView *viewDimmerRating;
@property (weak, nonatomic) IBOutlet UIButton *deleteSwitch;
@property (weak, nonatomic) IBOutlet UIButton *deleteDimmer;
@end
