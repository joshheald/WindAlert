//
//  OpenWeatherFetcher.m
//  WindAlert
//
//  Created by Josh on 20/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "OpenWeatherFetcher.h"
#import "OpenWeatherFetcherURLs.h"
#import "OpenWeatherFetcherHelper.h"

@implementation OpenWeatherFetcher

+ (void)citiesForSearchString:(NSString *)searchString withCompletionHandler:(void (^)(NSArray *cities))completionHandler
{
    NSURL *url = [OpenWeatherFetcherURLs urlForCitySearchWithName:searchString];
    
    dispatch_queue_t searchQueue = dispatch_queue_create("city search", NULL);
    dispatch_async(searchQueue, ^{
        NSData *response = [NSData dataWithContentsOfURL:url];
        NSArray *cities = [OpenWeatherFetcherHelper citiesFromCitySearchData:response];
        NSLog(@"Cities found: %@", cities);
        completionHandler(cities);
    });
}

+ (void)currentWindDataForCityWithID:(NSNumber *)cityID withCompletionHandler:(void (^)(NSDictionary *currentWeather))completionHandler
{
    NSURL *url = [OpenWeatherFetcherURLs urlForCurrentWeatherInCityWithID:cityID];
    
    dispatch_queue_t searchQueue = dispatch_queue_create("current weather", NULL);
    dispatch_async(searchQueue, ^{
        NSData *response = [NSData dataWithContentsOfURL:url];
        NSDictionary *currentWeather = [OpenWeatherFetcherHelper currentWindFromWeatherData:response];
        NSLog(@"Current weather: %@", currentWeather);
        completionHandler(currentWeather);
    });
}

+ (NSDictionary *)dailyForecastWindDataForCityWithID:(NSString *)cityID onDate:(NSDate *)date
{
    NSDictionary *windData;
    
    return windData;
}

+ (NSArray *)threeHourlyForecastWindDataForCityWithID:(NSString *)cityID onDate:(NSDate *)date
{
    NSArray *windData;
    
    return windData;
}

@end
