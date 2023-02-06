//
//  DDHttpManager.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/21.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

typedef enum {
    DDHttpGet = 0,
    DDHttpPost,
    DDHttpPut,
    DDHttpPatch,
    DDHttpDelete
}DDHttpMethodType;

typedef enum {
    DDRequestHttp = 0,
    DDRequestJson,
    DDRequestPlist
}DDRequestType;

typedef enum {
    ///只在使用http访问数据，并会更新或新建本地缓存，多用于实时性要求较多的环境
    DDHttpOnly = 0,
    ///有缓存只用缓存数据，没有则去http请求并在之后更新数据和本地缓存，默认采用此策略
    DDCacheElseHttp,
    ///有缓存优先用缓存数据，同时去http请求并在之后更新数据和本地缓存
    DDCacheThenHttp,
    ///只在缓存里找，没有缓存则返回空，多用于无网环境或省流量
    DDCacheMemoryOnly
}DDHttpCacheMethod;

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface DDHttpManager : NSObject

/**
 所有http请求通用的header设置字典，比如：@"Content-Type":@"application/json; charset=utf-8"，默认不传;
 在发出http请求前，如果要设置通用头属性，必须先设置此处属性，否则无法成功设置通用头属性
 */
@property (nonatomic, strong) NSDictionary *commonHeader;
/**
 默认采用的缓存模式，不设置则默认DDCacheElseHttp
 */
@property (nonatomic, assign) DDHttpCacheMethod cacheMethod;
/**
 默认采用单例，no，不使用，yes，使用
 */
@property (nonatomic, assign) BOOL notUseSingleton;
/**
 默认采用单例
 */
@property (nonatomic, assign) AFHTTPSessionManager *shareManager;

/**
 单实例化

 @return 返回单实例
 */
+ (DDHttpManager *)ShareInstance;
#pragma mark - afnetwork Get,Post(仅限不包含bodyblock的情况下，一般情况下为上传文件的时候需要bodyblock),Put,Patch,Delete,此块http有缓存
/**
 发起所有方式的http访问，不新增头参数，请注意，POST方法仅限不需要bodyblock的情况下使用
 
 @param url 访问的url
 @param dic 访问的参数字典
 @param method 使用方法的type
 @param request http请求方法的type
 @param success 成功后的处理block
 @param failure 失败后的处理block
 */
- (void)AFNetMethodsSupport:(NSString *)url
                 Parameters:(NSDictionary *)dic
                     Method:(DDHttpMethodType)method
              RequestMethod:(DDRequestType)request
                SucessBlock:(void (^)(id))success
                FailedBlock:(void (^)(NSError *))failure;
/**
 发起所有方式的http访问，不新增头参数，请注意，POST方法仅限不需要bodyblock的情况下使用
 
 @param url 访问的url
 @param dic 访问的参数字典
 @param method 使用方法的type
 @param request http请求方法的type
 @param cache http缓存策略
 @param success 成功后的处理block
 @param failure 失败后的处理block
 */
- (void)AFNetMethodsSupport:(NSString *)url
                 Parameters:(NSDictionary *)dic
                     Method:(DDHttpMethodType)method
              RequestMethod:(DDRequestType)request
                CacheMethod:(DDHttpCacheMethod)cache
                SucessBlock:(void (^)(id))success
                FailedBlock:(void (^)(NSError *))failure;
/**
 发起所有方式的http访问，新增头参数，请注意，POST方法仅限不需要bodyblock的情况下使用
 
 @param url 访问的url
 @param dic 访问的参数字典
 @param method 使用方法的type
 @param request http请求方法的type
 @param header 新增http头的参数字典
 @param success 成功后的处理block
 @param failure 失败后的处理block
 */
- (void)AFNetMethodsSupport:(NSString *)url
                 Parameters:(NSDictionary *)dic
                     Method:(DDHttpMethodType)method
              RequestMethod:(DDRequestType)request
                  HeaderDic:(NSDictionary *)header
                SucessBlock:(void (^)(id))success
                FailedBlock:(void (^)(NSError *))failure;
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
                FailedBlock:(void (^)(NSError *))failure;
#pragma mark - afnetwork Post(包含bodyblock的情况下，一般情况下为上传文件的时候需要bodyblock，此块http没有缓存)
/**
 发起post的http访问，muldata传输参数，即表单提交的方式
 
 @param url http路径，string格式
 @param dic 参数字典
 @param request http请求方法的type
 @param bodyblock 过程中的处理block
 @param success 成功后回调block
 @param failure 失败后的回调block
 */
- (void)AFNetPOSTSupport:(NSString *)url
              Parameters:(NSDictionary *)dic
           RequestMethod:(DDRequestType)request
ConstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))bodyblock
             SucessBlock:(void (^)(id))success
             FailedBlock:(void (^)(NSError *))failure;
/**
 发起post的http访问，并添加新的http头参数，muldata传输参数，即表单提交的方式
 
 @param url http路径，string格式
 @param dic 参数字典
 @param header 新增http头的参数字典
 @param request http请求方法的type
 @param bodyblock 过程中的处理block
 @param success 成功后回调block
 @param failure 失败后的回调block
 */
- (void)AFNetPOSTSupport:(NSString *)url
              Parameters:(NSDictionary *)dic
                  Header:(NSDictionary *)header
           RequestMethod:(DDRequestType)request
ConstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))bodyblock
             SucessBlock:(void (^)(id))success
             FailedBlock:(void (^)(NSError *))failure;

/**
 因为afnetwork默认用muldata的格式传输，所以改传输方式
 
 @param url     http路径，string格式
 @param dic     参数字典
 @param success 成功后回调block
 @param failure 失败后的回调block
 */
- (void)AFNetUrlPOSTSupport:(NSString *)url
                 Parameters:(NSDictionary *)dic
                SucessBlock:(void (^)(id))success
                FailedBlock:(void (^)(NSError *))failure;

@end
