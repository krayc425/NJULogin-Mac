//
//  LoginManager.h
//  NJULoginMac
//
//  Created by 宋 奎熹 on 2016/12/18.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

+ (NSDictionary *)logout;
+ (NSDictionary *)loginWithUserName:(NSString *)username andPassword:(NSString *)password;

@end
