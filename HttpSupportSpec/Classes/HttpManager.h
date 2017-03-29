//
//  HttpManager.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/21.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(id obj);
/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailedBlock)(id obj);

@interface HttpManager : NSObject

+ (HttpManager *)ShareInstance;
#pragma afnetwork Get
- (void)AFNetGETSupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void (^)(id))success FailedBlock:(void (^)(NSError *))failure;
#pragma afnetwork Post
- (void)AFNetPOSTSupport:(NSString *)url Parameters:(NSDictionary *)dic ConstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))bodyblock SucessBlock:(void (^)(id))success FailedBlock:(void (^)(NSError *))failure;

/**
 因为afnetwork默认用muldata的格式传输，所以改传输方式

 @param url     http路径，string格式
 @param dic     参数字典
 @param success 成功后回调block
 @param failure 失败后的回调block
 */
- (void)AFNetUrlPOSTSupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void (^)(id))success FailedBlock:(void (^)(NSError *))failure;
#pragma 同步缓存get请求
- (NSData *)httpGetSupport:(NSString *)url;
- (NSData *)httpPostSupport:(NSString *)urlString PostName:(NSData *)fileData FileType:(NSString *)fileType FileTrail:(NSString *)fileTrail;

@end
