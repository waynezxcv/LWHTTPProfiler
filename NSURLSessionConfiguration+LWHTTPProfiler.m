//
//  NSURLSessionConfiguration+LWHTTPProfiler.m
//  NSURLSession
//
//  Created by 刘微 on 17/2/9.
//  Copyright © 2017年 刘微. All rights reserved.
//

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
