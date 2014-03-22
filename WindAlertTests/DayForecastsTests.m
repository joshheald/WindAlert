//
//  DayForecasts.m
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DayForecasts.h"

@interface DayForecastsTests : XCTestCase

@end

@implementation DayForecastsTests

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

- (void)testICanCreateADayForecastsObjectForACityWithACityID
{
    NSNumber *cityID = @2643743;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1395316800];
    
    DayForecasts *result = [DayForecasts dayForecastsWithCityID:cityID forDate:date];
    
    XCTAssertEqual(cityID, result.cityID, @"The forecast should have the city ID passed");
    XCTAssertEqual(date, result.forecastDate, @"The forecast should have the date passed");
}

@end
