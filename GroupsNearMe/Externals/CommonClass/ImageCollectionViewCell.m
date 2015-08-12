//
//  ImageCollectionViewCell.m
//  FBLikeLayout Sample
//
//  Created by Giuseppe Lanza on 18/01/15.
//  Copyright (c) 2015 La Nuova Era. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell
@synthesize photoImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.photoImageView=[[PFImageView alloc]initWithFrame:CGRectMake(0,0,93,93)];
        

        [self addSubview:self.photoImageView];
    }
    //[self.starLabel setBackgroundColor:[UIColor yellowColor]];
    return self;
    
}
- (void)prepareForReuse
{
    [super prepareForReuse];
}
@end
