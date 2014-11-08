//
//  WeatherView.m
//  LookCast
//
//  Created by Siyao Clara Xie on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "WeatherView.h"

@implementation WeatherView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setUpWithWeatherInfoWithCurrentWeather:(Weather *)currentWeather
{
    CGRect bounds = [self bounds];

    CGFloat topPadding = 24;
    CGFloat sidePadding = 10;
    CGFloat bottomPadding = 30;
    
    self.icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", currentWeather.description, @".png"]]];
    [self addSubview:self.icon];
    [self.icon sizeToFit];
    [self.icon setFrame:CGRectMake(sidePadding, topPadding, self.icon.frame.size.width, self.icon.frame.size.height)];
    
    self.high = [[UILabel alloc] init];
    [self.high setText:currentWeather.high.stringValue];
    self.high.textAlignment = NSTextAlignmentLeft;
    [self.high setFont:[UIFont fontWithName:@"Helvetica" size:36]];
    self.high.textColor = [UIColor whiteColor];
    
    [self.high sizeToFit];
    CGRect highFrame = self.high.frame;
    highFrame.origin.x = sidePadding;
    highFrame.origin.y = bounds.size.height - highFrame.size.height - bottomPadding;
    [self.high setFrame:highFrame];
    
    [self addSubview:self.high];
    
    self.low = [[UILabel alloc] init];
    [self.low setText:currentWeather.low.stringValue];
    self.low.textAlignment = NSTextAlignmentRight;
    [self.low setFont:[UIFont fontWithName:@"Helvetica" size:36]];
    self.low.textColor = [UIColor whiteColor];
    
    [self.low sizeToFit];
    CGRect lowFrame = self.low.frame;
    lowFrame.origin.x = bounds.size.width - lowFrame.size.width - sidePadding;
    lowFrame.origin.y = bounds.size.height - lowFrame.size.height - bottomPadding;
    [self.low setFrame:lowFrame];
    
    [self addSubview:self.low];
    
    
    self.current = [[UILabel alloc] init];
    [self.current setText:[NSString stringWithFormat:@"%d", currentWeather.currentTemp.intValue]];
    self.current.textAlignment = NSTextAlignmentCenter;
    [self.current setFont:[UIFont fontWithName:@"Helvetica" size:64]];
    self.current.textColor = [UIColor whiteColor];
    
    [self.current sizeToFit];
    CGRect currentFrame = self.current.frame;
    currentFrame.origin.x = rintf((bounds.size.width - currentFrame.size.width) / 2.0);
    currentFrame.origin.y = bounds.size.height - currentFrame.size.height - bottomPadding;
    [self.current setFrame:currentFrame];
    [self addSubview:self.current];
    
    
    self.location = [[UILabel alloc] init];
    [self.location setText:currentWeather.location];
    self.current.textAlignment = NSTextAlignmentRight;
    [self.location setFont:[UIFont fontWithName:@"Helvetica" size:21]];
    self.location.textColor = [UIColor whiteColor];
    
    [self.location sizeToFit];
    CGRect locationFrame = self.location.frame;
    locationFrame.origin.x = bounds.size.width - locationFrame.size.width - sidePadding;
    locationFrame.origin.y = topPadding;
    [self.location setFrame:locationFrame];
    [self addSubview:self.location];
    
    //self.takePictureButton = [[UIButton alloc]init];
    //self.takePictureButton setFrame
    
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = [self bounds];
    // Drawing code
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.353 green: 0.801 blue: 0.811 alpha: 1];
    UIColor* color = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
    
    //// Shadow Declarations
    UIColor* shadow = color;
    CGSize shadowOffset = CGSizeMake(0.1, 3.1);
    CGFloat shadowBlurRadius = 5;
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0.5, -0.5, bounds.size.width, 140)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [fillColor setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
    
    [fillColor setStroke];
    rectanglePath.lineWidth = 0.5;
    [rectanglePath stroke];
    
    
    //// Oval Drawing
    CGRect ovalRect = CGRectMake((bounds.size.width-48)/2.0, 115.5, 48, 48);
    UIBezierPath* ovalPath = [UIBezierPath bezierPath];
    [ovalPath addArcWithCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)) radius: CGRectGetWidth(ovalRect) / 2 startAngle: 0 * M_PI/180 endAngle: 180 * M_PI/180 clockwise: YES];
    [ovalPath addLineToPoint: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect))];
    [ovalPath closePath];
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [fillColor setFill];
    [ovalPath fill];
    CGContextRestoreGState(context);
    
    [fillColor setStroke];
    ovalPath.lineWidth = 0.5;
    [ovalPath stroke];
    

}


@end
