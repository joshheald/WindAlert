//
//  CityTests.m
//  WindAlert
//
//  Created by Josh on 21/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "City.h"

@interface CityTests : XCTestCase

@end

@implementation CityTests

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

- (void)testICanCreateACityObjectWithACityDictionary
{
    NSDictionary *cityDictionary = @{@"cityID": @2643743,
                                     @"name": @"London",
                                     @"country": @"GB"};
    
    City *result = [City cityWithCityDictionary:cityDictionary notifyDelegateOfUpdates:nil];
    
    XCTAssertEqual([cityDictionary valueForKeyPath:@"cityID"], result.cityID, @"The city should have the ID passed in the dictionary");
    XCTAssertEqual([cityDictionary valueForKeyPath:@"name"], result.name, @"The city should have the name passed in the dictionary");
    XCTAssertEqual([cityDictionary valueForKeyPath:@"country"], result.country, @"The city should have the country passed in the dictionary");
}

- (void)testICanGetACityDictionaryFromACity
{
    NSDictionary *cityDictionary = @{@"cityID": @2643743,
                                     @"name": @"London",
                                     @"country": @"GB"};
    
    City *city = [City cityWithCityDictionary:cityDictionary notifyDelegateOfUpdates:nil];
    
    NSDictionary *result = [city createCityDictionary];
    
    XCTAssertEqualObjects(cityDictionary, result, @"The city dictionary created should match the one used to create the city");
}

@end
