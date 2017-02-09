//
//  AppDelegate.m
//  NSURLSession
//
//  Created by 刘微 on 17/2/6.
//  Copyright © 2017年 刘微. All rights reserved.
//

#import "AppDelegate.h"
#import "LWHTTPProfiler.h"




@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [LWHTTPProfiler setEnabled:YES];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//后台下载
/*
 当一个后台session完成相关联的所有任务的时候，系统会重新加载终止的应用(假设sessionSendsLaunchEvents设置为YES，并且用户没有手动终止应用程序)并调用应用代理的application:handleEventsForBackgroundURLSession:completionHandler:方法。()在你实现相关代理的方法里，通过相同的标示符创建和之前一样的具有相同配置的NSURLSessionConfiguration对象和NSURLSession对象。系统会重新在新的session对象和之前完成的任务之间建立联系，并通过session对象的代理来报告状态。
 */
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    NSLog(@"handle events for background URLSession identifier:%@",identifier);
    completionHandler();
}

@end
