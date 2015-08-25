//
//  APP_PREFIX_MainView.m
//  BASE_PROJECT_PRODUCT_NAME
//
//  Created by phoebe on 15/1/25.
//  Copyright (c) 2015年 BASE_PROJECT_ORG_NAME. All rights reserved.
//

#import "APP_PREFIX_MainViewController.h"

@implementation APP_PREFIX_MainView

+ (APP_PREFIX_MainView*) masterController
{
    if ( [UIApplication sharedApplication].windows.count > 0 )
    {
        UIWindow* window = [UIApplication sharedApplication].windows[0];
        return (APP_PREFIX_MainView*) ((UINavigationController*)window.rootViewController).topViewController;
    }
    
    return nil;
}

@end
