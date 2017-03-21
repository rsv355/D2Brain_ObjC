//
//  AllSceneViewController.h
//  D2brain
//
//  Created by webmyne systems on 06/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@interface AllSceneViewController : UIViewController

@property(strong,nonatomic)DataBaseFile *dbHandler;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnClose:(id)sender;

@property (strong, nonatomic) NSString *component_id;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeaderHeightConstant;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UIView *viewScene;
@property (weak, nonatomic) IBOutlet UIButton *btnCreatescene;
@end
