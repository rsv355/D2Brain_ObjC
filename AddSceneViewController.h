//
//  AddSceneViewController.h
//  D2brain
//
//  Created by webmyne systems on 31/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "CustomAnimationAndTransiotion.h"

@protocol MainAddSceneViewControllerDelegate <NSObject>

@required
- (void)getBackFromAddSceneController;

@end

@interface AddSceneViewController : UIViewController

@property (strong,nonatomic)CustomAnimationAndTransiotion *customTransitionController;

@property (weak, nonatomic) IBOutlet UIButton *btnHeaderBack;
- (IBAction)btnHeaderBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *btnUpContainer;

@property(strong,nonatomic)DataBaseFile *dbHandler;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlSwitchData,*xmlDimmerData;
@property (weak, nonatomic) IBOutlet UITextField *txtSceneName;
- (IBAction)btnDimmer:(id)sender;
- (IBAction)btnSwitch:(id)sender;

- (IBAction)btnCreateScene:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateScene;

- (IBAction)btnSettings:(id)sender;

@property (strong, nonatomic) NSMutableArray *switchArr;
@property (strong, nonatomic) NSMutableArray *dimmerArr;

@property (nonatomic, weak) id<MainAddSceneViewControllerDelegate> delegate;

@end
