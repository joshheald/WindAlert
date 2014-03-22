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
    //Update NSUserDefaults here (or in the setter?)
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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Favourite City Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    City *city = self.favouriteCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    if (city.currentWeather) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"S: %@, D: %d", [city.currentWeather valueForKeyPath:KEY_FOR_WIND_SPEED], [OpenWeatherFetcherHelper cardinalDirectionForDegrees:[city.currentWeather valueForKeyPath:KEY_FOR_WIND_DIRECTION]]];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
*/


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
