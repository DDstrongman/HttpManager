# HttpSupportSpec


## Example

对于AFNetwork http请求所有方法的封装，同时增加了YYCache的缓存策略缓存URL的返回（post上传方法均不缓存）<br>
**只需设置url，必要参数，成功的处理Block和失败的处理Block，即可操作并缓存http，详细使用方法请参考.h文件，好用请给star，不好用欢迎提建议～**<br>
栗子时间：<br>
```
/**
发起所有方式的http访问，新增头参数，请注意，POST方法仅限不需要bodyblock的情况下使用

@param url 访问的url
@param dic 访问的参数字典
@param method 使用方法的type
@param request http请求方法的type
@param cache http缓存策略
@param header 新增http头的参数字典
@param success 成功后的处理block
@param failure 失败后的处理block
*/
- (void)AFNetMethodsSupport:(NSString *)url
                 Parameters:(NSDictionary *)dic
                     Method:(DDHttpMethodType)method
              RequestMethod:(DDRequestType)request
                CacheMethod:(DDHttpCacheMethod)cache
                  HeaderDic:(NSDictionary *)header
                SucessBlock:(void (^)(id))success
                FailedBlock:(void (^)(NSError *))failure
```

## Requirements

## Installation

HttpSupportSpec is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DDHttpSupport"
```

## Author

DDStrongman, lishengshu232@gmail.com

## License

HttpSupportSpec is available under the MIT license. See the LICENSE file for more info.
