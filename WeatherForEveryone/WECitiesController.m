//
//  WECitiesController.m
//  WeatherForEveryone
//
//  Created by Alexandr on 25.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "WECitiesController.h"
#import "WESearchController.h"
#import "WECity.h"
#import "WECityCell.h"
#import "WEServerManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface WECitiesController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cities;
@end

@implementation WECitiesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.cities = [NSMutableArray array];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCityAction:)];
    
    self.navigationItem.rightBarButtonItem = addItem;
    
    self.title = @"Cities";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Actions

- (void)addCityAction:(id)sender {
    
    __weak WECitiesController *weekSelf = self;
    
    WESearchController *searchController = [[WESearchController alloc] initWithCompletion:^(WECity *city) {
        
        [weekSelf.cities addObject:city];
        [weekSelf.tableView beginUpdates];
        [weekSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weekSelf.cities.count-1 inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationNone];
        [weekSelf.tableView endUpdates];
        
        [weekSelf reloadCityAtIndexPath:[NSIndexPath indexPathForRow:weekSelf.cities.count-1 inSection:0]];
    }];
    
    [self.navigationController pushViewController:searchController animated:YES];
}

- (void)reloadCityAtIndexPath:(NSIndexPath*)indexPath {
    
    __weak WECitiesController *weekSelf = self;
    
    WECity *city = [self.cities objectAtIndex:indexPath.row];
    [[WEServerManager sharedManager]
     updateWeatherForCity:city
     atIndexPath:nil
     success:^(NSIndexPath *indexPathnew) {
         [weekSelf.tableView beginUpdates];
         [weekSelf.tableView reloadRowsAtIndexPaths:@[indexPath]
                                   withRowAnimation:UITableViewRowAnimationFade];
         [weekSelf.tableView endUpdates];
     } failure:^(NSError *error) {
         NSLog(@"Reload City at indexPath: %@", error);
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cities.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"CityCell";
    
    WECityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[WECityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    WECity *city = [self.cities objectAtIndex:indexPath.row];
    cell.cityNameLabel.text = city.name; //[NSString stringWithFormat:@"%@, %@", city.name, city.country];
    cell.weatherLabel.text = city.weather;
    cell.temperatureLabel.text = city.temperature;
    
    if (city.weatherIcon) {
        __weak WECityCell *weekCell = cell;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:
                                  [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", city.weatherIcon]]];
        
        [cell.weatherImageView
         setImageWithURLRequest:request
         placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
             weekCell.weatherImageView.image = image;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            weekCell.weatherImageView.image = nil;
        }];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.f;
}


@end
