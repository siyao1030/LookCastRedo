//
//  Weather.m
//  LookCast
//
//  Created by Siyao Xie on 11/2/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import "Weather.h"

@implementation Weather

@synthesize location;
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


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.high forKey:@"high"];
    [encoder encodeObject:self.low forKey:@"low"];
    [encoder encodeObject:self.chanceOfRain forKey:@"chanceOfRain"];
    [encoder encodeObject:self.feelLikeTemp forKey:@"feelLikeTemp"];
    [encoder encodeObject:self.currentTemp forKey:@"currentTemp"];
    [encoder encodeObject:self.mean forKey:@"mean"];
    [encoder encodeObject:self.description forKey:@"description"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [[Weather alloc]init];
    
    [self setHigh:[decoder decodeObjectForKey:@"high"]];
    [self setLow:[decoder decodeObjectForKey:@"low"]];
    [self setLocation:[decoder decodeObjectForKey:@"location"]];
    [self setChanceOfRain:[decoder decodeObjectForKey:@"chanceOfRain"]];
    [self setFeelLikeTemp:[decoder decodeObjectForKey:@"feelLikeTemp"]];
    [self setCurrentTemp:[decoder decodeObjectForKey:@"currentTemp"]];
    [self setMean:[decoder decodeObjectForKey:@"mean"]];
    [self setDescription:[decoder decodeObjectForKey:@"description"]];

    return self;
}

-(float)getSimilarityScoreWith:(Weather *)anotherWeather {
    float highDiff = abs(self.high.floatValue - anotherWeather.high.floatValue);
    float lowDiff = abs(self.low.floatValue - anotherWeather.low.floatValue);
    float rainDiff = abs(self.chanceOfRain.floatValue - anotherWeather.chanceOfRain.floatValue);
    
    return highDiff*_highDiffWeight + lowDiff*_lowDiffWeight + rainDiff*_rainWeight;
}
@end
