//
//  PhotoParser.m
//  LookCast
//
//  Created by Siyao Xie on 11/1/14.
//  Copyright (c) 2014 siyao. All rights reserved.
//

#import "PhotoParser.h"

@implementation PhotoParser

- (id)initWithContext:(NSManagedObjectContext *)context {
    self.library = [[ALAssetsLibrary alloc] init];
    self.validPhotos = [[NSMutableArray alloc] init];
    self.weatherEngine = [[WeatherEngine alloc] init];
    
    self.context = context;
    // load saved photos or process new ones for display
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WeatherPhoto" inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [self setValidPhotos:[NSMutableArray arrayWithArray:array]];
    }

    return self;
}


- (NSArray *)sortArray:(NSMutableArray *)array forK:(NSUInteger)K withCurrentWeather:(Weather *)currentWeather
{
    NSMutableArray *resultArray = [array mutableCopy];
    NSUInteger count = resultArray.count;
    //NSParameterAssert(K <= count);
    
    NSUInteger minIndex;
    float minValue;
    
    for (NSUInteger i = 0; i < MIN(K, count); i++) {
        minIndex = i;
        WeatherPhoto * photoi = resultArray[i];
        minValue = [photoi.weather getSimilarityScoreWith:currentWeather];
        
        for (NSUInteger j = i + 1; j < count; j++) {
            WeatherPhoto * photoj = resultArray[i];
            float valuej = [photoj.weather getSimilarityScoreWith:currentWeather];
            
            if (valuej < minValue) {
                minIndex = j;
                minValue = valuej;
            }
        }
        
        [resultArray exchangeObjectAtIndex:i withObjectAtIndex:minIndex];
    }
    
    
    return [resultArray subarrayWithRange:NSMakeRange(0, MIN(K-1,resultArray.count))];
    
}

- (void)getMatchedPhotosWithCurrentWeather:(Weather *)currentWeather WithCompletionBlock:(void (^)(NSArray *))block {
    NSArray *result = nil;
    result = [self sortArray:self.validPhotos forK:10 withCurrentWeather:currentWeather];

    if (result != nil) {
        block(result);
    }
}

//todo should always check for new photos and update
- (void)updatePhotosWithCompletionBlock:(void (^)(void))block {
    void (^ assetGroupEnumerator)(ALAssetsGroup *group, BOOL *stop) = ^(ALAssetsGroup *group, BOOL *stop){
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result)
        {
            
            if ([self isValidPhoto:result]) {
                NSURL *photoURL = [result valueForProperty:ALAssetPropertyAssetURL];
                CLLocation *photoLocation = [result valueForProperty:ALAssetPropertyLocation];
                NSDate *photoDate = [result valueForProperty:ALAssetPropertyDate];
                
                
                NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WeatherPhoto" inManagedObjectContext:self.context];
                WeatherPhoto *temp = [[WeatherPhoto alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.context];

                [temp setUrl:[photoURL absoluteString]];
                [temp setLocation:photoLocation];
                [temp setDate:photoDate];

                [self.weatherEngine addWeatherDataToPhoto:temp];
                
                if (![self.validPhotos containsObject:temp]) {
                    [self.validPhotos addObject:temp];
                    if (self.validPhotos.count >=20) {
                        // stop because we have enough for testing right now
                        *stop = YES;
                        //block();
                    }
                } else {
                    // stop because we have gone through all the new photos
                    *stop = YES;
                    //block();
                }
            }
        } else {
            // stop because there are no more photos
            *stop = YES;
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


- (BOOL)isValidPhoto:(ALAsset *)photo {
    if ([self isJPEG:photo] && [self hasFaces:photo] && [self hasLocation:photo]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)hasLocation:(ALAsset *)photo {
    return ([photo valueForProperty:ALAssetPropertyLocation] != nil);
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
