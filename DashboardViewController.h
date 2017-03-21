//
//  DashboardViewController.h
//  D2brain
//
//  Created by webmyne systems on 02/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "ViewController.h"
#import "MainContentNavigationController.h"
#import "DataBaseFile.h"

@interface DashboardViewController : ViewController

@property (nonatomic,strong) MainContentNavigationController *mainContentNavigationController;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *btnFavouriteContainer;
@property (weak, nonatomic) IBOutlet UIView *btnAddSceneContainer;

@property (weak, nonatomic) IBOutlet UIView *btnUpContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnFavourite;
@property (weak, nonatomic) IBOutlet UIButton *btnScheduler;
@property (weak, nonatomic) IBOutlet UIButton *btnBottom;
@property (weak, nonatomic) IBOutlet UIButton *btnPower;
- (IBAction)btnPower:(id)sender;
- (IBAction)btnFavourite:(id)sender;
- (IBAction)btnAddScene:(id)sender;
- (IBAction)btnBottom:(id)sender;
- (IBAction)btnScheduler:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionSceneView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstaints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnViewWidthConstraints;


@property (weak, nonatomic) IBOutlet UIButton *btnCreateScene;
@property (weak, nonatomic) IBOutlet UIButton *btnMachine;
@property (weak, nonatomic) IBOutlet UIButton *btnTouchPanel;
- (IBAction)btnTouchPanel:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblTouchPane;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateScene;
@property (weak, nonatomic) IBOutlet UILabel *lblMachine;
@property (weak, nonatomic) IBOutlet UILabel *lblSceneStatus;
- (IBAction)btnBottumMachine:(id)sender;

@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (nonatomic, strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *xmlSwitchData,*xmlDimmerData;

-(void)removeAll;
@property (weak, nonatomic) IBOutlet UIView *viewPowerOff;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@end
