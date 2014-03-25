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
    NSURLRequest *request = [NSURLRequest requestWithURL:[OpenWeatherFetcherURLs urlForCitySearchWithName:searchString]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               NSArray *cities = [OpenWeatherFetcherHelper citiesFromCitySearchData:data];
                               //NSLog(@"Cities found: %@", cities);
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   completionHandler(cities);
                               });
                           }];
}

+ (void)currentWindDataForCityWithID:(NSNumber *)cityID
               withCompletionHandler:(void (^)(NSDictionary *currentWeather))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [OpenWeatherFetcherURLs urlForCurrentWeatherInCityWithID:cityID]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               NSDictionary *currentWeather = [OpenWeatherFetcherHelper currentWindFromWeatherData:data];
                               //NSLog(@"Current weather: %@", currentWeather);
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   completionHandler(currentWeather);
                               });
                           }];
}

+ (void)dailyForecastWindDataForCityWithID:(NSNumber *)cityID
                                    onDate:(NSDate *)date
                     withCompletionHandler:(void (^)(NSDictionary *dailyForecast))completionHandler
{
    if (cityID && date) {
        //could check whether to request fewer days here.
        NSURLRequest *request = [NSURLRequest requestWithURL:[OpenWeatherFetcherURLs urlForDailyWeatherInCityWithID:cityID forNumberOfDays:MAX_DAILY_FORECAST_DAYS]];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *connectionError) {
                                   NSDictionary *dailyWeather = [OpenWeatherFetcherHelper dailyForecastWindFromWeatherData:data forDate:date];
                                   //NSLog(@"Daily weather forecast for %@: %@", date, dailyWeather);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       completionHandler(dailyWeather);
                                   });
                               }];
    }
}

+ (void)threeHourlyForecastWindDataForCityWithID:(NSNumber *)cityID
                                          onDate:(NSDate *)date
                           withCompletionHandler:(void (^)(NSArray *threeHourlyForecasts))completionHandler
{
    if (cityID && date) {
        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [OpenWeatherFetcherURLs urlFor3HourlyWeatherInCityWithID:cityID]];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *connectionError) {
                                   NSArray *threeHourlyWeather = [OpenWeatherFetcherHelper threeHourlyForecastWindFromWeatherData:data forDate:date];
                                   //NSLog(@"3 hourly forecasts for %@: %@", date, threeHourlyWeather);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       completionHandler(threeHourlyWeather);
                                   });
                               }];
    }
}

@end
