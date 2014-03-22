//
//  ForecastsForDayTableViewCell.h
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindView.h"

@interface ForecastsForDayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet WindView *wind;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
