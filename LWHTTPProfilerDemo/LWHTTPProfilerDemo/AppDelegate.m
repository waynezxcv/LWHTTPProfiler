/*
 https://github.com/waynezxcv/LWHTTPProfiler


 Copyright (c) 2017 waynezxcv <liuweiself@126.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "LWHTTPProfiler.h"




@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#ifdef DEBUG
    //设置为可用
    [LWHTTPProfiler setEnabled:YES];
#else
    //设置为不可用
    [LWHTTPProfiler setEnabled:NO];
#endif

    //AFNetworking
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://news-at.zhihu.com/api/4/version/ios/2.3.0"
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            //do something
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //do something
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //do something
        }];
    [manager GET:@"http://cc.cocimg.com/api/uploads/170208/040b645ace0afe95280c7f540dfe44e8.jpg"
      parameters:nil
        progress:^(NSProgress * _Nonnull uploadProgress) {
            //do something
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //do something
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //do something
        }];

    //NSURLSession
    //    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    //
    //    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://news-at.zhihu.com/api/4/version/ios/2.3.0"]];
    //    request.HTTPMethod = @"GET";
    //    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
    //                                                completionHandler:^(NSData * _Nullable data,
    //                                                                    NSURLResponse * _Nullable response,
    //                                                                    NSError * _Nullable error) {
    //                                                    //do something
    //                                                    NSLog(@"%@",data);
    //                                                }];
    //    [dataTask resume];



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


@end
