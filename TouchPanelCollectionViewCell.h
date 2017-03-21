//
//  TouchPanelCollectionViewCell.h
//  D2brain
//
//  Created by webmyne systems on 08/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchPanelCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *viewTouch1;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIView *viewFour;
@property (weak, nonatomic) IBOutlet UIView *viewFive;
@property (weak, nonatomic) IBOutlet UIView *viewSix;
@property (weak, nonatomic) IBOutlet UIView *viewSeven;
@property (weak, nonatomic) IBOutlet UIView *viewEight;

@property (weak, nonatomic) IBOutlet UIButton *btnPos1;
@property (weak, nonatomic) IBOutlet UIButton *btnPos2;
@property (weak, nonatomic) IBOutlet UIButton *btnPos3;
@property (weak, nonatomic) IBOutlet UIButton *btnPos4;
@property (weak, nonatomic) IBOutlet UIButton *btnPos5;
@property (weak, nonatomic) IBOutlet UIButton *btnPos6;
@property (weak, nonatomic) IBOutlet UIButton *btnPos7;
@property (weak, nonatomic) IBOutlet UIButton *btnPos8;

@property (weak, nonatomic) IBOutlet UILabel *lblTouchPanelName;

//Component UICollectionView
@property (weak, nonatomic) IBOutlet UILabel *lblComponentName;
@end
