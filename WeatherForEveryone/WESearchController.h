//
//  WESearchController.h
//  WeatherForEveryone
//
//  Created by Alexandr on 25.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WECity;

typedef void(^completionBlock)(WECity *city);

@interface WESearchController : UIViewController

@property (copy, nonatomic) completionBlock completion;

- (instancetype)initWithCompletion:(completionBlock)completion;

@end
