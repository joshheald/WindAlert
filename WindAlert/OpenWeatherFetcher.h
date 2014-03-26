//
//  OpenWeatherFetcher.h
//  WindAlert
//
//  Created by Josh on 20/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

/*
 Provides interfaces to OpenWeatherMap API
 
 1: searching for cities
     a: by city name - return 5 cities maximum
     b: by lat/long - return 10 nearest cities
     returns: NSArray of NSDictionaries, containing Name, Country, ID, Lat, Long
 
 2: Current wind data by city ID
     returns: NSDictionary containing Speed, Direction (cardinal)
 
 3: Forecast wind data by city ID
     a: for a day overall
     returns: NSDictionary containing Speed, Direction (cardinal)
     b: for every 3 hours within a day (after now, if today)
     returns: NSArray of NSDictionaries containing Time, Speed, Direction (cardinal)
 */

#import <Foundation/Foundation.h>

@interface OpenWeatherFetcher : NSObject

//+ (NSArray *)citiesFoundForSearchString:(NSString *)searchString;
+ (void)citiesForSearchString:(NSString *)searchString withCompletionHandler:(void (^)(NSArray *cities))completionHandler;
+ (void)currentWindDataForCityWithID:(NSNumber *)cityID withCompletionHandler:(void (^)(NSDictionary *currentWeather))completionHandler;
+ (void)dailyForecastWindDataForCityWithID:(NSNumber *)cityID onDate:(NSDate *)date withCompletionHandler:(void (^)(NSDictionary *dailyForecast))completionHandler;
+ (void)threeHourlyForecastWindDataForCityWithID:(NSNumber *)cityID onDate:(NSDate *)date withCompletionHandler:(void (^)(NSArray *threeHourlyForecasts))completionHandler;


#define KEY_FOR_CITY_NAME @"name"
#define KEY_FOR_COUNTRY_NAME @"country"
#define KEY_FOR_CITY_ID @"cityID"

#define KEY_FOR_WIND_SPEED @"wind.speed"
#define KEY_FOR_WIND_DIRECTION @"wind.direction"

#define KEY_FOR_DATETIME @"datetime"

#define MAX_DAILY_FORECAST_DAYS 14
@end
