//
//  AddMachineViewController.h
//  D2brain
//
//  Created by webmyne systems on 05/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@protocol AddMachineViewControllerDelegate <NSObject>

@required
- (void)getBackFromController;

@end

@interface AddMachineViewController : UIViewController

- (IBAction)btnAddMachine:(id)sender;
@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMachine;

@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConst;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnHeaderBack;
- (IBAction)btnHeaderBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *btnUpContainer;

@property (strong,nonatomic) NSString *strDismiss;

@property (nonatomic, weak) id<AddMachineViewControllerDelegate> delegate;

@end
