//
//  SwitchViewController.h
//  D2brain
//
//  Created by webmyne systems on 16/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "RPFloatingPlaceholderTextField.h"
#import "CustomAnimationAndTransiotion.h"

@protocol MainViewControllerDelegate <NSObject>

@required
- (void)getBackFromController;

@end

@interface SwitchViewController : UIViewController

@property (strong,nonatomic)CustomAnimationAndTransiotion *customTransitionController;

@property (weak, nonatomic) IBOutlet UIButton *btnHeaderBack;
- (IBAction)btnHeaderBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *btnUpContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControl:(id)sender;

@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewRenameSwitch;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtSwitchName;
- (IBAction)btnCloseRenameView:(id)sender;
- (IBAction)btnRenameSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewDisableComponent;

@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlData;

@property (nonatomic, weak) id<MainViewControllerDelegate> delegate;

//
//if ([_delegate respondsToSelector:@selector(getBackFromController)])
//{
//    [_delegate getBackFromController];
//}
@end
