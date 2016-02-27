//
//  WEServerManager.h
//  WeatherForEveryone
//
//  Created by Alexandr on 25.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WECity;

@interface WEServerManager : NSObject

+ (WEServerManager*)sharedManager;

- (void)getCitiesWithName:(NSString*)name
                        success:(void(^)(NSArray *cities, NSString *searchName))success
                        failure:(void(^)(NSError *error))failure;

- (void)updateWeatherForCity:(WECity*)city
                 atIndexPath:(NSIndexPath*)indexPath
                     success:(void(^)(NSIndexPath* indexPath))success
                     failure:(void(^)(NSError *error))failure;
@end
