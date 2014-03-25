//
//  WindView.m
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "WindView.h"

@interface WindView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *directionImageView;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (strong, nonatomic) UIImage *unknownImage;
@property (strong, nonatomic) UIImage *directionImage;

@end

@implementation WindView

- (void)awakeFromNib {
    NSString *nibName = @"WindView";
    if ([self isUsingSmallView]) {
        nibName = @"WindViewSmall";
    }
    
    [self setImages];
    
    [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    [self addSubview: self.contentView];
    
    [self.directionImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
}

- (BOOL)isUsingSmallView
{
    CGSize fullSize = CGSizeMake(45, 45);
    return (self.frame.size.width < fullSize.width || self.frame.size.height < fullSize.width);
}

- (void)setImages
{
    if ([self isUsingSmallView]) {
        self.unknownImage = [UIImage imageNamed:@"WindDirectionSpeedUnknownSmall"];
        self.directionImage = [UIImage imageNamed:@"WindDirectionSpeedSmall"];
    } else {
        self.unknownImage = [UIImage imageNamed:@"WindDirectionSpeedUnknown"];
        self.directionImage = [UIImage imageNamed:@"WindDirectionSpeed"];
    }
}

#define CARDINAL_DIRECTION_TO_RADIANS(direction) ((direction * 22.5) / 180.0 * M_PI)
- (void)setDirection:(CardinalDirections)direction
{
    _direction = direction;
    
    self.directionImageView.image = self.directionImage;
    
    double rads = CARDINAL_DIRECTION_TO_RADIANS(direction);
    self.directionImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
}

- (void)setSpeed:(NSNumber *)speed
{
    if ([self isUsingSmallView]) {
        [self setHidden:!speed];
    }
    if (speed) {
        self.speedLabel.text = [NSNumberFormatter localizedStringFromNumber:speed numberStyle:NSNumberFormatterNoStyle];
    } else {
        self.speedLabel.text = @"?";
        self.directionImageView.image = self.unknownImage;
    }
}

- (void)reset
{
    self.direction = CardinalDirectionNorth;
    self.speed = nil;
    self.directionImageView.image = self.unknownImage;
}

@end
