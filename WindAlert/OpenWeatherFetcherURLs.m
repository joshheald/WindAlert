//
//  OpenWeatherFetcher.m
//  WindAlert
//
//  Created by Josh on 20/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//


#import "OpenWeatherFetcherURLs.h"

@implementation OpenWeatherFetcherURLs

#define OPENWEATHER_API_ADDRESS @"http://api.openweathermap.org/data/2.5"
#define OPENWEATHER_API_MODE @"json"

+ (NSURL *)urlForCitySearchWithName:(NSString *)name
{
    NSURL *searchURL;
    
    if (name && ![name isEqualToString:@""]) {
        searchURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/find?q=%@&type=like&cnt=20&mode=%@", OPENWEATHER_API_ADDRESS, name, OPENWEATHER_API_MODE]];
    }
    
    return searchURL;
}

+ (NSURL *)urlForCurrentWeatherInCityWithID:(NSNumber *)cityID
{
    NSURL *currentWeatherURL;
    
    if (cityID) {
        currentWeatherURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/weather?id=%@&mode=%@", OPENWEATHER_API_ADDRESS, cityID, OPENWEATHER_API_MODE]];
    }
    
    return currentWeatherURL;
}

+ (NSURL *)urlForDailyWeatherInCityWithID:(NSNumber *)cityID forNumberOfDays:(NSInteger)days
{
    NSURL *dailyForecastURL;
    
    if (cityID && (days >= 1 && days <= 14)) {
        dailyForecastURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/daily?id=%@&cnt=%i&mode=%@", OPENWEATHER_API_ADDRESS, cityID, days, OPENWEATHER_API_MODE]];
    }
    
    return dailyForecastURL;
}

+ (NSURL *)urlFor3HourlyWeatherInCityWithID:(NSNumber *)cityID
{
    NSURL *threeHourlyForecastURL;
    
    if (cityID) {
        threeHourlyForecastURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/forecast?id=%@&mode=%@", OPENWEATHER_API_ADDRESS, cityID, OPENWEATHER_API_MODE]];
    }
    
    return threeHourlyForecastURL;
}
@end
