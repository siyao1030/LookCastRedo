//
//  Weather.h
//  LookCast
//
//  Created by Siyao Xie on 11/2/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Weather : NSObject

//current
@property (nonatomic, retain) NSNumber * currentTemp;
@property (nonatomic, retain) NSNumber * feelLikeTemp;
@property (nonatomic, retain) NSString * description;

//current and history
@property (nonatomic, retain) NSNumber * high;
@property (nonatomic, retain) NSNumber * low;
@property (nonatomic, retain) NSNumber * chanceOfRain;

//history
@property (nonatomic, retain) NSNumber * mean;

-(float)getSimilarityScoreWith:(Weather *)anotherWeather;

@end
