//
//  City.h
//  WindAlert
//
//  Created by Josh on 21/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <Foundation/Foundation.h>
@class City;

@protocol CityDelegate

- (void)currentWeatherDidFinishUpdatingForCity:(City *)city;

@end

@interface City : NSObject

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *country;
@property (readonly, nonatomic) NSNumber *cityID;

@property (readonly, nonatomic) NSDictionary *currentWeather;

+ (City *)cityWithCityDictionary:(NSDictionary *)cityDictionary notifyDelegateOfUpdates:(id<CityDelegate>) delegate;

- (NSDictionary *)createCityDictionary;
- (void)refreshData;

@end
