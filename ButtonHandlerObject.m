//
//  ButtonHandlerObject.m
//  ShreeSwastik
//
//  Created by Developers on 01/12/15.
//  Copyright (c) 2015 ShreeSwastik. All rights reserved.
//

#import "ButtonHandlerObject.h"

@implementation ButtonHandlerObject
-(IBAction)handleMenuButtonClick:(id)sender{
       [[NSNotificationCenter defaultCenter]
     postNotificationName:@"notifyMenuButtonClick" object:self];

}

-(IBAction)handleLanguageChange:(id)sender{
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyLanguageButtonClick" object:self];
}

@end
