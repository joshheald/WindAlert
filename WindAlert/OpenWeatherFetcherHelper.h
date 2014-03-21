//
//  OpenWeatherFetcherHelper.h
//  WindAlert
//
//  Created by Josh on 20/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CardinalDirections) {
    CardinalDirectionNorth,
    CardinalDirectionNorthNorthEast,
    CardinalDirectionNorthEast,
    CardinalDirectionEastNorthEast,
    CardinalDirectionEast,
    CardinalDirectionEastSouthEast,
    CardinalDirectionSouthEast,
    CardinalDirectionSouthSouthEast,
    CardinalDirectionSouth,
    CardinalDirectionSouthSouthWest,
    CardinalDirectionSouthWest,
    CardinalDirectionWestSouthWest,
    CardinalDirectionWest,
    CardinalDirectionWestNorthWest,
    CardinalDirectionNorthWest,
    CardinalDirectionNorthNorthWest
};

@interface OpenWeatherFetcherHelper : NSObject
/*
 A forecast dictionary is as follows:
 { 
   wind: {
            speed: (double)mph,
            direction: (double)degrees
         }
   datetime: (date)timeOfForecast
 }
 */
+ (NSDictionary *)currentWindFromWeatherData:(NSData *)weatherData;
+ (NSDictionary *)dailyForecastWindFromWeatherData:(NSData *)weatherData forDate:(NSDate *)date;
+ (NSArray *)threeHourlyForecastWindFromWeatherData:(NSData *)weatherData forDate:(NSDate *)date;

/*
 A city dictionary is as follows:
 { 
   cityID: (integer)idFromApi
   name: (string)name
   country: (string)country(code)
 }
 */
+ (NSArray *)citiesFromCitySearchData:(NSData *)cityData;

+ (CardinalDirections)cardinalDirectionForDegrees:(NSNumber *)degrees;

@end
