//
//  WelcomeViewController.h
//  D2brain
//
//  Created by webmyne systems on 29/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "ViewController.h"
#import "PageContentViewController.h"

@interface WelcomeViewController : ViewController<UIPageViewControllerDelegate>

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
