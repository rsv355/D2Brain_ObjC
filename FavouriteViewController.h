//
//  FavouriteViewController.h
//  D2brain
//
//  Created by webmyne systems on 23/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@protocol FavouriteViewControllerDelegate <NSObject>

@required
- (void)getBackFromController;

@end

@interface FavouriteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnHeaderBack;
- (IBAction)btnHeaderBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *btnUpContainer;

@property(strong,nonatomic)DataBaseFile *dbHandler;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlData;
@property (weak, nonatomic) IBOutlet UIView *viewNoFavourite;

@property (nonatomic, weak) id<FavouriteViewControllerDelegate> delegate;

@end
