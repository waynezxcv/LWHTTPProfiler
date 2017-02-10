


# LWHTTPProfiler v1.0.0

## About LWHTTPProfiler


iOS开发HTTP调试，报文自动打印工具。



##Useage


```objc

#ifdef DEBUG
//设置为可用
[LWHTTPProfiler setEnabled:YES];
#else
//设置为不可用
[LWHTTPProfiler setEnabled:NO];
#endif

```

然后,在Xcode终端中HTTP请求会将报文打印成这样

![](https://github.com/waynezxcv/LWHTTPProfiler/raw/master/img/1.png)
![](https://github.com/waynezxcv/LWHTTPProfiler/raw/master/img/2.png)


如果不想打印某个报文可以将他禁用

```objc

//如果需要，屏蔽某个URL的报文信息
[LWHTTPProfiler setIgnoreArray:@[@"http://www.xxxxxx.xx"]];

```

## License

LWHTTPProfiler is available under the MIT license. See the LICENSE file for more info.



