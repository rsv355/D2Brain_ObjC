//
//  FavouriteDrawerViewController.h
//  D2brain
//
//  Created by webmyne systems on 17/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@interface FavouriteDrawerViewController : UIViewController



@property(strong,nonatomic)DataBaseFile *dbHandler;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlData;
@property (weak, nonatomic) IBOutlet UIView *viewNoFavourite;



@end
