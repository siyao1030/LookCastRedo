//
//  WeatherView.h
//  LookCast
//
//  Created by Siyao Clara Xie on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherEngine.h"

@interface WeatherView : UIView

@property UIImageView * icon;
@property UILabel * high;
@property UILabel * low;
@property UILabel * current;
@property UILabel * location;
@property UIButton * takePictureButton;
@property UIImagePickerController *camera;


- (void)setUpWithWeatherInfo;


@end
