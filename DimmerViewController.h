//
//  DimmerViewController.h
//  D2brain
//
//  Created by webmyne systems on 19/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "RPFloatingPlaceholderTextField.h"
#import "AllSceneViewController.h"

@protocol DimmerViewControllerDelegate <NSObject>

@required
- (void)getBackFromController;

@end

@interface DimmerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnHeaderBack;
- (IBAction)btnHeaderBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *btnUpContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControl:(id)sender;

@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewRenameDimmer;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtDimmerName;
- (IBAction)btnCloseRenameView:(id)sender;
- (IBAction)btnRenameDimmer:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewDisableComponent;

@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlData;

@property (nonatomic, weak) id<DimmerViewControllerDelegate> delegate;
@end
