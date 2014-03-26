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
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noForecastsLabel;
@property (weak, nonatomic) IBOutlet UIView *extendedCellView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *hourlyWindViews;

@end

@implementation ForecastsForDayTableViewCell

#define KEY_FOR_DAY_FORECAST @"dayForecast"
- (void)setForecasts:(DayForecasts *)dayForecasts
{
    if (_forecasts) {
        [self.forecasts removeObserver:self forKeyPath:KEY_FOR_DAY_FORECAST];
    }
    
    _forecasts = dayForecasts;
    [self.forecasts addObserver:self forKeyPath:KEY_FOR_DAY_FORECAST options:0 context:NULL];
    
    //update here as the observer is only used to detect changes to the forecast data held within dayForecasts, which will only change when data has been fetched, i.e. on load and user refresh.
    [self updateCell];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:KEY_FOR_DAY_FORECAST]) {
        [self updateForecasts];
    }
}

- (void)updateCell
{
    [self updateForecasts];
    [self updateDateLabel];
}

- (void)updateForecasts
{
    self.wind.direction = [OpenWeatherFetcherHelper cardinalDirectionForDegrees:[self.forecasts.dayForecast valueForKeyPath:KEY_FOR_WIND_DIRECTION]];
    self.wind.speed = [self.forecasts.dayForecast valueForKeyPath:KEY_FOR_WIND_SPEED];
}

- (void)updateDateLabel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE, dd MMMM" options:0 locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:dateFormat];
    
    self.dateLabel.text = [dateFormatter stringFromDate:self.forecasts.forecastDate];
}

- (void)showHourlyForecasts:(BOOL)show
{
    if ([self.forecasts.threeHourlyForecasts count] > 0) {
        if (show) {
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
            
            for (NSInteger i = 0; i < [self.forecasts.threeHourlyForecasts count]; i++) {
                NSDictionary *forecast = self.forecasts.threeHourlyForecasts[i];
                
                HourlyWindView *forecastView = self.hourlyWindViews[i];
                NSDate *forecastDate = [forecast valueForKeyPath:@"datetime"];
                forecastView.timeLabel.text = [timeFormatter stringFromDate:forecastDate];
                
                forecastView.windView.speed = [forecast valueForKeyPath:KEY_FOR_WIND_SPEED];
                forecastView.windView.direction = [OpenWeatherFetcherHelper cardinalDirectionForDegrees:[forecast valueForKeyPath:KEY_FOR_WIND_DIRECTION]];
            }
        }
        
        [self.extendedCellView setHidden:!show];
        [self.noForecastsLabel setHidden:YES];
    } else {
        [self.extendedCellView setHidden:!show];
        [self.noForecastsLabel setHidden:!show];
    }
}

- (void)resetForecasts
{
    [self.wind reset];
    for (HourlyWindView *hwv in self.hourlyWindViews) {
        [hwv.windView reset];
    }
}

- (void)dealloc
{
    if (self.forecasts) {
        [self.forecasts removeObserver:self forKeyPath:KEY_FOR_DAY_FORECAST];
    }
}

@end
