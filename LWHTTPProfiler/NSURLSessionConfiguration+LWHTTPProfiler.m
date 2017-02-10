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


#import "NSURLSessionConfiguration+LWHTTPProfiler.h"
#import <objc/runtime.h>
#import "LWURLProtocol.h"


@implementation NSURLSessionConfiguration(LWHTTPProfiler)

+ (void)load {
    [super load];
    [self exchangeDefaultConfiguration];
    [self exchangeEphemeralSessionConfiguration];
    [self exchangeBackgroundSessionConfiguration];
}

+ (void)exchangeDefaultConfiguration {
    Method origin = class_getClassMethod([self class],
                                         NSSelectorFromString(@"defaultSessionConfiguration"));
    Method instead = class_getClassMethod([self class],
                                          NSSelectorFromString(@"lw_defaultSessionConfiguration"));
    method_exchangeImplementations(instead, origin);
}

+ (void)exchangeEphemeralSessionConfiguration {
    Method origin = class_getClassMethod([self class],
                                         NSSelectorFromString(@"ephemeralSessionConfiguration"));
    Method instead = class_getClassMethod([self class],
                                          NSSelectorFromString(@"lw_ephemeralSessionConfiguration"));
    method_exchangeImplementations(instead, origin);
}

+ (void)exchangeBackgroundSessionConfiguration {
    Method origin = class_getClassMethod([self class],
                                         NSSelectorFromString(@"backgroundSessionConfigurationWithIdentifier:"));
    Method instead = class_getClassMethod([self class],
                                          NSSelectorFromString(@"lw_backgroundSessionConfigurationWithIdentifier:"));
    method_exchangeImplementations(instead, origin);
}

+ (NSURLSessionConfiguration *)lw_defaultSessionConfiguration {
    NSURLSessionConfiguration* defaultConfig = [self lw_defaultSessionConfiguration];
    defaultConfig.protocolClasses = @[[LWURLProtocol class]];
    return defaultConfig;
}

+ (NSURLSessionConfiguration *)lw_ephemeralSessionConfiguration {
    NSURLSessionConfiguration* ephemeralConfig = [self lw_ephemeralSessionConfiguration];
    ephemeralConfig.protocolClasses = @[[LWURLProtocol class]];
    return ephemeralConfig;
}


+ (NSURLSessionConfiguration *)lw_backgroundSessionConfigurationWithIdentifier:(NSString *)identifier NS_AVAILABLE(10_10, 8_0) {
    NSURLSessionConfiguration* backgroundConfig = [self lw_backgroundSessionConfigurationWithIdentifier:identifier];
    backgroundConfig.protocolClasses = @[[LWURLProtocol class]];
    return backgroundConfig;
}

@end
