//
//  SelectComponentViewController.m
//  D2brain
//
//  Created by webmyne systems on 31/05/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "SelectComponentViewController.h"
#import "SelectComponentCollectionViewCell.h"
#import "UIView+Toast.h"
#import "AddSceneViewController.h"

@interface SelectComponentViewController ()
{
    SelectComponentCollectionViewCell *cell;
    NSMutableArray *switchArr,*dimmerArr,*checkboxSelected;
    NSArray *componentArr;
    NSDictionary *componentDict;
}
@end

@implementation SelectComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Show Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    if ([_strComponentType isEqualToString:@"switch"]) {
        [self.lblHeader setText:@"Switches"];
    }
    else if([_strComponentType isEqualToString:@"dimmer"]){
        [self.lblHeader setText:@"Dimmers"];
    }
    
    switchArr=[[NSMutableArray alloc]init];
    dimmerArr=[[NSMutableArray alloc]init];
    [self fetchAllComponents:_strComponentType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return [componentArr count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.lblMachineName.text=[[componentArr objectAtIndex:indexPath.row]objectAtIndex:6];
    cell.lblComponentName.text=[[componentArr objectAtIndex:indexPath.row]objectAtIndex:2];
    cell.btnCheckBox.layer.borderWidth=2.0;
    cell.btnCheckBox.layer.borderColor=[UIColor whiteColor].CGColor;
    [cell.btnCheckBox setTag:indexPath.row];
    [cell.btnCheckBox addTarget:self action:@selector(btnSelectedComponent:) forControlEvents:UIControlEventTouchDown];

    if ([[checkboxSelected objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
       
        [cell.btnCheckBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.btnCheckBox setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
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
-(void)btnSelectedComponent:(UIButton*)sender {
    
    if ([[checkboxSelected objectAtIndex:sender.tag] isEqualToString:@"1"]) {
        [checkboxSelected replaceObjectAtIndex:sender.tag withObject:@"0"];
    }
    else  if ([[checkboxSelected objectAtIndex:sender.tag] isEqualToString:@"0"]) {
        [checkboxSelected replaceObjectAtIndex:sender.tag withObject:@"1"];
    }
    [self.collectionView reloadData];
}


- (IBAction)btnClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)fetchAllComponents:(NSString *)componentType {
    
    NSString *selectQuery = [NSString stringWithFormat:@"select c.* , m.machine_name, m.machine_ip, m.worldwide_ip, m.isActive,m.isWWIPActive from Components As c JOIN MachineConfig As m where c.machine_id = m.machine_id AND c.component_type='%@'",_strComponentType];
    
    componentArr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:11];
 
    checkboxSelected=[[NSMutableArray alloc]init];
    for (int i=0; i<[componentArr count]; i++) {
        [checkboxSelected addObject:@"0"];
    }
    for (int i=0; i<[_selectionArr count]; i++) {
        
            for (int j=0; j<[componentArr count]; j++) {
                
                if ([[_selectionArr objectAtIndex:i] isEqualToString:[[componentArr objectAtIndex:j]objectAtIndex:0]]) {
                    
                        [checkboxSelected replaceObjectAtIndex:j withObject:@"1"];

                }
            }
    }
    [self.collectionView reloadData];
}


- (IBAction)btnAddScene:(id)sender {
    for (int i=0; i<[checkboxSelected count]; i++) {
        if ([[checkboxSelected objectAtIndex:i]isEqualToString:@"1"]) {
            if ([_strComponentType isEqualToString:@"switch"]) {
                [switchArr addObject:[componentArr objectAtIndex:i]];
            }
            else if ([_strComponentType isEqualToString:@"dimmer"]) {
                [dimmerArr addObject:[componentArr objectAtIndex:i]];
            }
        }
    }
    if ([_strComponentType isEqualToString:@"switch"]) {
   
        [self.view makeToast:[NSString stringWithFormat:@"Total selected Switches : %ld",[switchArr count]]];
        [[NSUserDefaults standardUserDefaults]setObject:switchArr forKey:@"switchArr"];
    }
    
    if ([_strComponentType isEqualToString:@"dimmer"]) {
        
        [self.view makeToast:[NSString stringWithFormat:@"Total selected Dimmers : %ld",[dimmerArr count]]];
        [[NSUserDefaults standardUserDefaults]setObject:dimmerArr forKey:@"dimmerArr"];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if([_strComponentType isEqualToString:@"switch"]) {
        if ([_delegate respondsToSelector:@selector(switchDataFromController:)])
        {
            [_delegate switchDataFromController:switchArr];
        }

    }
    else if([_strComponentType isEqualToString:@"dimmer"]) {
        if ([_delegate respondsToSelector:@selector(dimmerDataFromController:)])
        {
            [_delegate dimmerDataFromController:dimmerArr];
        }
    }
    

}

- (NSArray*)sendDataBackToFirstController
{
    NSArray *ary=[[NSArray alloc]initWithObjects:@"abc",@"avf", nil];
   
    return ary;
}
@end
