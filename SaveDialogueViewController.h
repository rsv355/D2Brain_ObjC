//
//  SaveDialogueViewController.h
//  D2brain
//
//  Created by webmyne systems on 13/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveDialogueViewControllerDelegate <NSObject>

@required
- (void)getBackFromController:(NSString *)strData;

@end

@interface SaveDialogueViewController : UIViewController

@property (nonatomic, weak) id<SaveDialogueViewControllerDelegate> delegate;

- (IBAction)btnYes:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblDialogueTitle;

@property (strong, nonatomic) NSString *strDialogue;

@end
