//
//  WECity.m
//  WeatherForEveryone
//
//  Created by Alexandr on 25.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "WECity.h"

@implementation WECity

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.country forKey:@"country"];
    [encoder encodeObject:self.cityID forKey:@"cityID"];
    [encoder encodeObject:self.temperature forKey:@"temperature"];
    [encoder encodeObject:self.weather forKey:@"weather"];
    [encoder encodeObject:self.weatherIcon forKey:@"weatherIcon"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.name = [decoder decodeObjectForKey:@"name"];
    self.country = [decoder decodeObjectForKey:@"country"];
    self.cityID = [decoder decodeObjectForKey:@"cityID"];
    self.temperature = [decoder decodeObjectForKey:@"temperature"];
    self.weather = [decoder decodeObjectForKey:@"weather"];
    self.weatherIcon = [decoder decodeObjectForKey:@"weatherIcon"];

    return self;
}

@end
