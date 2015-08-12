//
//  StarViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 7/1/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>
#import "Generic.h"
@interface StarViewController : UIViewController
{
    Generic*sharedObj;

}
@property (strong, nonatomic) IBOutlet UILabel *profilenamelbl;
@property (strong, nonatomic) IBOutlet PFImageView *profileimgview;
@property (strong, nonatomic) IBOutlet UIView *starView;
- (IBAction)back:(id)sender;
@end
