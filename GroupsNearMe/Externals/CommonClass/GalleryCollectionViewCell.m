//
//  GalleryCollectionViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/2/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "GalleryCollectionViewCell.h"

@implementation GalleryCollectionViewCell
@synthesize galleryImageview;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        galleryImageview=[[PFImageView alloc]init];
        [self addSubview:galleryImageview];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
   
    galleryImageview.frame=CGRectMake(5, 5, 80, 80);
}

@end
