//
//  MainCollectionViewController.m
//  LookCast
//
//  Created by Siyao Clara Xie on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "MainCollectionViewController.h"

@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.imageURLs = [[NSMutableArray alloc] init];
        self.images = [[NSMutableArray alloc] init];
        self.library = [[ALAssetsLibrary alloc] init];
        
        /*
        [self.images addObject:[UIImage imageNamed:@"demo1.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo2.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo3.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo4.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo5.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo6.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo7.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo8.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo9.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo10.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo11.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo12.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo13.JPG"]];
        [self.images addObject:[UIImage imageNamed:@"demo14.JPG"]];
         */



        /*NSMutableArray *relevantPhotoItems = [Weather addWeatherDataToPhotoItems];
        for (PhotoItem * photoItem in relevantPhotoItems)
        {
            [self.imageURLs addObject:photoItem.url];
        }*/
        
    }
    return self;
}

-(void)setup {
    self.photoParser = [[PhotoParser alloc]init];
    self.photoParser.context = self.context;
    
    void (^completionBlock)(void)= ^{
        [self.collectionView reloadData];
    };

    [self.photoParser updatePhotosWithCompletionBlock:completionBlock];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoParser.validPhotos.count;
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
    WeatherPhoto * weatherPhoto = [self.photoParser.validPhotos objectAtIndex:indexPath.row];
    
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

    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 123, 320, 470) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    self.collectionView.backgroundColor = [UIColor colorWithRed:197.0/255.0 green:174.0/255.0 blue:133.0/255.0 alpha:1.0];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.collectionView];
    
    
    self.weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
    //NSDictionary * dict;
    [self.weatherView setUpWithWeatherInfo];
    self.weatherView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0];
    
    [self.view addSubview:self.weatherView];
    
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
    
    UIImage *temp = [self.photoParser.validPhotos objectAtIndex:indexPath.row];
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
