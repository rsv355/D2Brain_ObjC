//
//  SceneListViewController.h
//  D2brain
//
//  Created by webmyne systems on 07/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "CustomAnimationAndTransiotion.h"

@interface SceneListViewController : UIViewController

@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (strong,nonatomic)CustomAnimationAndTransiotion *customTransitionController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNewScene;
- (IBAction)btnCreateScene:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewNoScene;
@property (weak, nonatomic) IBOutlet UIView *viewRename;
- (IBAction)bntCloseRenameView:(id)sender;
- (IBAction)btnRename:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtRename;

@end
