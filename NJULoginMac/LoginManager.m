//
//  LoginManager.m
//  NJULoginMac
//
//  Created by 宋 奎熹 on 2016/12/18.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "LoginManager.h"
#import "AFNetworking.h"

#define LOGIN_URL @"http://p.nju.edu.cn/portal_io/login"
#define LOGOUT_URL @"http://p.nju.edu.cn/portal_io/logout"
#define CHECK_STATUS_URL @"http://p.nju.edu.cn/portal_io/getinfo"

@implementation LoginManager

+ (NSDictionary *)logout{
    
    __block NSDictionary *dict;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         @"application/json",
                                                         nil];
    [manager POST:LOGOUT_URL
       parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
              
              dict = (NSDictionary *)responseObject;
              
              NSUserNotification *localNotify = [[NSUserNotification alloc] init];
              localNotify.title = @"NJULogin";
              localNotify.informativeText = dict[@"reply_msg"];
              localNotify.soundName = NSUserNotificationDefaultSoundName;
              [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:localNotify];
              
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];

    return dict;
}

+ (NSDictionary *)loginWithUserName:(NSString *)username andPassword:(NSString *)password{
    NSDictionary *tmpDict = @{
                              @"username" : [NSString stringWithString:username],
                              @"password" : [NSString stringWithString:password],
                              };
    
    __block NSDictionary *dict;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         @"application/json",
                                                         nil];
    [manager POST:LOGIN_URL
       parameters:tmpDict
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
              
              dict = (NSDictionary *)responseObject;
              
              NSUserNotification *localNotify = [[NSUserNotification alloc] init];
              localNotify.title = @"NJULogin";
              localNotify.informativeText = dict[@"reply_msg"];
              localNotify.soundName = NSUserNotificationDefaultSoundName;
              [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:localNotify];
              
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];

    return dict;
}

@end
