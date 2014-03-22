//
//  OpenWeatherFetcher.h
//  WindAlert
//
//  Created by Josh on 20/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenWeatherFetcherURLs : NSObject

+ (NSURL *)urlForCitySearchWithName:(NSString *)name;
+ (NSURL *)urlForCurrentWeatherInCityWithID:(NSNumber *)cityID;
+ (NSURL *)urlForDailyWeatherInCityWithID:(NSNumber *)cityID forNumberOfDays:(NSInteger)days;
+ (NSURL *)urlFor3HourlyWeatherInCityWithID:(NSNumber *)cityID;

@end
