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

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface DDHttpManager : NSObject

/**
 所有http请求通用的header设置字典，比如：@"Content-Type":@"application/json; charset=utf-8"，默认不传;
 在发出http请求前，如果要设置通用头属性，必须先设置此处属性，否则无法成功设置通用头属性
 */
@property (nonatomic, strong) NSDictionary *commonHeader;

+ (DDHttpManager *)ShareInstance;
#pragma afnetwork Get,Post(仅限不包含bodyblock的情况下，一般情况下为上传文件的时候需要bodyblock),Put,Patch,Delete
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
#pragma afnetwork Post(包含bodyblock的情况下，一般情况下为上传文件的时候需要bodyblock)
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
