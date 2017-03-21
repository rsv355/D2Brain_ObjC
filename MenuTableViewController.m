//
//  MenuTableViewController.m
//  ShreeSwastik
//
//  Created by Rajendrasinh Parmar on 25/09/15.
//  Copyright © 2015 ChorusProapp. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuRow.h"
#import "DataBaseFile.h"

@implementation MenuTableViewController{
    NSUserDefaults *defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    NSString *deviceName=[[UIDevice currentDevice]name];
    if ([deviceName containsString:@"iPad"]) {
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1.4, 1.4);
        [self.view setTransform:transform];
    }
    else
    {
      
    }

    defaults=[NSUserDefaults standardUserDefaults];
    menuItems = [[NSMutableArray alloc] init];
    menuIcons = [[NSMutableArray alloc] init];
    menuItemIdentifire = [[NSMutableArray alloc] init];
    
    NSArray *defaultItems;
   
    defaultItems = [[NSArray alloc] initWithObjects:@"Home",@"Scenes",@"Favourites",@"Schedulers",@"Touch Panel",@"Add Machine",@"Settings",@"About Us",@"Contact Us", nil];
  

    NSArray *defaultIcons = [[NSArray alloc] initWithObjects:@"drawers_home.png", @"drawers_scenes.png",@"heart_wh.png",@"drawers_schedulers.png",@"dt.png",@"drawers_addmachine.png",@"drawers_settings.png",@"drawers_aboutus.png",@"drawers_contactus.png", nil];
   
    NSArray *defaultsMenuitemIdentifire = [[NSArray alloc] initWithObjects:@"MAINCONTAINER1",@"SCENE_LIST",@"FAVOURITE_DRAWER",@"SCHEDULER",@"",@"MACHINE_LIST",@"SETTING",@"ABOUT_US",@"CONTACT_US", nil];
    
    [menuItems addObjectsFromArray:defaultItems];
    [menuIcons addObjectsFromArray:defaultIcons];
    [menuItemIdentifire addObjectsFromArray:defaultsMenuitemIdentifire];
   
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuRow *cell = [tableView dequeueReusableCellWithIdentifier:@"menuRow" forIndexPath:indexPath];
    [cell.menuLabel setText:[menuItems objectAtIndex:indexPath.row]];
    [cell.menuIcon setImage:[UIImage imageNamed:[menuIcons objectAtIndex:indexPath.row]]];
   

    return cell;
}

-(void)tableView: (UITableView*)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==4) {
        UIViewController *viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"TOUCH_PANEL"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
    else {
       
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"viewShow"];
        [self.menuDrawerViewController setContent:[menuItemIdentifire objectAtIndex:indexPath.row]];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
                     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                        UIViewController *signup=[storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
            
                    [self presentViewController:signup animated:YES completion:nil];
        }
    }
}
@end
