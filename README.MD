
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/waynezxcv/LWAsyncDisplayView/blob/master/LICENSE)&nbsp;



# LWHTTPProfiler v1.0.0

## About LWHTTPProfiler

iOS开发HTTP报文打印工具。

##Useage

```objc

#ifdef DEBUG
    //设置为可用
    [LWHTTPProfiler setEnabled:YES];
#else
    //设置为不可用
    [LWHTTPProfiler setEnabled:NO];
#endif

    //如果需要，屏蔽某个URL的报文信息
    [LWHTTPProfiler setIgnoreArray:@[@"http://www.xxxxxx.xx"]];

```


然后就在Xcode终端中看到你的HTTP请求报文会像这样打印


![](https://github.com/waynezxcv/LWHTTPProfiler/raw/master/img/1.png)
![](https://github.com/waynezxcv/LWHTTPProfiler/raw/master/img/2.png)





## License

LWHTTPProfiler is available under the MIT license. See the LICENSE file for more info.



