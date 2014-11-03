//
//  WeatherEngine.h
//  LookCast
//
//  Created by Siyao Xie on 11/2/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherPhoto.h"


@interface WeatherEngine : NSObject <CLLocationManagerDelegate>

@property float latitude;
@property float longitude;

+ (NSDictionary *)updateWeatherData;
+ (void)addWeatherDataToPhoto:(WeatherPhoto *)photo;

@end
