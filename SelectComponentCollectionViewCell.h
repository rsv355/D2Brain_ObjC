//
//  SelectComponentCollectionViewCell.h
//  D2brain
//
//  Created by webmyne systems on 31/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectComponentCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (weak, nonatomic) IBOutlet UILabel *lblComponentName;
@property (weak, nonatomic) IBOutlet UILabel *lblMachineName;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerMachineName;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedulerComponentName;
@end
