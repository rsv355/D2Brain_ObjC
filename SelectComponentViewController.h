//
//  SelectComponentViewController.h
//  D2brain
//
//  Created by webmyne systems on 31/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@protocol SecondViewControllerDelegate <NSObject>

@required
- (void)switchDataFromController:(NSMutableArray *)data;
- (void)dimmerDataFromController:(NSMutableArray *)data;

@end


@interface SelectComponentViewController : UIViewController

- (IBAction)btnClose:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSString *strComponentType;
@property (strong, nonatomic) NSArray *selectionArr;

@property(strong,nonatomic)DataBaseFile *dbHandler;
- (IBAction)btnAddScene:(id)sender;
@property (nonatomic, weak) id<SecondViewControllerDelegate> delegate;

@end
