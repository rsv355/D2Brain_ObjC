//
//  MachineListViewController.h
//  D2brain
//
//  Created by webmyne systems on 29/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

//@protocol MachineListViewControllerDelegate <NSObject>
//
//@required
//- (void)getBackFromMachineListController;
//
//@end

@interface MachineListViewController : UIViewController

- (IBAction)btnAddMachine:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMachine;
@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlData;

@property (strong,nonatomic) NSString *strDismiss;

//@property (nonatomic, weak) id<MachineListViewControllerDelegate> delegate;

@end
