//
//  OpenWeatherFetcherHelper.m
//  WindAlert
//
//  Created by Josh on 20/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "OpenWeatherFetcherHelper.h"

@interface OpenWeatherFetcherHelper ()

+ (NSDictionary *)propertyListFromJSONData:(NSData *)data;
+ (NSDictionary *)dictionaryFromPropertyList:(NSDictionary *)propertyList withKeys:(NSArray*)keys forValuesAtKeyPaths:(NSArray *)KeyPaths;
+ (NSDictionary *)windForecastFromForecast:(NSDictionary *)forecast withDirectionKey:(NSString *)directionKey andSpeedKey:(NSString *)speedKey;
+ (NSArray *)allForecastsInWeatherData:(NSData *)weatherData onDate:(NSDate *)date;
+ (BOOL)date:(NSDate *)date1 isTheSameDayAsAnotherDate:(NSDate *)date2;

@end

@implementation OpenWeatherFetcherHelper

+ (NSDictionary *)currentWindFromWeatherData:(NSData *)weatherData
{
    NSDictionary *currentWind;
    
    if (weatherData) {
        NSDictionary *currentWeatherConditions = [self propertyListFromJSONData:weatherData];
        
        currentWind = [self windForecastFromForecast:currentWeatherConditions
                                    withDirectionKey:@"wind.deg"
                                         andSpeedKey:@"wind.speed"];
    }
    
    return currentWind;
}

+ (NSDictionary *)dailyForecastWindFromWeatherData:(NSData *)weatherData forDate:(NSDate *)date
{
    NSDictionary *dailyForecast;
    
    if (weatherData) {
        NSArray *allForecasts = [self allForecastsInWeatherData:weatherData onDate:date];
        
        if ([allForecasts count] == 1) {
            dailyForecast = [self windForecastFromForecast:allForecasts[0]
                                          withDirectionKey:@"deg"
                                               andSpeedKey:@"speed"];
        }
    }
    
    return dailyForecast;
}

+ (NSArray *)threeHourlyForecastWindFromWeatherData:(NSData *)weatherData forDate:(NSDate *)date
{
    NSMutableArray *forecasts;
    
    if (weatherData) {
        NSArray *forecastsForSpecifiedDate = [self allForecastsInWeatherData:weatherData onDate:date];
        
        if (forecastsForSpecifiedDate) {
            forecasts = [[NSMutableArray alloc] init];
            
            for (NSDictionary *forecast in forecastsForSpecifiedDate) {
                [forecasts addObject:[self windForecastFromForecast:forecast
                                                   withDirectionKey:@"wind.deg"
                                                        andSpeedKey:@"wind.speed"]];
            }
        }
    }
    
    return forecasts;
}

+ (NSArray *)citiesFromCitySearchData:(NSData *)cityData
{
    NSArray *cityList = [[self propertyListFromJSONData:cityData] valueForKeyPath:@"list"];
    
    NSMutableArray *cities = [[NSMutableArray alloc] initWithCapacity:cityList.count];
    for (NSDictionary *city in cityList) {
        [cities addObject:[self dictionaryFromPropertyList:city
                                                  withKeys:@[@"cityID", @"name", @"country"]
                                       forValuesAtKeyPaths:@[@"id", @"name", @"sys.country"]]];
    }
    
    return cities;
}

+ (CardinalDirections)cardinalDirectionForDegrees:(NSNumber *)degrees
{
    if ([degrees doubleValue] < 0) {
        degrees = @(360 + [degrees doubleValue]);
    }
    NSInteger direction = (([degrees doubleValue] + 11.25)/22.5);
    return direction % 16;
}

+ (NSDictionary *)propertyListFromJSONData:(NSData *)data
{
    NSDictionary *propertyList;
    
    if (data) {
#warning handle error
        propertyList = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    }
    
    return propertyList;
}

+ (NSDictionary *)dictionaryFromPropertyList:(NSDictionary *)propertyList withKeys:(NSArray*)keys forValuesAtKeyPaths:(NSArray *)KeyPaths
{
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:keys.count];
    for (NSString *keypath in KeyPaths) {
        [values addObject:[propertyList valueForKeyPath:keypath]];
    }
    
    return [[NSDictionary alloc] initWithObjects:values forKeys:keys];
}

+ (NSDictionary *)windForecastFromForecast:(NSDictionary *)forecast withDirectionKey:(NSString *)directionKey andSpeedKey:(NSString *)speedKey
{
    NSDictionary *windForecast;
    
    if ([[forecast valueForKeyPath:@"dt"] isKindOfClass:[NSNumber class]]) {
        NSInteger timestamp = [(NSNumber *)[forecast valueForKeyPath:@"dt"] integerValue];
        windForecast = @{@"wind": [self dictionaryFromPropertyList:forecast
                                                         withKeys:@[@"direction", @"speed"]
                                              forValuesAtKeyPaths:@[directionKey, speedKey]],
                        @"datetime": [NSDate dateWithTimeIntervalSince1970:timestamp]};
    }
    
    return windForecast;
}

+ (NSArray *)allForecastsInWeatherData:(NSData *)weatherData onDate:(NSDate *)date
{
    NSArray *forecasts;
    
    if (weatherData) {
        NSMutableArray *allForecasts = [NSMutableArray arrayWithArray:[[self propertyListFromJSONData:weatherData] valueForKeyPath:@"list"]];
        
        NSIndexSet *indexesOfForecastsForSpecifiedDate = [allForecasts indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([[obj valueForKeyPath:@"dt"] isKindOfClass:[NSNumber class]]) {
                NSNumber *timestampValue = [obj valueForKeyPath:@"dt"];
                NSDate *forecastDate = [NSDate dateWithTimeIntervalSince1970:[timestampValue integerValue]];
                return [self date:forecastDate isTheSameDayAsAnotherDate:date];
            }
            return NO;
        }];
        
        if ([indexesOfForecastsForSpecifiedDate count] > 0) {
            forecasts = [allForecasts objectsAtIndexes:indexesOfForecastsForSpecifiedDate];
        } else {
            forecasts = @[];
        }
    }
    
    return forecasts;
}

+ (BOOL)date:(NSDate*)date1 isTheSameDayAsAnotherDate:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* date1Components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date1];
    NSDateComponents* date2Components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date2];
    
    return [date1Components day] == [date2Components day] &&
    [date1Components month] == [date2Components month] &&
    [date1Components year]  == [date2Components year];
}
@end
