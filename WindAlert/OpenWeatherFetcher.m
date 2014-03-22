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

+ (void)citiesForSearchString:(NSString *)searchString
        withCompletionHandler:(void (^)(NSArray *cities))completionHandler
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

+ (void)currentWindDataForCityWithID:(NSNumber *)cityID
               withCompletionHandler:(void (^)(NSDictionary *currentWeather))completionHandler
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

+ (void)dailyForecastWindDataForCityWithID:(NSNumber *)cityID
                                    onDate:(NSDate *)date
                     withCompletionHandler:(void (^)(NSDictionary *dailyForecast))completionHandler
{
    if (cityID && date) {
        //could check whether to request fewer days here.
        NSURL *url = [OpenWeatherFetcherURLs urlForDailyWeatherInCityWithID:cityID forNumberOfDays:MAX_DAILY_FORECAST_DAYS];
        
        dispatch_queue_t forecastQueue = dispatch_queue_create("daily forecasts", NULL);
        dispatch_async(forecastQueue, ^{
            NSData *response = [NSData dataWithContentsOfURL:url];
            NSDictionary *dailyWeather = [OpenWeatherFetcherHelper dailyForecastWindFromWeatherData:response forDate:date];
            NSLog(@"Daily weather forecast for %@: %@", date, dailyWeather);
            completionHandler(dailyWeather);
        });
    }
}

+ (void)threeHourlyForecastWindDataForCityWithID:(NSNumber *)cityID
                                          onDate:(NSDate *)date
                           withCompletionHandler:(void (^)(NSArray *threeHourlyForecasts))completionHandler
{
    if (cityID && date) {
        NSURL *url = [OpenWeatherFetcherURLs urlFor3HourlyWeatherInCityWithID:cityID];
        
        dispatch_queue_t forecastQueue = dispatch_queue_create("3 hourly forecasts", NULL);
        dispatch_async(forecastQueue, ^{
            NSData *response = [NSData dataWithContentsOfURL:url];
            NSArray *threeHourlyWeather = [OpenWeatherFetcherHelper threeHourlyForecastWindFromWeatherData:response forDate:date];
            NSLog(@"3 hourly forecasts for %@: %@", date, threeHourlyWeather);
            completionHandler(threeHourlyWeather);
        });
    }
}

@end
