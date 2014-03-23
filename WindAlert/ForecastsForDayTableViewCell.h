//
//  ForecastsForDayTableViewCell.h
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindView.h"
#import "DayForecasts.h"

@interface ForecastsForDayTableViewCell : UITableViewCell

@property (strong, nonatomic) DayForecasts *forecasts;

- (void)showHourlyForecasts:(BOOL)show;

- (void)resetForecasts;

@end
