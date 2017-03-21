//
//  PageContentViewController.m
//  D2brain
//
//  Created by webmyne systems on 29/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSURL *url=[NSURL URLWithString:self.imageFile];
//    NSData *data=[NSData dataWithContentsOfURL:url];
//    [self.backgroundImageView setImage:[[UIImage alloc]initWithData:data]];
    //self.titleLabel.text = self.titleText;
    self.backgroundImageView.layer.borderWidth = 2.0;
    self.backgroundImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
