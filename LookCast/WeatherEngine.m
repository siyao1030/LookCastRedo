//
//  WeatherEngine.m
//  LookCast
//
//  Created by Siyao Xie on 11/2/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import "WeatherEngine.h"

@implementation WeatherEngine {
    CLLocationManager *locationManager;
}

- (id) init
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    NSString *apiKey = @"254c81a25ff9f00de42c3600a8e6d3a2";
    self.forecast = [[ForecastKit alloc] initWithAPIKey:apiKey];
    
    return self;
}


+ (Weather *)weatherForLocation:(CLLocation *)location date:(NSDate *)date
{
    Weather * weather = [[Weather alloc] init];
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    NSString *urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/b02d00370341149d/history_20060405/q/%3.4f,%3.4f.json", latitude, longitude];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSError *error;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableDictionary *summary = result[@"history"][@"dailysummary"][0];
    [weather setLow:[NSNumber numberWithFloat: [summary[@"mintempi"] floatValue]]];
    [weather setHigh:[NSNumber numberWithFloat: [summary[@"maxtempi"] floatValue]]];
    [weather setChanceOfRain:[NSNumber numberWithFloat: [summary[@"rain"] floatValue]]];
    
    return weather;
}


// Current Weather in location
- (void)currentWeatherForLocation:(CLLocation *)location City:(NSString *)city withCompletionBlock:(void (^)(Weather *))block
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;

    

    [self.forecast getCurrentWeatherInfoForLatitude:latitude longitude:longitude success:^(NSMutableDictionary *currentDict, NSMutableDictionary *todayDict) {
        Weather * currentWeather = [[Weather alloc] init];
        //current
        [currentWeather setCurrentTemp:[NSNumber numberWithFloat:[currentDict[@"temperature"] floatValue]]];
        [currentWeather setLocation:city];
        
        //today
        //Precipitation in inches
        [currentWeather setChanceOfRain:[NSNumber numberWithFloat:[todayDict[@"precipProbability"] floatValue]]];
        //Icon name, somethinglike partlycloudy
        [currentWeather setDescription:currentDict[@"icon"]];
        
        NSString *high = todayDict[@"apparentTemperatureMax"];
        NSString *low = todayDict[@"apparentTemperatureMin"];
        [currentWeather setHigh:[NSNumber numberWithInteger:[high integerValue]]];
        [currentWeather setLow:[NSNumber numberWithInteger:[low integerValue]]];
        NSLog(@"%@", currentDict);
        NSLog(@"%@", todayDict);
        
        block(currentWeather);
    } failure:^(NSError *error){
        
        NSLog(@"Currently %@", error.description);
        
    }];
    
}


// weather underground
/*
 + (Weather *)weatherForLocation:(CLLocation *)location date:(NSDate *)date
 {
 Weather * weather = [[Weather alloc] init];
 float latitude = location.coordinate.latitude;
 float longitude = location.coordinate.longitude;
 NSString *urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/b02d00370341149d/history_20060405/q/%3.4f,%3.4f.json", latitude, longitude];
 
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
 NSError *error;
 NSURLResponse *response = nil;
 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 
 NSMutableDictionary *summary = result[@"history"][@"dailysummary"][0];
 [weather setLow:[NSNumber numberWithFloat: [summary[@"mintempi"] floatValue]]];
 [weather setHigh:[NSNumber numberWithFloat: [summary[@"maxtempi"] floatValue]]];
 [weather setChanceOfRain:[NSNumber numberWithFloat: [summary[@"rain"] floatValue]]];
 
 return weather;
 }

 
// Current Weather in location
- (Weather *)currentWeatherForLocation:(CLLocation *)location
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    NSString *requestURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/b02d00370341149d/conditions/q/%3.4f,%3.4f.json", latitude, longitude];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    
    Weather * currentWeather = [[Weather alloc] init];
    [currentWeather setCurrentTemp:[NSNumber numberWithFloat:[result[@"current_observation"][@"temp_f"] floatValue]]];
    [currentWeather setLocation:result[@"current_observation"][@"display_location"][@"full"]];
    //Precipitation in inches
    [currentWeather setChanceOfRain:[NSNumber numberWithFloat:[result[@"current_observation"][@"precip_today_in"] floatValue]]];
    //Icon name, somethinglike partlycloudy
    [currentWeather setDescription:result[@"current_observation"][@"icon"]];
    
    NSString *requestForecastURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/b02d00370341149d/forecast/q/%3.4f,%3.4f.json", latitude, longitude];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestForecastURL]];
    response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSString *high = result[@"forecast"][@"simpleforecast"][@"forecastday"][0][@"high"][@"fahrenheit"];
    NSString *low = result[@"forecast"][@"simpleforecast"][@"forecastday"][0][@"low"][@"fahrenheit"];
    
    [currentWeather setHigh:[NSNumber numberWithInteger:[high integerValue]]];
    [currentWeather setLow:[NSNumber numberWithInteger:[low integerValue]]];
    
    return currentWeather;
}

// Current Weather in current location
+ (NSMutableDictionary *)weatherForLocation:(CLLocation *)location
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    NSString *requestURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/b02d00370341149d/conditions/q/%3.4f,%3.4f.json", latitude, longitude];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    
    NSString *temp_f_long = [NSString stringWithFormat:@"%@",(result[@"current_observation"][@"temp_f"])];
    NSString *temp_f = [temp_f_long substringToIndex:[temp_f_long length]-2];
    //result[@"current_observation"][@"temp_f"];
    //Precipitation in inches
    NSString *precipitation = result[@"current_observation"][@"precip_today_in"];
    //Icon name, somethinglike partlycloudy
    NSString *icon = result[@"current_observation"][@"icon"];
    
    NSMutableDictionary *weather = [NSMutableDictionary dictionary];
    weather[@"temp_f"] = temp_f;
    if (precipitation > 0) {
        weather[@"precipitation"] = [NSNumber numberWithInt: 1];
    } else {
        weather[@"precipitation"] = [NSNumber numberWithInt: 0];
    }
    weather[@"icon"] = icon;
    
    NSString *requestForecastURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/b02d00370341149d/forecast/q/%3.4f,%3.4f.json", latitude, longitude];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestForecastURL]];
    response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSString *high = result[@"forecast"][@"simpleforecast"][@"forecastday"][0][@"high"][@"fahrenheit"];
    NSString *low = result[@"forecast"][@"simpleforecast"][@"forecastday"][0][@"low"][@"fahrenheit"];
    weather[@"high"] = [NSNumber numberWithInteger:[high integerValue]];
    weather[@"low"] = [NSNumber numberWithInteger:[low integerValue]];
    
    return weather;
}
 
 */

+ (void)addWeatherDataToPhoto:(WeatherPhoto *)photo {
    Weather * weather = [self weatherForLocation:photo.location date:photo.date];
    NSLog(@"weather:%@, %@ at %f, %f", weather.high, weather.low, ((CLLocation *)photo.location).coordinate.latitude, ((CLLocation *)photo.location).coordinate.latitude);
    [photo setWeather:weather];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
}

@end
