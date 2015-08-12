//
//  PhotoViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/16/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "PhotoViewController.h"
#import <Parse/Parse.h>
#import "CommentViewController.h"
#import "ImageCollectionViewCell.h"
@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    photoArray=[[NSMutableArray alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CallPhotoService)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CallPhotoService) name:@"TAPPHOTO" object:nil];
    [self.photoCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"TopsListCell"];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];

    [refreshControl addTarget:self action:@selector(CallPhotoService)
             forControlEvents:UIControlEventValueChanged];
    [self.photoCollectionView addSubview:refreshControl];
    self.photoCollectionView.alwaysBounceVertical = YES;
    [self.photoCollectionView setBackgroundColor:[UIColor clearColor]];
    [self CallPhotoService];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
   }
-(void)CallPhotoService

{
    [sharedObj.photoObjectArray removeAllObjects];
    [photoArray removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
    [query whereKey:@"GroupId" equalTo:sharedObj.GroupId];
    [query whereKey:@"PostType" equalTo:@"Image"];
    [query whereKey:@"PostStatus" equalTo:@"Active"];
    [query orderByDescending:@"updatedAt"];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject*imageObject in objects) {
            PFFile *imgfile=imageObject[@"ThumbnailPicture"];
            [photoArray addObject:imgfile.url];
            sharedObj.photoObjectArray=[NSMutableArray arrayWithArray:objects];
        }
        if (photoArray.count==0) {
            _noresultlabel.hidden=NO;
            _photoCollectionView.hidden=NO;
        }
        else{
            _noresultlabel.hidden=YES;
            _photoCollectionView.hidden=NO;
        [_photoCollectionView reloadData];
        }
        [refreshControl endRefreshing];
    }];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(93.0, 93.0);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  sharedObj.photoObjectArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopsListCell" forIndexPath:indexPath];
    PFObject*photo=[sharedObj.photoObjectArray objectAtIndex:indexPath.item];
    PFFile *imgfile=photo[@"ThumbnailPicture"];
   

    //cell.photoImageView.file=imgfile;
   [imgfile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
       UIImage*tempimage=[UIImage imageWithData:data];
       cell.photoImageView.image=[self squareAndSmall:tempimage];
       [cell.photoImageView loadInBackground];
       cell.photoImageView.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];

    }];
   
    cell.photoImageView.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
   [cell.photoImageView setContentMode:UIViewContentModeCenter];
    cell.photoImageView.clipsToBounds=YES;
    return cell;
}
-(UIImage *)squareAndSmall :(UIImage*)oringinalimage{
    // fromCleverError's original
    // http://stackoverflow.com/questions/17884555
    CGSize finalsize = CGSizeMake(128,128);
    
    CGFloat scale = MAX(
                        finalsize.width/oringinalimage.size.width,
                        finalsize.height/oringinalimage.size.height);
    CGFloat width = oringinalimage.size.width * scale;
    CGFloat height = oringinalimage.size.height * scale;
    
    CGRect rr = CGRectMake( 0, 0, width, height);
    
    UIGraphicsBeginImageContextWithOptions(finalsize, NO, 0);
    [oringinalimage drawInRect:rr];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    sharedObj.feedObject=[sharedObj.photoObjectArray objectAtIndex:indexPath.item];
    [Generic sharedMySingleton].FeedId=sharedObj.feedObject.objectId;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navigationController presentViewController:settingsViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
