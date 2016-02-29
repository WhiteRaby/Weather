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
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
    
    self.cities = [NSMutableArray array];
    [self loadData];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCityAction:)];
    
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadAllAction:)];
    
    self.navigationItem.rightBarButtonItem = addItem;
    self.navigationItem.leftBarButtonItem = reloadItem;
    
    self.title = @"Cities";
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
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
        
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //    [weekSelf saveData];
        //});
    }];
    
    [self.navigationController pushViewController:searchController animated:YES];
}

- (void)reloadAllAction:(id)sender {
    
    for (NSInteger i = 0; i < self.cities.count; i++) {
        
        [self reloadCityAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
}

- (void)saveData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.cities];
    [defaults setObject:data forKey:@"Cities"];
    [defaults synchronize];
}

- (void)loadData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"Cities"];
    if (data) {
        self.cities = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
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
         [weekSelf saveData];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.cities removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        
        [self saveData];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.f;
}


@end
