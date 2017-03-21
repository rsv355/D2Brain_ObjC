//
//  MenuDrawerViewController.m
//  ShreeSwastik
//
//  Created by Rajendrasinh Parmar on 25/09/15.
//  Copyright © 2015 ChorusProapp. All rights reserved.
//

#import "MenuDrawerViewController.h"
#import "ParentViewController.h"
#import "DataBaseFile.h"
#import "SKSplashIcon.h"

@interface MenuDrawerViewController (){
    ParentViewController *parentViewController;
}

@property (strong, nonatomic) SKSplashView *splashView;
@end

@implementation MenuDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    NSString *deviceName=[[UIDevice currentDevice]name];
    if ([deviceName containsString:@"iPad"]) {
       
        CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
        [self.view setTransform:transform];
    }
    else
    {
    
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideDrawer:) name:@"notifyMenuButtonClick" object:nil];
    [self setMainContainer];
    // Do any additional setup after loading the view.
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"showStartUpSceen1"] isEqualToString:@"1"]) {

        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"NV"] isEqualToString:@"1"]) {
            
            NSObject *obj=[[NSUserDefaults standardUserDefaults]objectForKey:@"showStartUpScreen"];
            if (obj!=nil) {
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"showStartUpScreen"] isKindOfClass:[NSNull class]]) {
                    
                    [self pingSplash];
                }
                else {
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"showStartUpScreen"] isEqualToString:@"1"]) {
                        [self pingSplash];
                    }
                }
            }
            else{
                [self pingSplash];
            }
        }
    }
    else {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"showStartUpSceen1"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"embedMenu"]) {
        MenuTableViewController *menuTableViewController = segue.destinationViewController;
        menuTableViewController.menuDrawerViewController = self;
        self.menuTableViewController = menuTableViewController;
    }
}


-(void)setContent:(NSString *)storyboardID{
   
    [parentViewController setSubContent:storyboardID];
    [self closeDrawer];
}
-(void)shareMyFeedback:(NSString *)strFeedback
{
    NSString *textToShare = @"We all are great!!";
    
    NSURL *myWebsite = [NSURL URLWithString:@"https://www.google.co.in/search?q=hulk+images&espv=2&biw=646&bih=399&tbm=isch&imgil=v4x83FyqO5-lZM%253A%253BYLEpIzVFYf4cKM%253Bhttp%25253A%25252F%25252Fweknowyourdreamz.com%25252Fhulk.html&source=iu&pf=m&fir=v4x83FyqO5-lZM%253A%252CYLEpIzVFYf4cKM%252C_&usg=__ESBmc5HRSIiD3EZ_H9JXHN2Yftw%3D&ved=0ahUKEwjvzPHTjv_LAhUOWY4KHWfeAgMQyjcIOA&ei=t60HV6-VO46yuQTnvIsY"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,UIActivityTypeMail,UIActivityTypeMessage,UIActivityTypePostToTwitter];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

-(void)setMainContainer{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    parentViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MAINCONTAINER"];
    _mainContent = parentViewController;
    [self addChildViewController:_mainContent];
    [_mainContent didMoveToParentViewController:self];
    [self.view addSubview:_mainContent.view];
}


#pragma mark - Drawer slider methods

-(void)slideDrawer:(id)sender{
    if (self.mainContent.view.frame.origin.x > 0) {
        [self closeDrawer];
    }else{
        [self openDrawer];
    }
}


-(void)openDrawer{
    CGRect frame = self.mainContent.view.frame;
    frame.origin.x = 240.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainContent.view.frame = frame;
    }];
}


-(void)closeDrawer{
    CGRect frame = self.mainContent.view.frame;
    frame.origin.x = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainContent.view.frame = frame;
    }];
}
- (void) pingSplash
{
    //Setting the background
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    //    imageView.image = [UIImage imageNamed:@"splash.png"];
    //    [_splashView setBackgroundImage:imageView.image];
    //
    
    //Ping style splash
    SKSplashIcon *pingSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"bulbY.png"] animationType:SKIconAnimationTypePing];
    
    //  _splashView = [[SKSplashView alloc] initWithSplashIcon:pingSplashIcon backgroundColor:[UIColor blackColor] animationType:SKSplashAnimationTypeBounce];
    _splashView =[[SKSplashView alloc]initWithSplashIcon:pingSplashIcon backgroundImage:[UIImage imageNamed:@"splash.png"] animationType:SKSplashAnimationTypeBounce];
    _splashView.animationDuration = 5.0f;
    
    [_splashView startAnimation];
    [self.view addSubview:_splashView];
    
    //----CIRCLE ANIAMTION
    
    int radius = 100;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                  CGRectGetMidY(self.view.frame)-radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor colorWithRed:(237/255.0) green:(190/255.0) blue:(76/255.0) alpha:1.0f].CGColor;
    circle.lineWidth = 3;
    
    // Add to parent layer
    [self.splashView.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 4.0; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    //---LABEL
    //    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(8, 40, 300, 50)];
    //
    //    [lable setText:@"Your Personal Thinking Machine"];
    //    lable.textColor=[UIColor whiteColor];
    //
    //    //lable.font = [UIFont fontWithName:ProximaNovaSemibold size:12]; //custom font
    //    lable.numberOfLines = 1;
    //    lable.baselineAdjustment = YES;
    //    lable.textAlignment=NSTextAlignmentCenter;
    //    lable.clipsToBounds = YES;
    //    lable.backgroundColor = [UIColor clearColor];
    //    [self.splashView addSubview:lable];
    
    
    
}

@end
