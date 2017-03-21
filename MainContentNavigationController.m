//
//  MainContentNavigationController.m
//  ShreeSwastik
//
//  Created by Rajendrasinh Parmar on 28/09/15.
//  Copyright © 2015 ChorusProapp. All rights reserved.
//

#import "MainContentNavigationController.h"
//#import "CharanRemediesViewController.h"
//#import "MyAccountViewController.h"
//#import "ProductDetailViewController.h"
//#import "NakshatraPredictionViewController.h"

@interface MainContentNavigationController (){
    UIStoryboard *storyboard;
}

@end

@implementation MainContentNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationRoot:(NSString *)storyBoardID{
    //NSLog(@"Setting navigation root here %@",storyBoardID);
    
    
    //Uncomment following code if conditional coding is required.Following the if else ladder is sample code to implement
    
    /*
     if ([storyBoardID isEqualToString:@"MY_CHARAN_REMEDIES"]) {
     
     }else if ([storyBoardID isEqualToString:@"PRODUCT"]){
     
     }else if ([storyBoardID isEqualToString:@"ABOUT"]){
     
     }else if ([storyBoardID isEqualToString:@"CONTACT_US"]){
     
     }else if ([storyBoardID isEqualToString:@"MY_ACCOUNT"]){
     
     }
     example:
     CharanRemediesViewController *charan = [storyboard instantiateViewControllerWithIdentifier:@"MY_CHARAN_REMEDIES"];
     charan.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     [self setViewControllers:@[charan] animated:NO];
     example end:
     */
    
    UIViewController *rootController = [storyboard instantiateViewControllerWithIdentifier:storyBoardID];
    rootController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self setViewControllers:@[rootController] animated:NO];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
