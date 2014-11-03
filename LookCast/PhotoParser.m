//
//  PhotoParser.m
//  LookCast
//
//  Created by Siyao Xie on 11/1/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import "PhotoParser.h"

@implementation PhotoParser

- (id)init {
    self.library = [[ALAssetsLibrary alloc] init];
    self.validPhotos = [[NSMutableArray alloc] init];
    
    return self;
}

- (NSMutableArray *)getMatchedPhotosWithCurrentWeather:(Weather *)currentWeather {
    NSMutableArray * matchedPhotos = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.validPhotos.count; i++) {
        if (matchedPhotos.count < 20) {
            WeatherPhoto * currentPhoto = [self.validPhotos objectAtIndex:i];
            if ([currentPhoto.weather getSimilarityScoreWith:currentWeather]) {
                <#statements#>
            }
        }
    }
}
- (void)updatePhotosWithCompletionBlock:(void (^)(void))block {
    void (^ assetGroupEnumerator)(ALAssetsGroup *group, BOOL *stop) = ^(ALAssetsGroup *group, BOOL *stop){
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result)
        {
            if ([self.validPhotos count] <= 5) {
                if ([self isValidPhoto:result]) {
                    NSURL *photoURL = [result valueForProperty:ALAssetPropertyAssetURL];
                    CLLocation *photoLocation = [result valueForProperty:ALAssetPropertyLocation];
                    NSDate *photoDate = [result valueForProperty:ALAssetPropertyDate];
                    
                    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WeatherPhoto" inManagedObjectContext:self.context];
                    WeatherPhoto *temp = [[WeatherPhoto alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.context];

                    [temp setUrl:[photoURL absoluteString]];
                    [temp setLocation:photoLocation];
                    [temp setDate:photoDate];

                    [WeatherEngine addWeatherDataToPhoto:temp];
                    
                    if (![self.validPhotos containsObject:temp]) {
                        [self.validPhotos addObject:temp];
                    } else {
                        
                        block();
                    }
                }
            } else {
                block();
            }
        } else {
            block();
        }
    }];};
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                usingBlock:assetGroupEnumerator
                              failureBlock:^(NSError *error) {
                                    NSLog(@"Error: %@", error);
                                }
     ];
    

}

- (void)sortValidPhotos {
    
}
- (BOOL)isValidPhoto:(ALAsset *)photo {
    if ([self isJPEG:photo] && [self hasFaces:photo]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)hasFaces:(ALAsset *)photo {
    ALAssetRepresentation *assetRepresentation = [photo defaultRepresentation];
    CGImageRef cgImageRef = [assetRepresentation fullResolutionImage];
    CIImage *ciImage = [CIImage imageWithCGImage:cgImageRef];
    
    int exifOrientation;
    ALAssetOrientation orientation = [[photo defaultRepresentation] orientation];
    
    switch (orientation) {
        case UIImageOrientationUp:
            exifOrientation = 1;
            break;
        case UIImageOrientationDown:
            exifOrientation = 3;
            break;
        case UIImageOrientationLeft:
            exifOrientation = 8;
            break;
        case UIImageOrientationRight:
            exifOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            exifOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            exifOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            exifOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
    }
    
    
    NSDictionary* detectorOptions = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
    
    NSDictionary* featureOptions = @{ CIDetectorImageOrientation : [NSNumber numberWithInt:exifOrientation] };
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    NSArray *features = [detector featuresInImage:ciImage options:featureOptions];
    
    if([features count] > 0){
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isJPEG:(ALAsset *)photo {
    NSArray *photoTypes = [photo valueForProperty:ALAssetPropertyRepresentations];
    if ([photoTypes containsObject:@"public.jpeg"]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
