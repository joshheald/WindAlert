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

@interface ForecastsForCityTableViewController () <DayForecastsDelegate>

@property (strong, nonatomic) NSArray *dayForecasts; //of DayForecasts
@property (strong, nonatomic) NSArray *completedRefreshing; //of DayForecasts
@property (strong, nonatomic) NSIndexPath *indexPathOfPreviousSelection;

@end

@implementation ForecastsForCityTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self createDayForecasts];
}

#define DAY_LENGTH 86400
- (void)createDayForecasts
{
    NSMutableArray *datesForForecasts = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < MAX_DAILY_FORECAST_DAYS; i++) {
        [datesForForecasts addObject:[NSDate dateWithTimeIntervalSinceNow:i * DAY_LENGTH]];
    }
    
    NSMutableArray *dayForecasts = [[NSMutableArray alloc] initWithCapacity:[datesForForecasts count]];
    for (NSDate *date in datesForForecasts) {
        DayForecasts *forecast = [DayForecasts dayForecastsWithCityID:[self.city valueForKey:@"cityID"] forDate:date notifyDelegateOfUpdates:self];
        [dayForecasts addObject:forecast];
    }
    self.dayForecasts = dayForecasts;
    
    [self prepareForUpdate];
    if (self.tableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
        } completion:^(BOOL finished){}];
    }
}

- (void)prepareForUpdate
{
    [self.refreshControl beginRefreshing];
    //Clear out completedRefreshing - refreshing will end when all forecasts are added to completedRefreshing
    self.completedRefreshing = [[NSArray alloc] init];
}

- (IBAction)refreshForecasts:(id)sender {
    [self prepareForUpdate];
    for (DayForecasts *dayForecasts in self.dayForecasts) {
        [dayForecasts refreshData];
    }
}

- (void)setCompletedRefreshing:(NSArray *)completedRefreshing
{
    _completedRefreshing = completedRefreshing;
    
    NSSet *allForecasts = [NSSet setWithArray:self.dayForecasts];
    NSSet *refreshedForecasts = [NSSet setWithArray:self.completedRefreshing];
    
    if ([refreshedForecasts isEqualToSet:allForecasts]) {
        [self.refreshControl endRefreshing];
    }
}

- (void)dayForecastsDidFinishUpdating:(DayForecasts *)dayForecasts
{
    NSMutableArray *completedRefreshing = [self.completedRefreshing mutableCopy];
    [completedRefreshing addObject:dayForecasts];
    self.completedRefreshing = completedRefreshing;
}

- (void)setCity:(NSDictionary *)city
{
    _city = city;
    self.title = [city valueForKey:@"name"];
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
