//
//  ForecastsForDayTableViewCell.m
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "ForecastsForDayTableViewCell.h"
#import "HourlyWindView.h"
#import "OpenWeatherFetcher.h"
#import "OpenWeatherFetcherHelper.h"

@interface ForecastsForDayTableViewCell ()

@property (weak, nonatomic) IBOutlet WindView *wind;
@property (strong, nonatomic) IBOutletCollection(HourlyWindView) NSArray *hourlyWindViews;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noForecastsLabel;

@end

@implementation ForecastsForDayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self updateUI];
        [self showHourlyForecasts:NO];
    }
    return self;
}

- (void)awakeFromNib
{
    [self updateUI];
    [self showHourlyForecasts:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setForecasts:(DayForecasts *)dayForecasts
{
    _forecasts = dayForecasts;
    [self updateUI];
    [self showHourlyForecasts:NO];
}

- (void)updateUI
{
    self.wind.speed = [self.forecasts.dayForecast valueForKeyPath:KEY_FOR_WIND_SPEED];
    self.wind.direction = [OpenWeatherFetcherHelper cardinalDirectionForDegrees:[self.forecasts.dayForecast valueForKeyPath:KEY_FOR_WIND_DIRECTION]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE, dd MMMM" options:0 locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:dateFormat];
    
    self.dateLabel.text = [dateFormatter stringFromDate:self.forecasts.forecastDate];
    
    //add all the 3 hourly forecasts
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    for (NSInteger i = 0; i < [self.forecasts.threeHourlyForecasts count]; i++) {
        NSDictionary *forecast = self.forecasts.threeHourlyForecasts[i];
        
        NSDate *forecastDate = [forecast valueForKeyPath:@"datetime"];
        HourlyWindView *view = self.hourlyWindViews[i];
        view.timeLabel.text = [timeFormatter stringFromDate:forecastDate];
        
        view.windView.speed = [forecast valueForKeyPath:KEY_FOR_WIND_SPEED];
        view.windView.direction = [OpenWeatherFetcherHelper cardinalDirectionForDegrees:[forecast valueForKeyPath:KEY_FOR_WIND_DIRECTION]];
    }
}

- (void)showHourlyForecasts:(BOOL)show
{
    if ([self.forecasts.threeHourlyForecasts count] > 0) {
        if (show) {
            for (NSInteger i = 0; i < [self.forecasts.threeHourlyForecasts count]; i++) {
                //Add an HourlyWindView to the contentView and the collection
                CGRect frame = CGRectMake(i * 38 + 2, 51, 36, 61);
                HourlyWindView *newView = [[HourlyWindView alloc] initWithFrame:frame];
                
                [self.contentView addSubview:newView];
                self.hourlyWindViews = [self.hourlyWindViews arrayByAddingObject:newView];
            }
        } else {
            [self.hourlyWindViews valueForKey:@"removeFromSuperview"];
        }
        
        [self.noForecastsLabel setHidden:YES];
    } else {
        [self.noForecastsLabel setHidden:!show];
    }
}

- (void)resetForecasts
{
    self.dateLabel.text = nil;
    [self.wind reset];
    
    [self.hourlyWindViews valueForKey:@"removeFromSuperview"];
}

@end
