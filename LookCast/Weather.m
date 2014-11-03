//
//  Weather.m
//  LookCast
//
//  Created by Siyao Xie on 11/2/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import "Weather.h"

@implementation Weather

@synthesize high;
@synthesize low;
@synthesize chanceOfRain;
@synthesize feelLikeTemp;
@synthesize currentTemp;

@synthesize description;
@synthesize mean;

float _highDiffWeight = 0.3;
float _lowDiffWeight = 0.35;
float _rainWeight = 0.35;



-(float)getSimilarityScoreWith:(Weather *)anotherWeather {
    float highDiff = abs(self.high.floatValue - anotherWeather.high.floatValue);
    float lowDiff = abs(self.low.floatValue - anotherWeather.low.floatValue);
    float rainDiff = abs(self.chanceOfRain.floatValue - anotherWeather.chanceOfRain.floatValue);
    
    return highDiff*_highDiffWeight + lowDiff*_lowDiffWeight + rainDiff*_rainWeight;
}
@end
