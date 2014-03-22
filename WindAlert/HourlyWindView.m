//
//  HourlyWindView.m
//  WindAlert
//
//  Created by Josh on 22/03/2014.
//  Copyright (c) 2014 Josh Heald. All rights reserved.
//

#import "HourlyWindView.h"

@interface HourlyWindView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation HourlyWindView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"HourlyWindView" owner:self options:nil];
        [self addSubview: self.contentView];
    }
    return self;
}

- (void)awakeFromNib {
    [[NSBundle mainBundle] loadNibNamed:@"HourlyWindView" owner:self options:nil];
    [self addSubview: self.contentView];
    
    //[self.directionImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
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
