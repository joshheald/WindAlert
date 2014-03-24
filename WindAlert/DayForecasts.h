//
//  DayForecasts.h
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DayForecasts;

@protocol DayForecastsDelegate

- (void)dayForecastsDidFinishUpdating:(DayForecasts *)dayForecasts;

@end

@interface DayForecasts : NSObject

@property (readonly, nonatomic) NSNumber *cityID;
@property (readonly, nonatomic) NSDate *forecastDate;
@property (readonly, nonatomic) NSDictionary *dayForecast;
@property (readonly, nonatomic) NSArray *threeHourlyForecasts;

+ (DayForecasts *)dayForecastsWithCityID:(NSNumber *)cityID forDate:(NSDate *)forecastDate notifyDelegateOfUpdates:(id<DayForecastsDelegate>) delegate;

- (void)refreshData;

@end
