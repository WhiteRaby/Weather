//
//  WEServerManager.m
//  WeatherForEveryone
//
//  Created by Alexandr on 25.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "WEServerManager.h"
#import <AFNetworking.h>
#import "WECity.h"

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

- (void)getCitiesWithName:(NSString*)name
                        success:(void(^)(NSArray *cities, NSString *searchName))success
                        failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                name, @"q",
                                @"like", @"type",
                                @"JSON", @"mode",
                                APIKey, @"APPID", nil];
    
    [self.sessionManager
     GET:@"http://api.openweathermap.org/data/2.5/find"
     parameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {         
         NSMutableArray *cities = [NSMutableArray array];
         
         for (NSDictionary *dict in responseObject[@"list"]) {
             
             WECity *city = [[WECity alloc] init];
             city.name = [dict objectForKey:@"name"];
             city.country = [[dict objectForKey:@"sys"] objectForKey:@"country"];
             city.cityID = [[dict objectForKey:@"id"] stringValue];
             if (![city.cityID isEqualToString:@"0"] && ![city.name isEqualToString:@""] && ![city.country isEqualToString:@""]) {
                 [cities addObject:city];
             }
             //NSLog(@"%@ %@ %@", city.name, city.cityID, [dict objectForKey:@"id"]);
         }
         if (success) {
             success(cities, name);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (failure) {
             failure(error);
         } else {
             NSLog(@"%@",error);
         }
     }];
}

- (void)updateWeatherForCity:(WECity*)city
                 atIndexPath:(NSIndexPath*)indexPath
                     success:(void(^)(NSIndexPath* indexPath))success
                     failure:(void(^)(NSError *error))failure {
    
    NSLog(@"updating");
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                city.cityID, @"id",
                                APIKey, @"APPID", nil];
 
    [self.sessionManager
     GET:@"http://api.openweathermap.org/data/2.5/weather"
     parameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         //NSLog(@"%@, %@", responseObject, city.cityID);
         CGFloat temperature = [[[responseObject objectForKey:@"main"] objectForKey:@"temp"] floatValue];
         temperature -= 273.15f;
         city.temperature = [NSString stringWithFormat:@"%0.0f°", temperature];
         city.weather = [[[responseObject objectForKey:@"weather"] firstObject] objectForKey:@"description"];
         city.weatherIcon = [[[responseObject objectForKey:@"weather"] firstObject] objectForKey:@"icon"];
         
         if (success) {
             success(indexPath);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         } else {
             NSLog(@"%@", error);
         }
     }];
}
    
@end





















