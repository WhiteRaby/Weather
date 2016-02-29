//
//  WECity.h
//  WeatherForEveryone
//
//  Created by Alexandr on 25.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WECity : NSObject <NSCoding>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) NSString *temperature;
@property (strong, nonatomic) NSString *weather;
@property (strong, nonatomic) NSString *weatherIcon;
@end
