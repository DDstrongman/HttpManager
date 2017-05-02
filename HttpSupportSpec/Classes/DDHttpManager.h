//
//  DDHttpManager.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/21.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(id obj);
/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailedBlock)(id obj);

@interface DDHttpManager : NSObject

/**
 所有http请求通用的header设置字典，比如：@"Content-Type":@"application/json; charset=utf-8"，默认不传;
 在发出http请求前，如果要设置通用头属性，必须先设置此处属性，否则无法成功设置通用头属性
 */
@property (nonatomic, strong) NSDictionary *commonHeader;

+ (DDHttpManager *)ShareInstance;
#pragma afnetwork Get
/**
 发起get的http访问，异步

 @param url 访问的url
 @param dic 访问的参数字典
 @param success 成功后的处理block
 @param failure 失败后的处理block
 */
- (void)AFNetGETSupport:(NSString *)url
             Parameters:(NSDictionary *)dic
            SucessBlock:(void (^)(id))success
            FailedBlock:(void (^)(NSError *))failure;
/**
 发起get的http访问，异步
 
 @param url 访问的url
 @param dic 访问的参数字典
 @param header 新增http头的参数字典
 @param success 成功后的处理block
 @param failure 失败后的处理block
 */
- (void)AFNetGETSupport:(NSString *)url
             Parameters:(NSDictionary *)dic
              HeaderDic:(NSDictionary *)header
            SucessBlock:(void (^)(id))success
            FailedBlock:(void (^)(NSError *))failure;
#pragma afnetwork Post
/**
 发起post的http访问，muldata传输参数，即表单提交的方式

 @param url http路径，string格式
 @param dic 参数字典
 @param bodyblock 过程中的处理block
 @param success 成功后回调block
 @param failure 失败后的回调block
 */
- (void)AFNetPOSTSupport:(NSString *)url
              Parameters:(NSDictionary *)dic
ConstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))bodyblock
             SucessBlock:(void (^)(id))success
             FailedBlock:(void (^)(NSError *))failure;
/**
 发起post的http访问，并添加新的http头参数，muldata传输参数，即表单提交的方式
 
 @param url http路径，string格式
 @param dic 参数字典
 @param header 新增http头的参数字典
 @param bodyblock 过程中的处理block
 @param success 成功后回调block
 @param failure 失败后的回调block
 */
- (void)AFNetPOSTSupport:(NSString *)url
              Parameters:(NSDictionary *)dic
                  Header:(NSDictionary *)header
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
