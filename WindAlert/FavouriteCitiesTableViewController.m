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

@interface FavouriteCitiesTableViewController ()

@property (strong, nonatomic) NSArray* favouriteCities;

@end

@implementation FavouriteCitiesTableViewController

- (IBAction)addedCity:(UIStoryboardSegue *)segue
{
    //this is an unwind segue
}

- (void)addCity:(NSDictionary *)city
{
    if (![self.favouriteCities containsObject:city]) {
        NSMutableArray *cities = [[NSArray arrayWithArray:self.favouriteCities] mutableCopy];
        City *newCity = [City cityWithCityDictionary:city];
        [cities addObject:newCity];
        self.favouriteCities = cities;
        NSIndexSet *allIndexes = [self.favouriteCities indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return YES;
        }];
        [self.favouriteCities addObserver:self toObjectsAtIndexes:allIndexes forKeyPath:@"currentWeather" options:0 context:NULL];
        [self.tableView reloadData];
    }
}

#define FAVOURITE_CITIES_USER_DEFAULTS_KEY @"WindAlertFavouriteCities"
- (void)setFavouriteCities:(NSArray *)favouriteCities
{
    _favouriteCities = favouriteCities;
    [self saveCitiesToDefaults:favouriteCities];
}

- (void)saveCitiesToDefaults:(NSArray *)cities
{
    NSArray *dictionaryArray = [cities valueForKey:@"createCityDictionary"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dictionaryArray forKey:FAVOURITE_CITIES_USER_DEFAULTS_KEY];
    [defaults synchronize];
}

- (void)loadCitiesFromDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *cities = [defaults objectForKey:FAVOURITE_CITIES_USER_DEFAULTS_KEY];
    
    for (NSDictionary *cityDictionary in cities) {
        [self addCity:cityDictionary];
    }
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = @"Favourite Locations";
    [self loadCitiesFromDefaults];
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
    return [self.favouriteCities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityCurrentWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Favourite City Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    City *city = self.favouriteCities[indexPath.row];
    cell.cityLabel.text = city.name;
    cell.countryLabel.text = city.country;
    
    if (city.currentWeather) {
        cell.wind.speed = [city.currentWeather valueForKeyPath:KEY_FOR_WIND_SPEED];
        cell.wind.direction = [OpenWeatherFetcherHelper cardinalDirectionForDegrees:[city.currentWeather valueForKeyPath:KEY_FOR_WIND_DIRECTION]];
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableArray *cities = [self.favouriteCities mutableCopy];
        [cities removeObjectAtIndex:indexPath.row];
        self.favouriteCities = cities;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } 
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"View Forecasts For City"]) {
        //set the cityID and set it off.
        if ([segue.destinationViewController isKindOfClass:[ForecastsForCityTableViewController class]]) {
            ForecastsForCityTableViewController *dvc = segue.destinationViewController;
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                dvc.city = self.favouriteCities[[self.tableView indexPathForCell:sender].row];
            }
        }
    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"currentWeather"]) {
        //object contains the city we need to reload
        [self.tableView reloadData];
    }
}
@end
