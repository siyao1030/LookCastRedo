//
//  MainCollectionViewController.h
//  LookCast
//
//  Created by Siyao Clara Xie on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherView.h"
#import "DetailViewController.h"
#import "PhotoParser.h"

@interface MainCollectionViewController : UIViewController

@property NSMutableArray *images;
@property NSMutableArray *imageURLs;
@property UICollectionView *collectionView;
@property ALAssetsLibrary *library;

@property WeatherView *weatherView;
@property UIImagePickerController *camera;

@property PhotoParser *photoParser;
@property UIButton *takePhotoButton;

@property NSManagedObjectContext *context;
typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

-(void)setup;
@end

