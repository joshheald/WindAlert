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
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation CitySearchTableViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    [self.spinner setHidesWhenStopped:YES];
    
    self.searchBar.delegate = self;
    if (![self.searchBar respondsToSelector:@selector(barTintColor)]) {
        self.searchBar.tintColor = self.navigationController.navigationBar.tintColor;
    }
    [self.searchBar becomeFirstResponder];
}

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
        [self.spinner startAnimating];
        __weak CitySearchTableViewController *weakSelf = self;
        [OpenWeatherFetcher citiesForSearchString:searchString
                            withCompletionHandler:^(NSArray *cities) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    weakSelf.searchResults = cities;
                                    [weakSelf.spinner stopAnimating];
                                });
                            }];
    }
}

- (void)indicateErrorForSearchBar:(UISearchBar *)searchBar
{
    UIColor *errorColour = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    
    if ([searchBar respondsToSelector:@selector(barTintColor)]) {
        searchBar.barTintColor = errorColour;
    } else {
        searchBar.tintColor = errorColour;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self resetErrorForSearchBar:searchBar];
}

- (void)resetErrorForSearchBar:(UISearchBar *)searchBar
{
    if ([searchBar.text length] >= MINIMUM_API_SEARCH_STRING_LENGTH ||
        [searchBar.text length] == 0)
    {
        if ([searchBar respondsToSelector:@selector(barTintColor)]) {
            searchBar.barTintColor = nil;
        } else {
            searchBar.tintColor = self.navigationController.navigationBar.tintColor;
        }
    }
}

- (void)setSearchResults:(NSArray *)searchResults
{
    _searchResults = searchResults;
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Search results - %lu", (unsigned long)[self.searchResults count]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Search City Cell"
                                                            forIndexPath:indexPath];
    
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
