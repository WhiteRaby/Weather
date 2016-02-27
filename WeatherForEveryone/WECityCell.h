//
//  WECityCell.h
//  WeatherForEveryone
//
//  Created by Alexandr on 26.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WECityCell : UITableViewCell

@property (strong, nonatomic) UILabel *cityNameLabel;
@property (strong, nonatomic) UILabel *weatherLabel;
@property (strong, nonatomic) UILabel *temperatureLabel;
@property (strong, nonatomic) UIImageView *weatherImageView;

@end
