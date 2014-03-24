//
//  CitySearchTableViewController.m
//  WindAlert
//
//  Created by Josh on 21/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "CitySearchTableViewController.h"
#import "OpenWeatherFetcher.h"
#import "FavouriteCitiesTableViewController.h"

@interface CitySearchTableViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation CitySearchTableViewController

#define MINIMUM_API_SEARCH_STRING_LENGTH 3
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text) {
        if ([searchBar.text length] >= MINIMUM_API_SEARCH_STRING_LENGTH) {
            [searchBar resignFirstResponder];
            [self performSearchAndUpdateTableViewWithSearchString:searchBar.text];
        } else {
            [self indicateErrorForSearchBar:searchBar];
        }
    }
}

- (void)performSearchAndUpdateTableViewWithSearchString:(NSString *)searchString
{
    if ([searchString length] >= MINIMUM_API_SEARCH_STRING_LENGTH) {
        __weak CitySearchTableViewController *weakSelf = self;
        [OpenWeatherFetcher citiesForSearchString:searchString
                            withCompletionHandler:^(NSArray *cities) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    weakSelf.searchResults = cities;
                                });
                            }];
    }
}

- (void)indicateErrorForSearchBar:(UISearchBar *)searchBar
{
    searchBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text length] >= MINIMUM_API_SEARCH_STRING_LENGTH)
    {
        searchBar.barTintColor = nil;
    }
}

- (void)setSearchResults:(NSArray *)searchResults
{
    [self.tableView beginUpdates];
    NSMutableArray *cities = [_searchResults mutableCopy];
    
    //first remove search results not in the new set
    NSIndexSet *removedCityIndexes = [cities indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ![searchResults containsObject:obj];
    }];
    [cities removeObjectsAtIndexes:removedCityIndexes];
    _searchResults = cities;
    
    //then animate the deletions
    NSMutableArray *removedCityIndexPaths = [[NSMutableArray alloc] init];
    [removedCityIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [removedCityIndexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    
    [self.tableView deleteRowsAtIndexPaths:removedCityIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //now add search results which are in the new set
    NSMutableArray *newCities = [searchResults mutableCopy];
    [newCities removeObjectsInArray:_searchResults];
    
    _searchResults = searchResults;
    
    //then animate the insertions
    NSIndexSet *addedCityIndexes = [_searchResults indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [newCities containsObject:obj];
    }];
    NSMutableArray *addedCityIndexPaths = [[NSMutableArray alloc] init];
    [addedCityIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [addedCityIndexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    
    [self.tableView insertRowsAtIndexPaths:addedCityIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    //[self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Location";
}

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
- (void)viewWillAppear:(BOOL)animated
{
    self.searchBar.delegate = self;
    if (SYSTEM_VERSION_LESS_THAN(@"7_0")) {
        self.searchBar.tintColor = self.navigationController.navigationBar.tintColor;
    }
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Search City Cell"
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    
    NSDictionary *city = self.searchResults[indexPath.row];
    cell.textLabel.text = [city valueForKeyPath:KEY_FOR_CITY_NAME];
    cell.detailTextLabel.text = [city valueForKeyPath:KEY_FOR_COUNTRY_NAME];
    
    return cell;
}

- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[FavouriteCitiesTableViewController class]]) {
            NSDictionary *city = self.searchResults[[self.tableView indexPathForCell:sender].row];
            [(FavouriteCitiesTableViewController *)segue.destinationViewController addCity:city];
        }
    }
}

@end
