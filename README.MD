


# LWHTTPProfiler v1.0.0

## About 

iOS tool that helps with profiling HTTP message print in Xcode console. 


## Usage


```objc

#ifdef DEBUG
//turn on
[LWHTTPProfiler setEnabled:YES];
#else
//turn off
[LWHTTPProfiler setEnabled:NO];
#endif

```

then，the http message log is printed automatically in the Xcode console like this

![](https://github.com/waynezxcv/LWHTTPProfiler/raw/master/img/1.png)
![](https://github.com/waynezxcv/LWHTTPProfiler/raw/master/img/2.png)


If you do not want to print a message you can disable him with URL

```objc

[LWHTTPProfiler setIgnoreArray:@[@"http://www.xxxxxx.xx"]];

```



## License

LWHTTPProfiler is available under the MIT license. See the LICENSE file for more info.



