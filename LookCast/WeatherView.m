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

- (void)setUpWithWeatherInfo
{
    NSDictionary * weather = [WeatherEngine updateWeatherData];

    self.icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", weather[@"icon"], @".png"]]];
    [self addSubview:self.icon];
    [self.icon setFrame:CGRectMake(11, 24, 45, 38)];
    
    self.high = [[UILabel alloc]initWithFrame:CGRectMake(11, 95, 42, 44)];
    [self.high setText:[NSString stringWithFormat:@"%@",weather[@"high"]]];
    self.high.textAlignment = NSTextAlignmentLeft;
    [self.high setFont:[UIFont fontWithName:@"Helvetica" size:36]];
    self.high.textColor = [UIColor whiteColor];
    [self addSubview:self.high];
    
    self.low = [[UILabel alloc]initWithFrame:CGRectMake(265, 95, 42, 44)];
    [self.low setText:[NSString stringWithFormat:@"%@",weather[@"low"]]];
    self.low.textAlignment = NSTextAlignmentRight;
    [self.low setFont:[UIFont fontWithName:@"Helvetica" size:36]];
    self.low.textColor = [UIColor whiteColor];
    [self addSubview:self.low];
    
    //NSLog(weather[@"temp_f"]);

    
    self.current = [[UILabel alloc]initWithFrame:CGRectMake(115, 55, 85, 88)];
    [self.current setText:weather[@"temp_f"]];
    self.current.textAlignment = NSTextAlignmentCenter;
    [self.current setFont:[UIFont fontWithName:@"Helvetica" size:64]];
    self.current.textColor = [UIColor whiteColor];
    [self addSubview:self.current];
    
    
    self.location = [[UILabel alloc]initWithFrame:CGRectMake(175, 28, 141, 29)];
    [self.location setText:@"Claremont,CA"];
    self.current.textAlignment = NSTextAlignmentRight;
    [self.location setFont:[UIFont fontWithName:@"Helvetica" size:21]];
    self.location.textColor = [UIColor whiteColor];
    [self addSubview:self.location];
    
    //self.takePictureButton = [[UIButton alloc]init];
    //self.takePictureButton setFrame
    
    
    

    

    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
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
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0.5, -0.5, 320, 140)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [fillColor setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
    
    [fillColor setStroke];
    rectanglePath.lineWidth = 0.5;
    [rectanglePath stroke];
    
    
    //// Oval Drawing
    CGRect ovalRect = CGRectMake(136.5, 115.5, 48, 48);
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
