//
//  HourlyWindView.h
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindView.h"

@interface HourlyWindView : UIView

@property (weak, nonatomic) IBOutlet WindView *windView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
