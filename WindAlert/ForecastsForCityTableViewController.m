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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    // Configure the cell...
    DayForecasts *forecasts = self.dayForecasts[indexPath.row];
    cell.wind.speed = [forecasts.dayForecast valueForKeyPath:KEY_FOR_WIND_SPEED];
    cell.wind.direction = [OpenWeatherFetcherHelper cardinalDirectionForDegrees:[forecasts.dayForecast valueForKeyPath:KEY_FOR_WIND_DIRECTION]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE, dd MMMM" options:0 locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:dateFormat];
    
    cell.dateLabel.text = [dateFormatter stringFromDate:forecasts.forecastDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *rowsToReload = [NSMutableArray arrayWithObject:indexPath];
    if (self.indexPathOfPreviousSelection &&
        [indexPath compare:self.indexPathOfPreviousSelection] != NSOrderedSame) {
        [rowsToReload addObject:self.indexPathOfPreviousSelection];
    }
    
    [tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.indexPathOfPreviousSelection = indexPath;
    
    //add all the 3 hourly forecasts
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    DayForecasts *forecasts = self.dayForecasts[indexPath.row];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    for (NSInteger i = 0; i < [forecasts.threeHourlyForecasts count]; i++) {
        NSDictionary *forecast = forecasts.threeHourlyForecasts[i];
        
        CGRect frame = CGRectMake((40 * i) + 2, 51, 36, 61);
        HourlyWindView *view = [[HourlyWindView alloc] initWithFrame:frame];
        
        NSDate *forecastDate = [forecast valueForKeyPath:@"datetime"];
        view.timeLabel.text = [timeFormatter stringFromDate:forecastDate];
        
        view.windView.speed = [forecast valueForKeyPath:KEY_FOR_WIND_SPEED];
        view.windView.direction = [OpenWeatherFetcherHelper cardinalDirectionForDegrees:[forecast valueForKeyPath:KEY_FOR_WIND_DIRECTION]];
        
        [cell.contentView addSubview:view];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:[self.tableView indexPathForSelectedRow]] == NSOrderedSame)
    {
        return 112;
    }
    return 51;
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
