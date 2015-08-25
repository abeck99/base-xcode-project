//
//  APP_PREFIX_MainView.m
//  BASE_PROJECT_PRODUCT_NAME
//
//  Created by phoebe on 15/1/25.
//  Copyright (c) 2015年 BASE_PROJECT_ORG_NAME. All rights reserved.
//

#import "APP_PREFIX_MainView.h"

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

+ (void) loadPage:(id)tag
{
    APP_PREFIX_MainView* controller = [self masterController];
    [controller goToControllerWithTag:tag];
}

+ (void) loadPage:(id)tag withData:(id)viewData
{
    APP_PREFIX_MainView* controller = [self masterController];
    [controller goToControllerWithTag:tag withData:viewData];
}

@end
