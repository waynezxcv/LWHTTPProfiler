/*
 https://github.com/waynezxcv

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

#import "LWHTTPProfiler.h"
#import <objc/runtime.h>


static void* LWHTTPProfilerEnabledKey = &LWHTTPProfilerEnabledKey;

@implementation LWHTTPProfiler


+ (void)setEnabled:(BOOL)enabled {
    objc_setAssociatedObject(self, LWHTTPProfilerEnabledKey, @(enabled),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)enabled {
    BOOL enabled = NO;
    if (objc_getAssociatedObject(self, LWHTTPProfilerEnabledKey) &&
        [objc_getAssociatedObject(self, LWHTTPProfilerEnabledKey) boolValue] == YES) {
        enabled = YES;
    }
    return enabled;
}

+ (void)showSendRequest:(NSMutableURLRequest *)request {
    NSLog(@"%@",[self createRequestLogStringWithRequest:request]);
}

+ (void)showReceiviedResponse:(NSURLResponse *)response data:(NSData *)data {
    NSLog(@"%@",[self createResponseLogStringWithResponse:response data:data error:nil]);
}

+ (void)showReceiviedResponse:(NSURLResponse *)response error:(NSError *)error {
    NSLog(@"%@",[self createResponseLogStringWithResponse:response data:nil error:error]);
}

+ (NSString *)createRequestLogStringWithRequest:(NSMutableURLRequest *)request {
    NSString* method = request.HTTPMethod;
    NSString* url = request.URL.absoluteString;
    NSDictionary* header = request.allHTTPHeaderFields;
    NSData* body = request.HTTPBody;

    NSMutableString* result = [[NSMutableString alloc] init];
    [result appendString:[NSString stringWithFormat:@"\n<Request:%p>\n",request]];
    [result appendString:[NSString stringWithFormat:@" ├─<Start Line> \n | %@ %@ \n",method,url]];
    [result appendString:[NSString stringWithFormat:@" │ \n"]];
    [result appendString:[NSString stringWithFormat:@" ├─<Header>     \n%@",[self createHeaderString:header]]];
    [result appendString:[NSString stringWithFormat:@" │ \n"]];
    [result appendString:[NSString stringWithFormat:@" ├─<Body>       \n%@\n",[self createRequestBodyString:body]]];
    [result appendString:@" │ "];
    [result appendFormat:@"\n"];
    [result appendString:@"<EOF>\n "];

    return result;
}

+ (NSString *)createResponseLogStringWithResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error {
    NSMutableString* result = [[NSMutableString alloc] init];
    NSHTTPURLResponse* httpResponse =(NSHTTPURLResponse *)response;
    NSString* url = httpResponse.URL.absoluteString;
    NSString* code = [NSString stringWithFormat:@"%ld",httpResponse.statusCode];
    NSDictionary* header = httpResponse.allHeaderFields;
    NSString* localizedString = [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode];
    NSData* body = data;
    NSString* mimeType = httpResponse.MIMEType;

    [result appendString:[NSString stringWithFormat:@"\n<Response:%p>\n",httpResponse]];
    [result appendString:[NSString stringWithFormat:@" ├─<Start Line> \n | %@ \"%@\" %@\n",code,localizedString,url]];
    [result appendString:[NSString stringWithFormat:@" │ \n"]];
    [result appendString:[NSString stringWithFormat:@" ├─<Header>     \n%@",[self createHeaderString:header]]];
    [result appendString:[NSString stringWithFormat:@" │ \n"]];
    [result appendString:[NSString stringWithFormat:@" ├─<Body>       \n | %@\n",[self createResponseBodyStringWithData:body mimeType:mimeType]]];
    [result appendString:@" │ "];
    [result appendFormat:@"\n"];
    [result appendString:@"<EOF>\n "];
    return result;
}

+ (NSString *)createRequestBodyString:(NSData *)body {
    NSMutableString* result = [[NSMutableString alloc] init];
    [result appendString:@" │ "];
    if (!body) {
        [result appendString:@"[None]"];
        return result;
    }


    [result appendString:[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]];
    return result;
}

+ (NSString *)createResponseBodyStringWithData:(NSData *)body mimeType:(NSString *)mimeType {
    id object = nil;
    if (!mimeType) {
        object = @"[None]";
    }
    if ([mimeType hasSuffix:@"json"]) {
        object = [NSJSONSerialization JSONObjectWithData:body options:0 error:nil];
    } else if ([mimeType hasSuffix:@"xml"]) {
        //TODO:
        object = @"[xml]";
    } else if ([mimeType hasSuffix:@"html"]) {
        //TODO:
        object = @"[html]";
    } else if ([mimeType hasSuffix:@"plain"]) {
        object = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    } else if ([mimeType hasPrefix:@"image"]) {
        UIImage* image = [UIImage imageWithData:body];
        object  = [NSString stringWithFormat:@"[image  width:%fpx height:%fpx size:%fKB]",image.size.width,image.size.height,(float)body.length/1024];
    } else {
        object = body;
    }
    return object;
}

+ (NSString *)createHeaderString:(NSDictionary *)header {
    NSMutableString* results = [[NSMutableString alloc] init];
    NSArray* allKeys = [header allKeys];
    for (NSString* key in allKeys) {
        NSString* value = [header objectForKey:key];
        [results appendString:@" │ "];
        [results appendString:key];
        [results appendString:@" : "];
        [results appendString:value];
        [results appendString:@"\n"];
    }
    return results;
}

@end
