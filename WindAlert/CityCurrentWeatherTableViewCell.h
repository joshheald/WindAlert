//
//  CityCurrentWeatherTableViewCell.h
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindView.h"

@interface CityCurrentWeatherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet WindView *wind;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end
