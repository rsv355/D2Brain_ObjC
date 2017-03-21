//
//  TryAgainDialogueViewController.h
//  D2brain
//
//  Created by webmyne systems on 13/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TryAgainDialogueViewControllerDelegate <NSObject>

@required
- (void)getBackFromTryDialogueController:(NSString *)strData;

@end

@interface TryAgainDialogueViewController : UIViewController

@property (nonatomic, weak) id<TryAgainDialogueViewControllerDelegate> delegate;

- (IBAction)btnYes:(id)sender;


@property (strong, nonatomic) NSString *strDialogue;
@end
