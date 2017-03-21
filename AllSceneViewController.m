//
//  AllSceneViewController.m
//  D2brain
//
//  Created by webmyne systems on 06/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "AllSceneViewController.h"
#import "SceneTableViewCell.h"
#import "SceneViewController.h"

@interface AllSceneViewController ()
{
    SceneTableViewCell *cell;
    NSArray *sceneArr;
    
}
@end

@implementation AllSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    [self fetchAllSceneFromDatabase];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([sceneArr count]>0) {
        [self.viewScene setHidden:YES];
    }
    else {
        [self.viewScene setHidden:NO];
    }
    return [sceneArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     cell=(SceneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.lblAllSceneName setText:[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:1]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectSwitchQuery = [NSString stringWithFormat:@"select COUNT(*) from Scene_Component where component_id=%ld AND scene_id=%ld",[_component_id integerValue],[[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:0] integerValue]];
    NSInteger total = [[self.dbHandler MathOperationInTable: selectSwitchQuery] integerValue];
    if (total!=0) {
    
        SceneViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"SCENE"];
        viewController.strSceneId=[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:0];
        viewController.strSceneName=[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:1];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else {
        NSString *insertQuery = [NSString stringWithFormat:@"insert into Scene_Component (scene_id,component_id,def_value) values (%ld,%ld,'%@')",[[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:0] integerValue],[_component_id integerValue],@"00"];

        [self.dbHandler insertDataWithQuesy:insertQuery];
        SceneViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"SCENE"];
        viewController.strSceneId=[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:0];
        viewController.strSceneName=[[sceneArr objectAtIndex:indexPath.row]objectAtIndex:1];
        [self presentViewController:viewController animated:YES completion:nil];

    }
}

#pragma - mark UIButton IBAction

- (IBAction)btnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchAllSceneFromDatabase {
   
    NSString *selectSwitchQuery = @"select * from Scene";
    sceneArr = [self.dbHandler selectAllDataFromTablewithQuery:selectSwitchQuery ofColumn:3];
    [self.tableView reloadData];
}
@end
