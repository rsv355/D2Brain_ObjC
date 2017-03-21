//
//  DashboardCollectionViewCell.h
//  D2brain
//
//  Created by webmyne systems on 03/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextField *lblCount;
@property (weak, nonatomic) IBOutlet UIImageView *imageComponent;
@property (weak, nonatomic) IBOutlet UILabel *lblComponentName;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;

@property (weak, nonatomic) IBOutlet UIImageView *imageSceneComponent;
@property (weak, nonatomic) IBOutlet UILabel *lblSceneComponentName;
@property (weak, nonatomic) IBOutlet UIView *imageSceneContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lblSceneName;

@end
