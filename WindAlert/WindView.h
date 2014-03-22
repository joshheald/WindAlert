//
//  WindView.h
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenWeatherFetcherHelper.h"
@interface WindView : UIView

@property (strong, nonatomic) NSNumber *speed;
@property (nonatomic) CardinalDirections direction;

@end
