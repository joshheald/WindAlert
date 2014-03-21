//
//  OpenWeatherFetcherTests.m
//  WindAlert
//
//  Created by Josh on 20/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OpenWeatherFetcherURLs.h"

@interface OpenWeatherFetcherURLsTests : XCTestCase

@end

@implementation OpenWeatherFetcherURLsTests

#define OPENWEATHER_API_ADDRESS @"http://api.openweathermap.org/data/2.5"

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

- (void)testWhenIGetTheAPIURLToSearchForACityNameTheURLIsConstructedCorrectly
{
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/find?q=London&type=like&cnt=20&mode=json", OPENWEATHER_API_ADDRESS]];
    XCTAssertEqualObjects(expectedURL, [OpenWeatherFetcherURLs urlForCitySearchWithName:@"London"], @"The OpenWeatherFetcherURLs class should construct a URL for a search request for the passed city, to retrieve maximum 20 results");
}

- (void)testWhenIGetTheAPIURLToSearchForACityWithoutPassingANameTheURLIsNotReturned
{
    XCTAssertNil([OpenWeatherFetcherURLs urlForCitySearchWithName:nil], @"The OpenWeatherFetcherURLs class should return nil when no city name is supplied");
    
    XCTAssertNil([OpenWeatherFetcherURLs urlForCitySearchWithName:@""], @"The OpenWeatherFetcherURLs class should return nil when an empty string is passed");
}

- (void)testWhenIGetTheAPIURLToGetCurrentWeatherDataForACityIDTheURLIsConstructedCorrectly
{
    NSString *cityID = @"2643743";
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/weather?id=&%@mode=json", OPENWEATHER_API_ADDRESS, cityID]];
    
    XCTAssertEqualObjects(expectedURL, [OpenWeatherFetcherURLs urlForCurrentWeatherInCityWithID:cityID], @"The OpenWeatherFetcherURLs class should construct a URL for a request for the current weather in the passed city");
}

- (void)testWhenIGetTheAPIURLToGetCurrentWeatherDataForACityWithoutPassingAnIDTheURLIsNotReturned
{
    XCTAssertNil([OpenWeatherFetcherURLs urlForCurrentWeatherInCityWithID:nil], @"The OpenWeatherFetcherURLs class should return nil when no city id is supplied");
    
    XCTAssertNil([OpenWeatherFetcherURLs urlForCurrentWeatherInCityWithID:@""], @"The OpenWeatherFetcherURLs class should return nil when an empty string is passed");
}

- (void)testWhenIGetTheAPIURLToGetTheDailyWeatherForcastDataForACityIDTheURLIsConstructedCorrectly
{
    NSString *cityID = @"2643743";
    NSInteger daysCount = 14;
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/daily?id=%@&cnt=%i&mode=json", OPENWEATHER_API_ADDRESS, cityID, daysCount]];
    
    XCTAssertEqualObjects(expectedURL, [OpenWeatherFetcherURLs urlForDailyWeatherInCityWithID:cityID forNumberOfDays:daysCount], @"The OpenWeatherFetcherURLs class should construct a URL for a request for the daily weather forecast in the passed city for the requested number of days");
    
    daysCount = 1;
    expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/daily?id=%@&cnt=%i&mode=json", OPENWEATHER_API_ADDRESS, cityID, daysCount]];
    
    XCTAssertEqualObjects(expectedURL, [OpenWeatherFetcherURLs urlForDailyWeatherInCityWithID:cityID forNumberOfDays:daysCount], @"The OpenWeatherFetcherURLs class should construct a URL for a request for the daily weather forecast in the passed city for the requested number of days");
}

- (void)testWhenIGetTheAPIURLToGetTheDailyWeatherForecastDataForACityWithoutPassingAnIDTheURLIsNotReturned
{
    NSInteger daysCount = 2;
    XCTAssertNil([OpenWeatherFetcherURLs urlForDailyWeatherInCityWithID:nil forNumberOfDays:daysCount], @"The OpenWeatherFetcherURLs class should return nil when no city id is supplied");
    
    XCTAssertNil([OpenWeatherFetcherURLs urlForDailyWeatherInCityWithID:@"" forNumberOfDays:daysCount], @"The OpenWeatherFetcherURLs class should return nil when an empty string is passed");
}

- (void)testWhenIGetTheAPIURLToGetTheDailyWeatherForecastDataForACityIDWithAnOutOfRangeNumberOfDaysTheURLIsNotReturned
{
    NSString *cityID = @"2643743";
    NSInteger daysCount = 15;
    
    XCTAssertNil([OpenWeatherFetcherURLs urlForDailyWeatherInCityWithID:cityID forNumberOfDays:daysCount], @"The OpenWeatherFetcherURLs class should return nil when the requested number of days is over 14");
    
    daysCount = 0;
    XCTAssertNil([OpenWeatherFetcherURLs urlForDailyWeatherInCityWithID:cityID forNumberOfDays:daysCount], @"The OpenWeatherFetcherURLs class should return nil when the requested number of days is under 1");
}

- (void)testWhenIGetTheAPIURLToGetThe3HourlyWeatherForecastDataForACityIDTheURLIsConstructedCorrectly
{
    NSString *cityID = @"2643743";
    NSURL *expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/forecast?id=%@&mode=json", OPENWEATHER_API_ADDRESS, cityID]];
    
    XCTAssertEqualObjects(expectedURL, [OpenWeatherFetcherURLs urlFor3HourlyWeatherInCityWithID:cityID], @"The OpenWeatherFetcherURLs class should construct a URL for a request for the 3 hourly 5 day weather forecast in the passed city");
}

- (void)testWhenIGetTheAPIURLToGetThe3HourlyWeatherForecastDataForACityWithoutPassingAnIDTheURLIsNotReturned
{
    XCTAssertNil([OpenWeatherFetcherURLs urlFor3HourlyWeatherInCityWithID:nil], @"The OpenWeatherFetcherURLs class should return nil when no city id is supplied");
    
    XCTAssertNil([OpenWeatherFetcherURLs urlFor3HourlyWeatherInCityWithID:@""], @"The OpenWeatherFetcherURLs class should return nil when an empty string is passed");
}
@end
