//
//  DimmerTableViewCell.h
//  D2brain
//
//  Created by webmyne systems on 19/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DimmerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDimmerRating;
@property (weak, nonatomic) IBOutlet UIView *viewDimmerRating;
@property (weak, nonatomic) IBOutlet UISlider *sliderDimmer;
@property (weak, nonatomic) IBOutlet UILabel *lblDimmerName;

@property (weak, nonatomic) IBOutlet UIButton *btnFavourite;
@property (weak, nonatomic) IBOutlet UIButton *btnRename;

@property (weak, nonatomic) IBOutlet UISwitch *dimmerMachine;

@property (weak, nonatomic) IBOutlet UIButton *btnScheduler;
@property (weak, nonatomic) IBOutlet UIButton *btnScene;
@end
