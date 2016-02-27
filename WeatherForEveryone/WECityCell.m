//
//  WECityCell.m
//  WeatherForEveryone
//
//  Created by Alexandr on 26.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "WECityCell.h"

@implementation WECityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadViews];
        [self loadConstraint];
    }
    return self;
}

- (void) loadViews {
    
    self.cityNameLabel = [[UILabel alloc] init];
    self.cityNameLabel.font = [UIFont systemFontOfSize:27.f];
    self.cityNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.cityNameLabel];
    
    self.weatherLabel = [[UILabel alloc] init];
    self.weatherLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.weatherLabel];
    
    self.temperatureLabel = [[UILabel alloc] init];
    self.temperatureLabel.font = [UIFont systemFontOfSize:50.f];
    self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.temperatureLabel];
    
    self.weatherImageView = [[UIImageView alloc] init];
    self.weatherImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.weatherImageView];
}

- (void)loadConstraint {
    
    NSDictionary *views = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.cityNameLabel, @"city",
                           self.weatherLabel , @"weathr",
                           self.temperatureLabel, @"temperature",
                           self.weatherImageView, @"weatherImage", nil];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[city(>=0)]-(>=2)-[temperature(>=0)]-(<=20,>=10)-[weatherImage(60)]-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[weathr(>=0)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[city(30)]-[weathr(20)]"
                                             options:NSLayoutFormatAlignAllRight
                                             metrics:nil
                                               views:views]];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[temperature(70)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[weatherImage(60)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.temperatureLabel
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.f
                                   constant:0.f]];
    
    [self.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.weatherImageView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.f
                                   constant:0.f]];
}

@end
