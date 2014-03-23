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
                                               if ([threeHourlyForecasts count] == 8) {
                                                   weakSelf.threeHourlyForecasts = threeHourlyForecasts;
                                               } else if ([threeHourlyForecasts count] > 0) {
                                                   // pad at the beginnning or end
                                                   // determine the time of the first available forecast
                                                   NSDate *forecastTime = [[threeHourlyForecasts firstObject] valueForKeyPath:@"datetime"];
                                                   
                                                   NSCalendar *calendar = [NSCalendar currentCalendar];
                                                   NSDateComponents *components = [calendar components:(NSDayCalendarUnit |
                                                                                                        NSMonthCalendarUnit |
                                                                                                        NSYearCalendarUnit)
                                                                                              fromDate:self.forecastDate];
                                                   
                                                   [components setHour:0];
                                                   [components setMinute:0];
                                                   [components setSecond:0];
                                                   
                                                   NSDate *midnight = [calendar dateFromComponents: components];
                                                   
                                                   NSMutableArray *threeHourlyForecastsForAllDay = [threeHourlyForecasts mutableCopy];
                                                   //add 8 - numberOfForecasts to the array
                                                   NSInteger indexToAddAt;
                                                   if ([forecastTime compare:midnight] == NSOrderedDescending) {
                                                       //add to the start
                                                       indexToAddAt = 0;
                                                   } else {
                                                       //add to the end of the array
                                                       indexToAddAt = [threeHourlyForecasts count];
                                                   }
                                                   
                                                   NSInteger forecastsToAdd = 8 - [threeHourlyForecasts count];
                                                   for (NSInteger i = forecastsToAdd-1; i >= 0; i--) {
                                                       [components setHour:(indexToAddAt+i) * 3];
                                                       NSDate *addedForecastTime = [calendar dateFromComponents:components];
                                                       [threeHourlyForecastsForAllDay insertObject:@{@"datetime": addedForecastTime,
                                                                                                     @"wind":@{}}
                                                                                           atIndex:indexToAddAt];
                                                   }
                                                   
                                                   weakSelf.threeHourlyForecasts = threeHourlyForecastsForAllDay;
                                               }
                                           }];
}

@end
