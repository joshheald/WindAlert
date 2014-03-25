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
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[OpenWeatherFetcherURLs urlForCitySearchWithName:searchString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSArray *cities = [OpenWeatherFetcherHelper citiesFromCitySearchData:data];
                //NSLog(@"Cities found: %@", cities);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(cities);
                });
            }] resume];
}

+ (void)currentWindDataForCityWithID:(NSNumber *)cityID
               withCompletionHandler:(void (^)(NSDictionary *currentWeather))completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[OpenWeatherFetcherURLs urlForCurrentWeatherInCityWithID:cityID]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSDictionary *currentWeather = [OpenWeatherFetcherHelper currentWindFromWeatherData:data];
                //NSLog(@"Current weather: %@", currentWeather);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(currentWeather);
                });
            }] resume];
}

+ (void)dailyForecastWindDataForCityWithID:(NSNumber *)cityID
                                    onDate:(NSDate *)date
                     withCompletionHandler:(void (^)(NSDictionary *dailyForecast))completionHandler
{
    if (cityID && date) {
        //could check whether to request fewer days here.
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[OpenWeatherFetcherURLs urlForDailyWeatherInCityWithID:cityID forNumberOfDays:MAX_DAILY_FORECAST_DAYS]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSDictionary *dailyWeather = [OpenWeatherFetcherHelper dailyForecastWindFromWeatherData:data forDate:date];
                    //NSLog(@"Daily weather forecast for %@: %@", date, dailyWeather);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(dailyWeather);
                    });
                }] resume];
    }
}

+ (void)threeHourlyForecastWindDataForCityWithID:(NSNumber *)cityID
                                          onDate:(NSDate *)date
                           withCompletionHandler:(void (^)(NSArray *threeHourlyForecasts))completionHandler
{
    if (cityID && date) {
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[OpenWeatherFetcherURLs urlFor3HourlyWeatherInCityWithID:cityID]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSArray *threeHourlyWeather = [OpenWeatherFetcherHelper threeHourlyForecastWindFromWeatherData:data forDate:date];
                    //NSLog(@"3 hourly forecasts for %@: %@", date, threeHourlyWeather);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(threeHourlyWeather);
                    });
                }] resume];
    }
}

@end
