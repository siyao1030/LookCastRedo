//
//  PhotoParser.h
//  LookCast
//
//  Created by Siyao Xie on 11/1/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WeatherPhoto.h"
#import "WeatherEngine.h"

@interface PhotoParser : NSObject

@property ALAssetsLibrary *library;
@property NSMutableArray *validPhotos;
@property NSManagedObjectContext *context;
@property WeatherEngine *weatherEngine;

- (id)initWithContext:(NSManagedObjectContext *)context;
- (void)updatePhotosWithCompletionBlock:(void (^)(void))block;
- (void)getMatchedPhotosWithCurrentWeather:(Weather *)currentWeather WithCompletionBlock:(void (^)(NSArray *))block;

@end
