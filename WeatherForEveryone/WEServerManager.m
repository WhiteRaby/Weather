//
//  WEServerManager.m
//  WeatherForEveryone
//
//  Created by Alexandr on 25.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "WEServerManager.h"
#import <AFNetworking.h>

@interface WEServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation WEServerManager

NSString *const APIKey = @"d74e401b2d3f29456cae6b7830f70bc4";

#pragma mark - Class Methods

+ (WEServerManager*)sharedManager {
    
    static WEServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WEServerManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Public Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [[AFHTTPSessionManager alloc] init];
    }
    return self;
}

- (void)getCitysWeatherWithName:(NSString*)name
                        success:(void(^)(id city))success
                        failure:(void(^)(NSError *error))failure {
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"London", @"q",
                                @"like", @"type",
                                @"JSON", @"mode", nil];
    
    [self.sessionManager
     GET:@"api.openweathermap.org/data/2.5/find"
     parameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"%@",responseObject);
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
    
    //api.openweathermap.org/data/2.5/find?q=London&type=like&mode=xml
    return nil;
}

@end





















