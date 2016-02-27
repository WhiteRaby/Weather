//
//  WESearchController.m
//  WeatherForEveryone
//
//  Created by Alexandr on 25.02.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "WESearchController.h"
#import "WEServerManager.h"
#import "WECity.h"

@interface WESearchController () <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *cities;
@property (assign, nonatomic) BOOL canResign;
@end

@implementation WESearchController

#define LABEL_TAG 1

#pragma mark - Public Methods

- (instancetype)initWithCompletion:(completionBlock)completion {
    self = [super init];
    if (self) {
        
        self.completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Search Cities";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShowNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    self.canResign = NO;
    
    [self loadTableView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.searchController.view removeFromSuperview];
}

- (void)loadTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.canResign) {
        [self.searchController.searchBar resignFirstResponder];
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    if (searchController.searchBar.text.length >= 3) {
        
        __weak WESearchController *weekSelf = self;
        NSString *searchBarText = searchController.searchBar.text;
        
        [[WEServerManager sharedManager]
         getCitiesWithName:searchController.searchBar.text
         success:^(NSArray *cities, NSString *searchName) {
             if ([searchController.searchBar.text isEqualToString:searchBarText]) {
                 weekSelf.cities = cities;
                 [weekSelf.tableView reloadData];
             }
         }
         failure:^(NSError *error) {
             NSLog(@"%@", error);
         }];
    } else {
        self.cities = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    self.cities = nil;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"SearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        
        CGRect labelFrame = CGRectMake(cell.contentView.bounds.size.width - 200, 10,
                                       180, cell.contentView.bounds.size.height - 20);
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.textAlignment = NSTextAlignmentRight;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        label.tag = LABEL_TAG;
        [cell.contentView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button setUserInteractionEnabled:NO];
        cell.accessoryView = button;
    }
    
    WECity *city = [self.cities objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    UILabel *label = [cell viewWithTag:LABEL_TAG];
    label.text = city.country;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.completion) {
        self.completion([self.cities objectAtIndex:indexPath.row]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notifications

- (void)keyboardHideNotification:(NSNotification*)notification {
    
    self.canResign = NO;
}

- (void)keyboardShowNotification:(NSNotification*)notification {
    
    self.canResign = YES;
}


@end
