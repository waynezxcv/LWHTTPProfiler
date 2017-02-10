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



#import "LWURLProtocol.h"
#import "LWHTTPProfiler.h"


#define URL_PROTOCOL_KEY @"LWURLProtocolKey"

@interface LWURLProtocol ()<NSURLSessionDataDelegate>

@property (nonatomic,strong) NSURLSession* session;
@property (nonatomic,strong) NSMutableData* data;
@property (nonatomic,strong) NSURLResponse* response;


@end

@implementation LWURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    //是否可用
    if (![LWHTTPProfiler enabled]) {
        return NO;
    }
    //是否加入ignoreArray
    for (NSInteger i = 0; i < [LWHTTPProfiler ignoreArray].count; i ++) {
        id object = [[LWHTTPProfiler ignoreArray] objectAtIndex:i];
        if (![object isKindOfClass:[NSString class]]) {
            return NO;
        }
        NSString* URL = (NSString *)object;
        if ([request.URL.absoluteString isEqualToString:URL]) {
            return NO;
        }
    }

    //判断请求是否已经标记
    if ([NSURLProtocol propertyForKey:URL_PROTOCOL_KEY inRequest:request] &&
        [[NSURLProtocol propertyForKey:URL_PROTOCOL_KEY inRequest:request] isEqual:@(YES)]) {
        return NO;
    }
    NSString* url = request.URL.absoluteString;
    if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}


- (void)startLoading {

    NSMutableURLRequest* request = [self.request mutableCopy];
    //标记该请求，在canInitWithRequest方法中判断，防止重复处理
    [NSURLProtocol setProperty:@(YES) forKey:URL_PROTOCOL_KEY inRequest:request];

    //NSURLSession中request.HTTPBody = nil,这里使用HTTPBodyStream
    if ([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"]) {
        if (!request.HTTPBody) {
            uint8_t buffer[1024];
            memset(buffer, 0, 1024);

            NSInputStream* stream = request.HTTPBodyStream;
            NSMutableData* data = [[NSMutableData alloc] init];
            [stream open];

            while ([stream hasBytesAvailable]) {
                NSInteger len = [stream read:buffer maxLength:1024];
                if (len > 0 && stream.streamError == nil) {
                    [data appendBytes:(void *)buffer length:len];
                }
            }

            request.HTTPBody = [data copy];
            [stream close];
        }
    }

    [LWHTTPProfiler showSendRequest:request];
    //创建转发dataTask
    NSURLSessionDataTask* dataTask = [self.session dataTaskWithRequest:request];
    [dataTask resume];
}


- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}


#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {

    self.data = [[NSMutableData alloc] init];
    self.response = response;

    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [LWHTTPProfiler showReceiviedResponse:self.response error:error];
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [LWHTTPProfiler showReceiviedResponse:self.response data:[self.data copy]];
        [self.client URLProtocolDidFinishLoading:self];
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

#pragma mark - Getter

- (NSURLSession *)session {
    if (_session) {
        return _session;
    }

    NSURLSessionConfiguration* sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                             delegate:self
                                        delegateQueue:[NSOperationQueue mainQueue]];
    return _session;
}

@end
