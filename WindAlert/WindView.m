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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

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
    CGSize smallSize = CGSizeMake(36, 36);
    return (self.frame.size.width == smallSize.width && self.frame.size.height == smallSize.width);
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
    self.speedLabel.text = [NSString stringWithFormat:@"%i", [speed integerValue]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
