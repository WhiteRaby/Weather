//
//  WEServerManager.h
//  WeatherForEveryone
//
//  Created by Alexandr on 25.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEServerManager : NSObject

+ (WEServerManager*)sharedManager;

- (void)getCitysWeatherWithName:(NSString*)name
                        success:(void(^)(id city))success
                        failure:(void(^)(NSError *error))failure;

@end
