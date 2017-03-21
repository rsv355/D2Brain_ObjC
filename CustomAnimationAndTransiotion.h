//
//  CustomAnimationAndTransiotion.h
//  SwastikReturns
//
//  Created by Developers on 06/10/15.
//  Copyright (c) 2015 ChorusProapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomAnimationAndTransiotion : NSObject <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@property (nonatomic,assign) BOOL isPresenting;

@end
