//
//  WeatherPhoto.h
//  LookCast
//
//  Created by Siyao Xie on 11/1/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "Weather.h"

@interface WeatherPhoto : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) Weather * weather;

-(id)initWithUrl:(NSString *)url andLocation:(CLLocation *)location andDate:(NSDate *)date;

@end
