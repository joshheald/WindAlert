//
//  OpenWeatherFetcherHelperTests.m
//  WindAlert
//
//  Created by Josh on 20/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OpenWeatherFetcherHelper.h"

@interface OpenWeatherFetcherHelperTests : XCTestCase

@end

@implementation OpenWeatherFetcherHelperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testICanDetermineTheCardinalDirectionOfAValueInDegrees
{
    XCTAssertEqual(CardinalDirectionNorth, [OpenWeatherFetcherHelper cardinalDirectionForDegrees:@0.0], @"The cardinal direction of 0 degrees should be North");
    XCTAssertEqual(CardinalDirectionEast, [OpenWeatherFetcherHelper cardinalDirectionForDegrees:@90.0], @"The cardinal direction of 0 degrees should be East");
    XCTAssertEqual(CardinalDirectionSouth, [OpenWeatherFetcherHelper cardinalDirectionForDegrees:@180.0], @"The cardinal direction of 0 degrees should be South");
    XCTAssertEqual(CardinalDirectionWest, [OpenWeatherFetcherHelper cardinalDirectionForDegrees:@270.0], @"The cardinal direction of 0 degrees should be West");
}

- (void)testICanDetermineTheCardinalDirectionWhenIPassAnOutOfRangeValueForDegrees
{
    XCTAssertEqual(CardinalDirectionWestNorthWest, [OpenWeatherFetcherHelper cardinalDirectionForDegrees:@-75], @"The cardinal direction of -75 degrees should be WestNorthWest");
    XCTAssertEqual(CardinalDirectionEast, [OpenWeatherFetcherHelper cardinalDirectionForDegrees:@449], @"The cardinal direction of 449 degrees should be East");
}

- (void)testICanGetACityDictionaryFromJSONSearchData
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"city-search-response" ofType:@"json"];
    NSData *citySearchResponse = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *expectedCity = @[@{@"cityID": @2643743,
                                @"name": @"London",
                                @"country": @"GB"}];

    XCTAssertEqualObjects(expectedCity, [OpenWeatherFetcherHelper citiesFromCitySearchData:citySearchResponse], @"A city dictionary should be extracted from the search results");
}

- (void)testICanGetCurrentWindConditionsFromJSONCurrentWeatherData
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"current-weather-response" ofType:@"json"];
    NSData *currentWeatherResponse = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary *expectedCurrentWindConditions = @{@"wind": @{@"direction": @224,
                                                               @"speed":@3.6},
                                                    @"datetime": [NSDate dateWithTimeIntervalSince1970:1395316279]};
    
    XCTAssertEqualObjects(expectedCurrentWindConditions, [OpenWeatherFetcherHelper currentWindFromWeatherData:currentWeatherResponse], @"A current conditions dictionary should be extracted from the current weather results");
}

- (void)testICanGetTheWindConditionsForASpecificDateFromJSONDailyForecastWeatherData
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"daily-forecast-weather-response" ofType:@"json"];
    NSData *dailyForecastWeatherResponse = [NSData dataWithContentsOfFile:filePath];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395403200];
    NSDictionary *expectedDailyForecast = @{@"wind": @{@"direction": @236,
                                                       @"speed":@6.92},
                                            @"datetime": date};
    
    XCTAssertEqualObjects(expectedDailyForecast, [OpenWeatherFetcherHelper dailyForecastWindFromWeatherData:dailyForecastWeatherResponse forDate:date], @"A forecast conditions dictionary should be extracted from the forecast weather results for the specifed date");
}

- (void)testICanGetTheWindConditionsForEvery3HoursOnASpecificDateFromJSON3HourlyForecastWeatherData
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"three-hourly-forecast-weather-response" ofType:@"json"];
    NSData *threeHourlyForecastWeatherResponse = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *expected3HourlyForecasts = @[
                                          @{@"wind": @{@"direction": @263.501,
                                                       @"speed":@5.21},
                                            @"datetime": [NSDate dateWithTimeIntervalSince1970:1395360000]},
                                          @{@"wind": @{@"direction": @261.005,
                                                       @"speed":@4.21},
                                            @"datetime": [NSDate dateWithTimeIntervalSince1970:1395370800]},
                                          @{@"wind": @{@"direction": @256.505,
                                                       @"speed":@3.51},
                                            @"datetime": [NSDate dateWithTimeIntervalSince1970:1395381600]},
                                          @{@"wind": @{@"direction": @238.005,
                                                       @"speed":@4.02},
                                            @"datetime": [NSDate dateWithTimeIntervalSince1970:1395392400]},
                                          @{@"wind": @{@"direction": @231.505,
                                                       @"speed":@5.77},
                                            @"datetime": [NSDate dateWithTimeIntervalSince1970:1395403200]},
                                          @{@"wind": @{@"direction": @225.001,
                                                       @"speed":@7.71},
                                            @"datetime": [NSDate dateWithTimeIntervalSince1970:1395414000]},
                                          @{@"wind": @{@"direction": @216.501,
                                                       @"speed":@7.69},
                                            @"datetime": [NSDate dateWithTimeIntervalSince1970:1395424800]},
                                          @{@"wind": @{@"direction": @205.005,
                                                       @"speed":@8.36},
                                            @"datetime": [NSDate dateWithTimeIntervalSince1970:1395435600]}
                                          ];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395403200];
    
    XCTAssertEqualObjects(expected3HourlyForecasts, [OpenWeatherFetcherHelper threeHourlyForecastWindFromWeatherData:threeHourlyForecastWeatherResponse forDate:date], @"An array of forecast conditions dictionaries should be extracted from the forecast weather results for the specifed date");
}
@end
