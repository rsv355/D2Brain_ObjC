//
//  SelectSchedulerComponentViewController.m
//  D2brain
//
//  Created by webmyne systems on 06/06/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "SelectSchedulerComponentViewController.h"
#import "SelectComponentCollectionViewCell.h"

@interface SelectSchedulerComponentViewController () 
{
    SelectComponentCollectionViewCell *cell;
    NSMutableArray *switchArr,*dimmerArr,*checkboxSelected;
    NSArray *componentArr;
    NSDictionary *componentDict;
}
@end

@implementation SelectSchedulerComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    [self fetchAllComponents:_componentType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchAllComponents:(NSString *)componentType {
    
    NSString *selectQuery = [NSString stringWithFormat:@"select c.* , m.machine_name, m.machine_ip, m.worldwide_ip, m.isActive,m.isWWIPActive from Components As c JOIN MachineConfig As m where c.machine_id = m.machine_id AND c.component_type='%@'",componentType];
    
    componentArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];

    [self.collectionView reloadData];
}
#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [componentArr count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.lblSchedulerMachineName.text=[[componentArr objectAtIndex:indexPath.row]objectAtIndex:6];
    cell.lblSchedulerComponentName.text=[[componentArr objectAtIndex:indexPath.row]objectAtIndex:2];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    CGSize collectionviewSize=self.collectionView.frame.size;
    side1=collectionviewSize.width-10;
    side2=collectionviewSize.width/2-8;
    
    return CGSizeMake(side2, 54);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
   
    [dataDict setObject:[[componentArr objectAtIndex:indexPath.row] objectAtIndex:0] forKey:@"component_id"];
    [dataDict setObject:[[componentArr objectAtIndex:indexPath.row]objectAtIndex:2] forKey:@"component_name"];
    [dataDict setObject:[[componentArr objectAtIndex:indexPath.row]objectAtIndex:3] forKey:@"component_type"];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(componentDataFromController:)])
    {
        [_delegate componentDataFromController:dataDict];
    }
    
}


- (IBAction)btnClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
