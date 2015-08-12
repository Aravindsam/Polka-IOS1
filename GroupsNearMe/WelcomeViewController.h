//
//  WelcomeViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
@interface WelcomeViewController : UIViewController
{
    NSMutableArray *welcomeNotesArray;
    float screenheight;
}
- (IBAction)changetext:(UIPageControl *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundimageview;
@property (strong, nonatomic) IBOutlet UIPageControl *welcomepagecontrol;
@end
