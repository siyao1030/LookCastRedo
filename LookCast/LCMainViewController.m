//
//  MainCollectionViewController.m
//  LookCast
//
//  Created by Siyao Clara Xie on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "LCMainViewController.h"

@interface LCMainViewController ()

@end

@implementation LCMainViewController

- (id)initWithContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        // Custom initialization

        self.context = context;
        
        self.photoParser = [[PhotoParser alloc] initWithContext:self.context];
        [self.photoParser updatePhotosWithCompletionBlock:^{
            [self _getMatchedPhotos];
        }];
        
        self.imageURLs = [[NSMutableArray alloc] init];
        self.library = [[ALAssetsLibrary alloc] init];
        self.weatherEngine = [[WeatherEngine alloc] init];
    }
    return self;
}

//set up flow
//1 get current location
//2 get current weather and update weather view (1)
//3 update valid photos ()
//4 get matched photos (2 and 3)


-(void)_getWeatherWithCompletion:(void (^)(Weather *))block
{
    if (self.currentLocation != nil) {
        [self.weatherEngine currentWeatherForLocation:self.currentLocation City:self.currentCity withCompletionBlock:block];
    } else {
        NSLog(@"ERROR: location is nil");
    }
}

-(void)_getMatchedPhotos {
    void (^loadDataBlock)(NSArray *)= ^(NSArray *result){
        self.matchedPhotos = result;
        [self.collectionView reloadData];
    };
    
    if (self.currentWeather) {
        [self.photoParser getMatchedPhotosWithCurrentWeather:self.currentWeather WithCompletionBlock:loadDataBlock];
    } else {
        [self _getWeatherWithCompletion:^(Weather * currentWeather){
            self.currentWeather = currentWeather;
            [self.weatherView setUpWithWeatherInfoWithCurrentWeather:self.currentWeather];
            [self _getMatchedPhotos];
            
        }];
    }
    
}

-(void)setupWithCurrentLocation:(CLLocation *)currentLocation City:(NSString *)city {
    self.currentLocation = currentLocation;
    self.currentCity = city;
    
    [self _getWeatherWithCompletion:^(Weather * currentWeather){
        self.currentWeather = currentWeather;
        [self.weatherView setUpWithWeatherInfoWithCurrentWeather:self.currentWeather];
        [self _getMatchedPhotos];

    }];
    
}

/*
-(void)setupWithCurrentLocation:(CLLocation *)currentLocation City:(NSString *)city {
    self.currentLocation = currentLocation;
    self.currentCity = city;
    
    void (^loadDataBlock)(NSArray *)= ^(NSArray *result){
        self.matchedPhotos = result;
        [self.collectionView reloadData];
        return;
    };
    
    void (^getMatchedPhotoBlock)(void)= ^{
        return [self.photoParser getMatchedPhotosWithCurrentWeather:self.currentWeather WithCompletionBlock:loadDataBlock];
    };

    void (^setWeatherBlock)(Weather *)= ^(Weather *currentWeather){
        // update current weather and view
        self.currentWeather = currentWeather;
        [self.weatherView setUpWithWeatherInfoWithCurrentWeather:self.currentWeather];

        // load saved photos or process new ones for display
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WeatherPhoto" inManagedObjectContext:self.context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        NSError *error;
        NSArray *array = [self.context executeFetchRequest:request error:&error];
        if (array == nil)
        {
            NSLog(@"%@", [error localizedDescription]);
        } else if ([array count] == 0) {
            // no photos has been parsed, start fresh!
            [self.photoParser updatePhotosWithCompletionBlock:getMatchedPhotoBlock];
        } else {
            [self.photoParser setValidPhotos:[NSMutableArray arrayWithArray:array]];
            [self.photoParser getMatchedPhotosWithCurrentWeather:self.currentWeather WithCompletionBlock:loadDataBlock];
        }

    };
    
    if (self.currentLocation != nil) {
        [self.weatherEngine currentWeatherForLocation:self.currentLocation City:city withCompletionBlock:setWeatherBlock];
    }

}*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.matchedPhotos.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    for (UIView *subView in [cell subviews]) {
        [subView removeFromSuperview];
    }
    
    // Configure the cell...
    WeatherPhoto * weatherPhoto = [self.matchedPhotos objectAtIndex:indexPath.row];
    
    [self.library assetForURL:[NSURL URLWithString:weatherPhoto.url] resultBlock:^(ALAsset *asset)
     {
         UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:0.5 orientation:UIImageOrientationUp];
         
         cell.backgroundView = [[UIImageView alloc] initWithImage:copyOfOriginalImage];
         
     }
            failureBlock:^(NSError *error)
     {
         // error handling
         NSLog(@"failure-----");
     }];

    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

/*
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *tempurl = [NSURL URLWithString:[self.urls objectAtIndex:indexPath.row]];
    NSData *tempdata = [NSData dataWithContentsOfURL:tempurl];
    UIImage *tempimage = [UIImage imageWithData:tempdata];
    
    [self.navigationController pushViewController:self.filterView animated:YES];
    [self.filterView setup:tempimage andCreateView:self.createView];
    //self.filterView.createView = self.createView;
}
*/

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    CGRect bounds = [[self view] bounds];
    self.weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 170)];
    self.weatherView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0];
    
    [self.view addSubview:self.weatherView];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 123, bounds.size.width, bounds.size.height - [self.weatherView frame].size.height) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    self.collectionView.backgroundColor = [UIColor colorWithRed:197.0/255.0 green:174.0/255.0 blue:133.0/255.0 alpha:1.0];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.view insertSubview:self.collectionView belowSubview:self.weatherView];
    
    
    
    
    self.takePhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(145, 128, 31, 31)];
    [self.takePhotoButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [self.takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    self.camera = [[UIImagePickerController alloc] init];
    self.camera.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.camera  setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.camera setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        [self.camera setShowsCameraControls:YES];
    }
    
    [self.view addSubview:self.takePhotoButton];
    
    
    
	// Do any additional setup after loading the view.
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImage *temp = [self.matchedPhotos objectAtIndex:indexPath.row];
    //NSLog(temp);
    // Navigation logic may go here. Create and push another view controller.
    
    DetailViewController *imageDetail = [[DetailViewController alloc]init];
    UIImageView *imageDetailView = [[UIImageView alloc] initWithFrame:CGRectMake(0,120,320,350)];
    imageDetail.view.backgroundColor = [UIColor colorWithRed:197.0/255.0 green:174.0/255.0 blue:133.0/255.0 alpha:1.0];

    [imageDetailView setImage:temp];
    [imageDetailView setContentMode:UIViewContentModeScaleAspectFit];
    [imageDetail.view addSubview:imageDetailView];
//    imageDetail.view.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.navigationController pushViewController:imageDetail animated:YES];


}


-(void)takePhoto
{
    
    [self presentViewController:self.camera animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
