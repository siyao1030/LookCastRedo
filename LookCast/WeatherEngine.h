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
#import "ForecastKit.h"



@interface WeatherEngine : NSObject <CLLocationManagerDelegate>

@property float latitude;
@property float longitude;
@property CLLocation *currentLocation;
@property ForecastKit *forecast;

-(Weather *)currentWeatherAtCurrentLocation;
- (void)currentWeatherForLocation:(CLLocation *)location City:(NSString *)city withCompletionBlock:(void (^)(Weather *))block;
+ (NSDictionary *)updateWeatherData;
- (void)addWeatherDataToPhoto:(WeatherPhoto *)photo;

@end
