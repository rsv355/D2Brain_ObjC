//
//  WelcomeViewController.m
//  D2brain
//
//  Created by webmyne systems on 29/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SKSplashIcon.h"
#import "SystemConfigurationViewController.h"

@interface WelcomeViewController ()

@property (strong, nonatomic) SKSplashView *splashView;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"showStartUpSceen1"];
    [self pingSplash];
    [self performSelector:@selector(loadingNextView)
               withObject:nil afterDelay:5.0f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startWalkthrough:(id)sender {
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (id)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    if(index ==[self.pageImages count]-1){
       
        SystemConfigurationViewController *fdetail = [self.storyboard instantiateViewControllerWithIdentifier:@"PAGE1"];
        fdetail.pageIndex = index;
        return fdetail;
        
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = NSNotFound;
    if ([viewController isKindOfClass:[PageContentViewController class]]) {
        index = ((PageContentViewController*) viewController).pageIndex;
    }else if ([viewController isKindOfClass:[SystemConfigurationViewController class]]){
        index = ((SystemConfigurationViewController*) viewController).pageIndex;
    }
    
    if ((index == 0) || (index == NSNotFound)) {
       
        return nil;
    }
    
    if (index==[self.pageImages count]) {
        
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = NSNotFound;
    if ([viewController isKindOfClass:[PageContentViewController class]]) {
        index = ((PageContentViewController*) viewController).pageIndex;
    }else if ([viewController isKindOfClass:[SystemConfigurationViewController class]]){
        index = ((SystemConfigurationViewController*) viewController).pageIndex;
    }
    
    if (index == NSNotFound || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    index++;

    if(index ==[self.pageImages count]+1){
       
        SystemConfigurationViewController *fdetail = [self.storyboard instantiateViewControllerWithIdentifier:@"PAGE1"];
        fdetail.pageIndex = index;
        //[self presentViewController:fdetail animated:YES completion:nil];
        
        return fdetail;
        
    }

    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return ([self.pageImages count]+1);
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
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
-(void)loadingNextView{
   
    _pageTitles = @[@"", @"", @"", @"",@"",@"",@"",@""];
   
    _pageImages =[[NSArray alloc]initWithObjects:@"page1.png",@"page2.png",@"page3.png",@"page4.png",@"page5.png",@"page6.png",@"page7.png",@"switch_guide.jpg", nil];
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = (id)self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}
@end
