//
//  PageContentViewController.h
//  D2brain
//
//  Created by webmyne systems on 29/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "ViewController.h"

@interface PageContentViewController : ViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
- (IBAction)btnClose:(id)sender;

@end
