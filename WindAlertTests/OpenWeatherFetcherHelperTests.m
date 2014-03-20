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
    
    NSDictionary *expectedCity = [[NSDictionary alloc] initWithObjects:@[@2643743, @"London", @"GB"]
                                                               forKeys:@[@"cityID", @"name", @"country"]];
    
    XCTAssertEqualObjects(expectedCity, [OpenWeatherFetcherHelper cityFromCitySearchData:citySearchResponse], @"A city dictionary should be extracted from the search results");
}

- (void)testICanGetCurrentWindConditionsFromJSONCurrentWeatherData
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"current-weather-response" ofType:@"json"];
    NSData *currentWeatherResponse = [NSData dataWithContentsOfFile:filePath];
    
    /*NSDictionary *expectedCurrentWindConditions = [[NSDictionary alloc]initWithObjects:@[@224, @3.6]
                                                                        forKeys:@[@"direction", @"speed"]];*/
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395316279];
    NSDictionary *expectedCurrentWindConditions = [[NSDictionary alloc] initWithObjects:@[@{@"direction": @224, @"speed":@3.6}, date]
                                                                                forKeys:@[@"wind", @"datetime"]];
    
    XCTAssertEqualObjects(expectedCurrentWindConditions, [OpenWeatherFetcherHelper currentWindFromWeatherData:currentWeatherResponse], @"A current conditions dictionary should be extracted from the current weather results");
}

- (void)testICanGetTheWindConditionsForASpecificDateFromJSONDailyForecastWeatherData
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"daily-forecast-weather-response" ofType:@"json"];
    NSData *dailyForecastWeatherResponse = [NSData dataWithContentsOfFile:filePath];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395403200];
    NSDictionary *expectedDailyForecast = [[NSDictionary alloc] initWithObjects:@[@{@"direction": @236, @"speed":@6.92}, date]
                                                                        forKeys:@[@"wind", @"datetime"]];
    
    XCTAssertEqualObjects(expectedDailyForecast, [OpenWeatherFetcherHelper dailyForecastWindFromWeatherData:dailyForecastWeatherResponse forDate:date], @"A forecast conditions dictionary should be extracted from the forecast weather results for the specifed date");
}

- (void)testICanGetTheWindConditionsForEvery3HoursOnASpecificDateFromJSON3HourlyForecastWeatherData
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"three-hourly-forecast-weather-response" ofType:@"json"];
    NSData *threeHourlyForecastWeatherResponse = [NSData dataWithContentsOfFile:filePath];
    
    NSMutableArray *expected3HourlyForecasts = [[NSMutableArray alloc] initWithCapacity:8];
    [expected3HourlyForecasts addObject:[[NSDictionary alloc] initWithObjects:@[@{@"direction": @263.501, @"speed":@5.21}, [NSDate dateWithTimeIntervalSince1970:1395360000]]
                                                                      forKeys:@[@"wind", @"datetime"]]];
    [expected3HourlyForecasts addObject:[[NSDictionary alloc] initWithObjects:@[@{@"direction": @261.005, @"speed":@4.21}, [NSDate dateWithTimeIntervalSince1970:1395370800]]
                                                                      forKeys:@[@"wind", @"datetime"]]];
    [expected3HourlyForecasts addObject:[[NSDictionary alloc] initWithObjects:@[@{@"direction": @256.505, @"speed":@3.51}, [NSDate dateWithTimeIntervalSince1970:1395381600]]
                                                                      forKeys:@[@"wind", @"datetime"]]];
    [expected3HourlyForecasts addObject:[[NSDictionary alloc] initWithObjects:@[@{@"direction": @238.005, @"speed":@4.02}, [NSDate dateWithTimeIntervalSince1970:1395392400]]
                                                                      forKeys:@[@"wind", @"datetime"]]];
    [expected3HourlyForecasts addObject:[[NSDictionary alloc] initWithObjects:@[@{@"direction": @231.505, @"speed":@5.77}, [NSDate dateWithTimeIntervalSince1970:1395403200]]
                                                                      forKeys:@[@"wind", @"datetime"]]];
    [expected3HourlyForecasts addObject:[[NSDictionary alloc] initWithObjects:@[@{@"direction": @225.001, @"speed":@7.71}, [NSDate dateWithTimeIntervalSince1970:1395414000]]
                                                                      forKeys:@[@"wind", @"datetime"]]];
    [expected3HourlyForecasts addObject:[[NSDictionary alloc] initWithObjects:@[@{@"direction": @216.501, @"speed":@7.69}, [NSDate dateWithTimeIntervalSince1970:1395424800]]
                                                                      forKeys:@[@"wind", @"datetime"]]];
    [expected3HourlyForecasts addObject:[[NSDictionary alloc] initWithObjects:@[@{@"direction": @205.005, @"speed":@8.36}, [NSDate dateWithTimeIntervalSince1970:1395435600]]
                                                                      forKeys:@[@"wind", @"datetime"]]];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395403200];
    
    XCTAssertEqualObjects(expected3HourlyForecasts, [OpenWeatherFetcherHelper threeHourlyForecastWindFromWeatherData:threeHourlyForecastWeatherResponse forDate:date], @"An array of forecast conditions dictionaries should be extracted from the forecast weather results for the specifed date");
}
@end
