//
//  WeatherPhoto.m
//  LookCast
//
//  Created by Siyao Xie on 11/1/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import "WeatherPhoto.h"


@implementation WeatherPhoto

@dynamic url;
@dynamic date;
@dynamic location;



-(id)initWithUrl:(NSString *)url andLocation:(CLLocation *)location andDate:(NSDate *)date {
    self = [super init];
    [self setUrl:url];
    [self setLocation:location];
    [self setDate:date];

    
    return self;
}




@end
