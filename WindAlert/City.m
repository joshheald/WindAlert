//
//  City.m
//  WindAlert
//
//  Created by Josh on 21/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "City.h"
#import "OpenWeatherFetcher.h"

@interface City ()

@property (strong, readwrite, nonatomic) NSString *name;
@property (strong, readwrite, nonatomic) NSString *country;
@property (strong, readwrite, nonatomic) NSNumber *cityID;
@property (strong, readwrite, nonatomic) NSDictionary *currentWeather;
@property (weak, nonatomic) id<CityDelegate> delegate;

@end

@implementation City

+ (City *)cityWithCityDictionary:(NSDictionary *)cityDictionary notifyDelegateOfUpdates:(id<CityDelegate>)delegate
{
    City *city;
    
    if (cityDictionary) {
        city = [[City alloc] initWithCityDictionary:cityDictionary];
    }
    
    city.delegate = delegate;
    
    return city;
}

- (instancetype)initWithCityDictionary:(NSDictionary *)cityDictionary
{
    self = [super init];
    
    _name = [cityDictionary valueForKeyPath:KEY_FOR_CITY_NAME];
    _cityID = [cityDictionary valueForKeyPath:KEY_FOR_CITY_ID];
    _country = [cityDictionary valueForKeyPath:KEY_FOR_COUNTRY_NAME];
    
    [self updateCurrentWeather];
    
    return self;
}

- (NSDictionary *)createCityDictionary
{
    return @{KEY_FOR_CITY_NAME: self.name,
             KEY_FOR_CITY_ID: self.cityID,
             KEY_FOR_COUNTRY_NAME: self.country};
}

- (void)refreshData
{
    [self updateCurrentWeather];
}

- (void)updateCurrentWeather
{
    __weak City *weakSelf = self;
    [OpenWeatherFetcher currentWindDataForCityWithID:self.cityID withCompletionHandler:^(NSDictionary *currentWeather) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.currentWeather = currentWeather;
            [weakSelf.delegate currentWeatherDidFinishUpdatingForCity:weakSelf];
        });
    }];
}

- (NSString *)description
{
    return self.name;
}

@end
