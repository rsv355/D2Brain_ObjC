//
//  SelectSchedulerComponentViewController.h
//  D2brain
//
//  Created by webmyne systems on 06/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@protocol BackViewControllerDelegate <NSObject>

@required
- (void)componentDataFromController:(NSMutableDictionary *)dictionary;

@end

@interface SelectSchedulerComponentViewController : UIViewController

@property (nonatomic, weak) id<BackViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (strong, nonatomic)NSString *componentType;
- (IBAction)btnClose:(id)sender;

@end
