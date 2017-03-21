//
//  SceneViewController.h
//  D2brain
//
//  Created by webmyne systems on 02/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "CustomAnimationAndTransiotion.h"

@protocol MainSceneViewControllerDelegate <NSObject>

@required
- (void)getBackFromController;

@end

@interface SceneViewController : UIViewController

@property (strong,nonatomic)CustomAnimationAndTransiotion *customTransitionController;

@property (weak, nonatomic) IBOutlet UIButton *btnHeaderBack;
- (IBAction)btnHeaderBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *btnUpContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderTitle;

@property(strong,nonatomic)DataBaseFile *dbHandler;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlSwitchData,*xmlDimmerData;

- (IBAction)btnDimmer:(id)sender;
- (IBAction)btnSwitch:(id)sender;

- (IBAction)btnSaveScene:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveScene;

- (IBAction)btnSettings:(id)sender;

@property (strong, nonatomic) NSMutableArray *switchArr;
@property (strong, nonatomic) NSMutableArray *dimmerArr;

@property (strong, nonatomic) NSString *strSceneId;
@property (strong, nonatomic) NSString *strSceneName;
@property (weak, nonatomic) IBOutlet UISwitch *sceneSwitch;
- (IBAction)sceneSwitch:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewRename;
@property (weak, nonatomic) IBOutlet UITextField *txtSceneName;
- (IBAction)btnClose:(id)sender;
- (IBAction)btnRename:(id)sender;

@property (nonatomic, weak) id<MainSceneViewControllerDelegate> delegate;

@end
