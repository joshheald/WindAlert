//
//  DayForecasts.h
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayForecasts : NSObject

@property (readonly, nonatomic) NSNumber *cityID;
@property (readonly, nonatomic) NSDate *forecastDate;

+ (DayForecasts *)dayForecastsWithCityID:(NSNumber *)cityID forDate:(NSDate *)forecastDate;

@end
