//
//  ViewController.m
//  NSURLSession
//
//  Created by 刘微 on 17/2/6.
//  Copyright © 2017年 刘微. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"


@interface ViewController ()


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager GET:URL
      parameters:@{}
        progress:^(NSProgress * _Nonnull downloadProgress) {

        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

         }];

}































//
//// 1.接收到服务器的响应//<NSURLSessionDownloadDelegate,NSURLSessionDelegate>
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    // 允许处理服务器的响应，才会继续接收服务器返回的数据
//    NSLog(@"did receive response");
//    completionHandler(NSURLSessionResponseAllow);
//}
//
//// 2.接收到服务器的数据（可能调用多次）
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    // 处理每次接收的数据
//    NSLog(@"did receive data :%ld",data.length);
//}
//
//// 3.请求成功或者失败（如果失败，error有值）
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//    // 请求完成,成功或者失败的处理
//    NSLog(@"did complete ...error:%@",error);
//}
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location {
//    NSLog(@"did finish down loading to URL:%@",location);
//}
//
///* Sent periodically to notify the delegate of download progress. */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//      didWriteData:(int64_t)bytesWritten
// totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
//    NSLog(@"total bytes written:%lld",totalBytesWritten);
//    NSLog(@"expected to wirte:%lld",totalBytesExpectedToWrite);
//    NSLog(@"progress:%f",(float)totalBytesWritten/(float)totalBytesExpectedToWrite);
//}
//
///* Sent when a download has been resumed. If a download failed with an
// * error, the -userInfo dictionary of the error will contain an
// * NSURLSessionDownloadTaskResumeData key, whose value is the resume
// * data.
// */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
// didResumeAtOffset:(int64_t)fileOffset
//expectedTotalBytes:(int64_t)expectedTotalBytes {
//    NSLog(@"did resume at offset :%lld",fileOffset);
//    NSLog(@"expected total bytes :%lld",expectedTotalBytes);
//
//}
//
//- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
//    NSLog(@"url session did finish events for background");
//
//}
//
//
//NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
////GET
//request.HTTPMethod = @"GET";
//request.HTTPBody = nil;
////POST
////    request.HTTPMethod = @"POST";
////    request.HTTPBody = [@"username=xxx&password=xxx" dataUsingEncoding:NSUTF8StringEncoding];
//NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//
//configuration.protocolClasses = @[[LWURLProtocol class]];
//NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration
//                                                      delegate:self
//                                                 delegateQueue:[NSOperationQueue mainQueue]];
//
//
////     NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
////     NSURLResponse * _Nullable response,
////     NSError * _Nullable error) {
////     NSLog(@"%@",response);
////     NSLog(@"MIMEType :%@",response.MIMEType);
////     NSLog(@"Expect Length:%lld",response.expectedContentLength);
////     }];
////     [dataTask resume];
//
//NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request];
//[dataTask resume];
//
//
//
///*
// NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithRequest:request];
// [downloadTask resume];
//
// //暂停下载
// [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
// self.resumeData = resumeData;//已经下载的文件
// }];
//
// //继续下载
// NSURLSessionDownloadTask* resumeTask = [session downloadTaskWithResumeData:self.resumeData];
// [resumeTask resume];
//
//
// 设置Range从指定部分下载
// request.allHTTPHeaderFields = @{@"Range":@"bytes=0-801"};
//
// //上传
// NSURLSessionUploadTask* uploadTask = [session uploadTaskWithRequest:request fromData:nil];
// [uploadTask resume];
//
//
// //后台下载
// NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://waynezxcv.oss-cn-shenzhen.aliyuncs.com/Puppeteer_for_Mac.dmg"]];
//
// //关键在于设置NSURLSessionConfiguration
// NSURLSessionConfiguration* backConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.waynezxcv.background"];
// backConfiguration.sessionSendsLaunchEvents = YES;
// backConfiguration.discretionary = YES;
//
/*
 一旦配置过，你的NSURLSession对象就能在恰当的时机通过系统来启动上传和下载。如果任务完成后你的应用还在运行中(不管是在前台还是后天)，session对象就会通过delegate通知代理对象。如果你的任务还没有完成的时候系统终止了你的应用，系统会在后台自动继续这个任务并管理它。如果用户手动终止了你的应用，系统会取消任何没有完成的后台传输任务.
 */

/*
 NSURLSession* session = [NSURLSession sessionWithConfiguration:backConfiguration
 delegate:self
 delegateQueue:[NSOperationQueue mainQueue]];
 NSURLSessionDownloadTask* backgroundTask = [session downloadTaskWithRequest:request];
 [backgroundTask resume];
 
 */




@end
