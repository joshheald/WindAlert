//
//  ForecastsForDayTableViewController.m
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "ForecastsForCityTableViewController.h"
#import "DayForecasts.h"
#import "OpenWeatherFetcher.h"
#import "ForecastsForDayTableViewCell.h"
#import "HourlyWindView.h"

@interface ForecastsForCityTableViewController ()

@property (strong, nonatomic) NSArray *dayForecasts; //of DayForecasts
@property (strong, nonatomic) NSIndexPath *indexPathOfPreviousSelection;

@end

@implementation ForecastsForCityTableViewController

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
    
    [self updateDayForecasts];
}

#define DAY_LENGTH 86400
- (void)updateDayForecasts
{
    NSMutableArray *datesForForecasts = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < MAX_DAILY_FORECAST_DAYS; i++) {
        [datesForForecasts addObject:[NSDate dateWithTimeIntervalSinceNow:i * DAY_LENGTH]];
    }
    
    NSMutableArray *dayForecasts = [[NSMutableArray alloc] initWithCapacity:[datesForForecasts count]];
    for (NSDate *date in datesForForecasts) {
        [dayForecasts addObject:[DayForecasts dayForecastsWithCityID:[self.city valueForKey:@"cityID"] forDate:date]];
    }
    self.dayForecasts = dayForecasts;
}

- (void)setCity:(NSDictionary *)city
{
    _city = city;
    self.title = [city valueForKey:@"name"];
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
    return [self.dayForecasts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForecastsForDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Forecast Day Cell" forIndexPath:indexPath];
    
    [cell resetForecasts];
    
    cell.forecasts = self.dayForecasts[indexPath.row];
    if ([indexPath compare:self.indexPathOfPreviousSelection] == NSOrderedSame)
    {
        [cell showHourlyForecasts:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *rowsToReload = [NSMutableArray arrayWithObject:indexPath];
    if ([self.indexPathOfPreviousSelection compare:indexPath] != NSOrderedSame) {
        [rowsToReload addObject:self.indexPathOfPreviousSelection];
    }
    
    self.indexPathOfPreviousSelection = indexPath;
    
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:[self.tableView indexPathForSelectedRow]] == NSOrderedSame)
    {
        return 112;
    }
    return 51;
}

@end
