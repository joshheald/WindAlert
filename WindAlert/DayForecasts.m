//
//  DayForecasts.m
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "DayForecasts.h"
#import "OpenWeatherFetcher.h"

@interface DayForecasts ()

@property (strong, nonatomic, readwrite) NSNumber *cityID;
@property (strong, nonatomic, readwrite) NSDate *forecastDate;

@property (strong, nonatomic) NSDictionary *dayForecast;
@property (strong, nonatomic) NSArray *threeHourlyForecasts;

@end

@implementation DayForecasts

+ (DayForecasts *)dayForecastsWithCityID:(NSNumber *)cityID forDate:(NSDate *)forecastDate
{
    DayForecasts *dayForecasts;
    
    if (cityID && forecastDate) {
        dayForecasts = [[DayForecasts alloc] initWithCityID:cityID forDate:forecastDate];
    }
    
    return dayForecasts;
}

- (instancetype)initWithCityID:(NSNumber *)cityID forDate:(NSDate *)forecastDate
{
    self = [super init];
    
    _cityID = cityID;
    _forecastDate = forecastDate;
    
    [self updateDayForecast];
    [self update3HourlyForecasts];
    
    return self;
}

- (void)updateDayForecast
{
    __weak DayForecasts *weakSelf = self;
    [OpenWeatherFetcher dailyForecastWindDataForCityWithID:self.cityID
                                                    onDate:self.forecastDate
                                     withCompletionHandler:^(NSDictionary *dailyForecast) {
                                         weakSelf.dayForecast = dailyForecast;
                                     }];
}

- (void)update3HourlyForecasts
{
    __weak DayForecasts *weakSelf = self;
    [OpenWeatherFetcher threeHourlyForecastWindDataForCityWithID:self.cityID
                                                          onDate:self.forecastDate
                                           withCompletionHandler:^(NSArray *threeHourlyForecasts) {
                                               weakSelf.threeHourlyForecasts = threeHourlyForecasts;
                                           }];
}

@end
