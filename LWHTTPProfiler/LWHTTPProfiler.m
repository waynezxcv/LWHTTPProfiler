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

#import "LWHTTPProfiler.h"
#import <objc/runtime.h>


static void* LWHTTPProfilerEnabledKey = &LWHTTPProfilerEnabledKey;
static void* LWHTTPProfilerIgnoreKey = &LWHTTPProfilerIgnoreKey;

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

+ (void)setIgnoreArray:(NSArray *)ignoreArray {
    objc_setAssociatedObject(self, LWHTTPProfilerIgnoreKey, ignoreArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray *)ignoreArray {
    return objc_getAssociatedObject(self, LWHTTPProfilerIgnoreKey);
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
    NSString* mimeType = [header objectForKey:@"Content-Type"];
    if ([[method uppercaseString] isEqualToString:@"GET"] || [[method uppercaseString] isEqualToString:@"HEAD"]) {
        mimeType = nil;
    }
    NSMutableString* result = [[NSMutableString alloc] init];
    [result appendString:[NSString stringWithFormat:@"\n │ \n<Request:%p>\n",request]];
    [result appendString:[NSString stringWithFormat:@" ├─<Start Line> \n │ %@ %@ \n",method,url]];
    [self setupCommonsPart:result header:header mimeType:mimeType data:body error:nil];
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
    [result appendString:[NSString stringWithFormat:@"\n │ \n<Response:%p>\n",httpResponse]];
    [result appendString:[NSString stringWithFormat:@" ├─<Start Line> \n │ %@ \"%@\" %@\n",code,localizedString,url]];
    [self setupCommonsPart:result header:header mimeType:mimeType data:body error:error];
    return result;
}

+ (void)setupCommonsPart:(NSMutableString *)result header:(NSDictionary *)header mimeType:(NSString *)mimeType data:(NSData *)body error:(NSError *)error {
    [result appendString:[NSString stringWithFormat:@" │ \n"]];
    [result appendString:[NSString stringWithFormat:@" ├─<Header>     \n%@",[self headerStringWithDict:header]]];
    [result appendString:[NSString stringWithFormat:@" │ \n"]];
    [result appendString:[NSString stringWithFormat:@" ├─<Body>       \n │ %@\n",[self bodyStringWithData:body mimeType:mimeType error:error]]];
    [result appendString:@" │ "];
    [result appendFormat:@"\n"];
    [result appendString:@"<EOF>\n │ \n"];
}


+ (NSString *)headerStringWithDict:(NSDictionary *)header {
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

+ (NSString *)bodyStringWithData:(NSData *)body mimeType:(NSString *)mimeType error:(NSError *)error {

    if (error) {
        return [NSString stringWithFormat:@"[error]\n │ %@",[self prettyPrintedJsonString:error.userInfo]];
    }

    if (!mimeType || [mimeType isEqualToString:@""] || !body) {
        return @"[None]";
    }

    if ([[mimeType lowercaseString] hasSuffix:@"json"]) {

        id jsonObject = [NSJSONSerialization JSONObjectWithData:body options:0 error:nil];
        return [NSString stringWithFormat:@"[%@]\n │ %@",mimeType,[self prettyPrintedJsonString:jsonObject]];

    } else if ([[mimeType lowercaseString] hasPrefix:@"image"]) {

        UIImage* image = [UIImage imageWithData:body];
        return [NSString stringWithFormat:@"[%@]\n │ width:%.2fpx,height:%.2fpx,size:%.2fKB",mimeType,image.size.width,image.size.height,(float)body.length/1024];

    } else {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:body options:0 error:nil];
        if (jsonObject) {
            return [NSString stringWithFormat:@"[%@]\n │ %@",mimeType,[self prettyPrintedJsonString:jsonObject]];
        }
        return [NSString stringWithFormat:@"[%@]\n │ %@",mimeType,[self prettyPrintedString:[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]]];;
    }
}


+ (NSString *)prettyPrintedJsonString:(id)json {
    if (!json) {
        return @"[None]";
    }
    NSData* data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self prettyPrintedString:str];
}

+ (NSString *)prettyPrintedString:(NSString *)str {
    NSMutableString* pretty = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < str.length; i ++) {
        NSString* c = [str substringWithRange:NSMakeRange(i, 1)];
        [pretty appendString:c];
        if ([c isEqualToString:@"\n"] || [c isEqualToString:@"\r"]) {
            [pretty appendString:@" │ "];
        }
    }
    return pretty;
}

@end
