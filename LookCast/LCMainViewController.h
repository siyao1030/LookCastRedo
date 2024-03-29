//
//  LCMainViewController.h
//  LookCast
//
//  Created by Siyao Clara Xie on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherView.h"
#import "DetailViewController.h"
#import "PhotoParser.h"

@interface LCMainViewController : UIViewController

@property NSArray *matchedPhotos;
@property NSMutableArray *imageURLs;
@property UICollectionView *collectionView;
@property ALAssetsLibrary *library;
@property CLLocation *currentLocation;
@property Weather *currentWeather;
@property NSString *currentCity;

@property WeatherView *weatherView;
@property UIImagePickerController *camera;

@property PhotoParser *photoParser;
@property WeatherEngine *weatherEngine;
@property UIButton *takePhotoButton;

@property NSManagedObjectContext *context;
typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

-(id)initWithContext:(NSManagedObjectContext *)context;
-(void)setupWithCurrentLocation:(CLLocation *)currentLocation City:(NSString *)city;
@end

