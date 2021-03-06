//
//  FavouriteCitiesTableViewController.m
//  WindAlert
//
//  Created by Josh on 21/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "FavouriteCitiesTableViewController.h"
#import "OpenWeatherFetcher.h"
#import "OpenWeatherFetcherHelper.h"
#import "City.h"
#import "ForecastsForCityTableViewController.h"
#import "CityCurrentWeatherTableViewCell.h"

@interface FavouriteCitiesTableViewController () <CityDelegate>

@property (strong, nonatomic) NSArray* favouriteCities; //of City
@property (strong, nonatomic) NSArray* completedRefreshing; //of City

@end

@implementation FavouriteCitiesTableViewController

#define FAVOURITE_CITIES_USER_DEFAULTS_KEY @"WindAlertFavouriteCities"
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = @"Favourite Locations";
    [self loadCitiesFromDefaults];
}


#pragma mark - Setting up data source
- (void)loadCitiesFromDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *cities = [defaults objectForKey:FAVOURITE_CITIES_USER_DEFAULTS_KEY];
    
    for (NSDictionary *cityDictionary in cities) {
        [self addCity:cityDictionary];
    }
}

- (void)addCity:(NSDictionary *)city
{
    if (![self.favouriteCities containsObject:city]) {
        NSMutableArray *cities = [[NSArray arrayWithArray:self.favouriteCities] mutableCopy];
        City *newCity = [City cityWithCityDictionary:city notifyDelegateOfUpdates:self];
        [cities addObject:newCity];
        self.favouriteCities = cities;
        
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

#define KEY_FOR_CURRENT_WEATHER @"currentWeather"
- (void)setFavouriteCities:(NSArray *)favouriteCities
{
    if (self.favouriteCities) {
        [self.favouriteCities removeObserver:self
                        fromObjectsAtIndexes:[self indexSetForAllFavouriteCities]
                                  forKeyPath:KEY_FOR_CURRENT_WEATHER];
    }
    
    _favouriteCities = favouriteCities;
    [self saveCitiesToDefaults:favouriteCities];
    
    [self.favouriteCities addObserver:self toObjectsAtIndexes:[self indexSetForAllFavouriteCities] forKeyPath:KEY_FOR_CURRENT_WEATHER options:0 context:NULL];
}

- (NSIndexSet *)indexSetForAllFavouriteCities
{
    return [self.favouriteCities indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return YES;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:KEY_FOR_CURRENT_WEATHER]) {
        //object contains the city we need to reload
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

- (void)saveCitiesToDefaults:(NSArray *)cities
{
    NSArray *dictionaryArray = [cities valueForKey:NSStringFromSelector(@selector(createCityDictionary))];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dictionaryArray forKey:FAVOURITE_CITIES_USER_DEFAULTS_KEY];
    [defaults synchronize];
}

#pragma mark - Refreshing current wind conditions
- (void)prepareForUpdate
{
    [self.refreshControl beginRefreshing];
    //Clear out completedRefreshing - refreshing will end when all cities are added to completedRefreshing
    self.completedRefreshing = [[NSArray alloc] init];
}

- (IBAction)refreshCurrentWeather:(id)sender {
    [self prepareForUpdate];
    for (City *city in self.favouriteCities) {
        [city refreshData];
    }
}

- (void)currentWeatherDidFinishUpdatingForCity:(City *)city
{
    NSMutableArray *completedRefreshing = [self.completedRefreshing mutableCopy];
    [completedRefreshing addObject:city];
    self.completedRefreshing = completedRefreshing;
}

- (void)setCompletedRefreshing:(NSArray *)completedRefreshing
{
    _completedRefreshing = completedRefreshing;
    
    NSSet *allForecasts = [NSSet setWithArray:self.favouriteCities];
    NSSet *refreshedForecasts = [NSSet setWithArray:self.completedRefreshing];
    
    if ([refreshedForecasts isEqualToSet:allForecasts]) {
        [self.refreshControl endRefreshing];
    }
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
    return [self.favouriteCities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityCurrentWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Favourite City Cell" forIndexPath:indexPath];
    
    City *city = self.favouriteCities[indexPath.row];
    cell.cityLabel.text = city.name;
    cell.countryLabel.text = city.country;
    
    if (city.currentWeather) {
        cell.wind.speed = [city.currentWeather valueForKeyPath:KEY_FOR_WIND_SPEED];
        cell.wind.direction = [OpenWeatherFetcherHelper cardinalDirectionForDegrees:[city.currentWeather valueForKeyPath:KEY_FOR_WIND_DIRECTION]];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *cities = [self.favouriteCities mutableCopy];
        [cities removeObjectAtIndex:indexPath.row];
        self.favouriteCities = cities;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } 
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"View Forecasts For City"]) {
        if ([segue.destinationViewController isKindOfClass:[ForecastsForCityTableViewController class]]) {
            ForecastsForCityTableViewController *dvc = segue.destinationViewController;
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                dvc.city = self.favouriteCities[[self.tableView indexPathForCell:sender].row];
            }
        }
    }
}

- (IBAction)addedCity:(UIStoryboardSegue *)segue
{
    //this is an unwind segue
}

- (void)dealloc
{
    if (self.favouriteCities) {
        [self.favouriteCities removeObserver:self
                        fromObjectsAtIndexes:[self indexSetForAllFavouriteCities]
                                  forKeyPath:KEY_FOR_CURRENT_WEATHER];
    }
}

@end
