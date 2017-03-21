//
//  TouchPanelViewController.h
//  D2brain
//
//  Created by webmyne systems on 08/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "CustomAnimationAndTransiotion.h"

@protocol PanelViewControllerDelegate <NSObject>

@required
- (void)getBackFromController;

@end

@interface TouchPanelViewController : UIViewController

@property(strong,nonatomic)DataBaseFile *dbHandler;

@property (strong,nonatomic)CustomAnimationAndTransiotion *customTransitionController;

@property (weak, nonatomic) IBOutlet UIButton *btnHeaderBack;
- (IBAction)btnHeaderBack:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *componentCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *touchPanelCollectionView;
@property (weak, nonatomic) IBOutlet UIView *viewOnOff;
@property (weak, nonatomic) IBOutlet UIView *viewUp;

@property (weak, nonatomic) IBOutlet UIView *viewDown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewFunctionHeightConstant;
@property (weak, nonatomic) IBOutlet UIView *viewFunction;
- (IBAction)btnComponent:(id)sender;
- (IBAction)btnSave:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
- (IBAction)btnEditMachine:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstant;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

//NSXMLParser
@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlData;

@property (weak, nonatomic) IBOutlet UIView *viewTouchPanel;
@property (weak, nonatomic) IBOutlet UILabel *btnOn;
@property (weak, nonatomic) IBOutlet UILabel *btnUp;
@property (weak, nonatomic) IBOutlet UILabel *btnDown;

@property (nonatomic, weak) id<PanelViewControllerDelegate> delegate;
@end
