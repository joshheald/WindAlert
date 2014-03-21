//
//  OpenWeatherFetcherHelper.m
//  WindAlert
//
//  Created by Josh on 20/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "OpenWeatherFetcherHelper.h"

@interface OpenWeatherFetcherHelper ()

+ (NSDictionary *)dictionaryFromJSONData:(NSData *)data withKeysForValuesAtKeyPaths:(NSArray *)keysToKeyPaths;

@end

@implementation OpenWeatherFetcherHelper

+ (NSDictionary *)currentWindFromWeatherData:(NSData *)weatherData
{
    NSDictionary *currentWind;
    
    NSDictionary *currentWeatherPropertyList = [self propertyListFromJSONData:weatherData];
    
    if ([[currentWeatherPropertyList valueForKeyPath:@"dt"] isKindOfClass:[NSNumber class]]) {
        NSDate *forecastDate = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[currentWeatherPropertyList valueForKeyPath:@"dt"] integerValue]];
        currentWind = [NSDictionary dictionaryWithObjects:@[[self dictionaryFromPropertyList:currentWeatherPropertyList
                                                                 withKeysForValuesAtKeyPaths:@[@{@"KeyPath": @"wind.deg", @"Key": @"direction"}, @{@"KeyPath": @"wind.speed", @"Key": @"speed"}]], forecastDate]
                                                  forKeys:@[@"wind", @"datetime"]];
    }
    
    return currentWind;
}

+ (NSDictionary *)dailyForecastWindFromWeatherData:(NSData *)weatherData forDate:(NSDate *)date
{
    NSDictionary *dailyForecast;
    
    NSMutableArray *allForecasts = [NSMutableArray arrayWithArray:[[self propertyListFromJSONData:weatherData] valueForKeyPath:@"list"]];
    NSUInteger indexOfForecastForSpecifiedDate = [allForecasts indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj valueForKeyPath:@"dt"] isKindOfClass:[NSNumber class]]) {
            NSNumber *timestampValue = [obj valueForKeyPath:@"dt"];
            
            return [[NSDate dateWithTimeIntervalSince1970:[timestampValue integerValue]] compare:date] == NSOrderedSame;
        }
        return NO;
    }];
    
    NSDictionary *windForecast = [self dictionaryFromPropertyList:allForecasts[indexOfForecastForSpecifiedDate]
                                      withKeysForValuesAtKeyPaths:@[@{@"KeyPath": @"deg", @"Key": @"direction"}, @{@"KeyPath": @"speed", @"Key": @"speed"}]];
    
    dailyForecast = [[NSDictionary alloc] initWithObjects:@[windForecast, date] forKeys:@[@"wind", @"datetime"]];
    
    return dailyForecast;
}

+ (NSArray *)threeHourlyForecastWindFromWeatherData:(NSData *)weatherData forDate:(NSDate *)date
{
    NSMutableArray *forecasts;
    
    NSMutableArray *allForecasts = [NSMutableArray arrayWithArray:[[self propertyListFromJSONData:weatherData] valueForKeyPath:@"list"]];
    NSIndexSet *indexesOfForecastsForSpecifiedDate = [allForecasts indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj valueForKeyPath:@"dt"] isKindOfClass:[NSNumber class]]) {
            NSNumber *timestampValue = [obj valueForKeyPath:@"dt"];
            NSDate *forecastDate = [NSDate dateWithTimeIntervalSince1970:[timestampValue integerValue]];
            return [self date:forecastDate isTheSameDayAsAnotherDate:date];
        }
        return NO;
    }];
    
    NSArray *forecastsForSpecifiedDate = [allForecasts objectsAtIndexes:indexesOfForecastsForSpecifiedDate];
    if (forecastsForSpecifiedDate) {
        forecasts = [[NSMutableArray alloc] init];
        
        for (NSDictionary *forecast in forecastsForSpecifiedDate) {
            if ([[forecast valueForKeyPath:@"dt"] isKindOfClass:[NSNumber class]]) {
                NSDate *forecastTime = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[forecast valueForKeyPath:@"dt"] integerValue]];
                NSDictionary *windData = [self dictionaryFromPropertyList:forecast
                                              withKeysForValuesAtKeyPaths:@[@{@"KeyPath": @"wind.deg", @"Key": @"direction"}, @{@"KeyPath": @"wind.speed", @"Key": @"speed"}]];
                [forecasts addObject:[NSDictionary dictionaryWithObjects:@[windData, forecastTime] forKeys:@[@"wind", @"datetime"]]];
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
        [cities addObject:[self dictionaryFromPropertyList:city withKeysForValuesAtKeyPaths:@[@{@"KeyPath": @"id", @"Key": @"cityID"}, @{@"KeyPath": @"name", @"Key": @"name"}, @{@"KeyPath": @"sys.country", @"Key": @"country"}]]];
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

+ (NSDictionary *)dictionaryFromJSONData:(NSData *)data withKeysForValuesAtKeyPaths:(NSArray *)keysToKeyPaths //array of dictionaries
{
    NSDictionary *dictionary;
    
    NSDictionary *dataPropertyList = [self propertyListFromJSONData:data];
        
    if(dataPropertyList)
    {
        dictionary = [self dictionaryFromPropertyList:dataPropertyList withKeysForValuesAtKeyPaths:keysToKeyPaths];
    }
    
    return dictionary;
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

+ (NSDictionary *)dictionaryFromPropertyList:(NSDictionary *)propertyList withKeysForValuesAtKeyPaths:(NSArray *)keysToKeyPaths
{
    NSArray *keys = [keysToKeyPaths valueForKey:@"Key"];
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:keysToKeyPaths.count];
    for (NSString *keypath in [keysToKeyPaths valueForKey:@"KeyPath"]) {
        [values addObject:[propertyList valueForKeyPath:keypath]];
    }
    
    return [[NSDictionary alloc] initWithObjects:values forKeys:keys];
}

+ (BOOL)date:(NSDate*)date1 isTheSameDayAsAnotherDate:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* date1Components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date1];
    NSDateComponents* date2Components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date2];
    
    return [date1Components day] == [date2Components day] &&
    [date1Components month] == [date2Components month] &&
    [date1Components year]  == [date2Components year];
}

@end
