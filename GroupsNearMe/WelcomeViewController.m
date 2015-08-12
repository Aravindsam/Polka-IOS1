//
//  WelcomeViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    screenheight=self.view.bounds.size.height;
    welcomeNotesArray=[[NSMutableArray alloc]initWithObjects:@"Create fun and useful groups at any location",@"Groups at location can only be found and joined by people nearby that location",@"Members can access groups from anywhere", nil];
   
   
    int cuttent=(int)self.welcomepagecontrol.currentPage;
    if (screenheight== 480) {
         _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d@2x.png",cuttent+1]];
    }
    else if (screenheight==568)
    {
         _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d-568h@2x.png",cuttent+1]];
    }
    else if (screenheight==667)
    {
          _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d@-667h2x.png",cuttent+1]];
    }
    else if (screenheight==736)
    { _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d@3x.png",cuttent+1]];
        
    }
    _backgroundimageview.userInteractionEnabled=YES;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.backgroundimageview addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.backgroundimageview addGestureRecognizer:swipeRight];
    
    // Do any additional setup after loading the view.
}


- (void)swipe:(UISwipeGestureRecognizer *)swipeRecogniser
{
    if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionLeft)
    {
        self.welcomepagecontrol.currentPage +=1;
    }
    else if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionRight)
    {
        self.welcomepagecontrol.currentPage -=1;
    }
   
    if ( self.welcomepagecontrol.currentPage==4) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SignUpViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
          }
    else
    {
        int cuttent=(int)self.welcomepagecontrol.currentPage;
        if (screenheight== 480) {
            _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d@2x.png",cuttent+1]];
        }
        else if (screenheight==568)
        {
            _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d-568h@2x.png",cuttent+1]];
        }
        else if (screenheight==667)
        {
            _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d@-667h2x.png",cuttent+1]];
        }
        else if (screenheight==736)
        { _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d@3x.png",cuttent+1]];
            
        }

        
    }
    
}


- (IBAction)changetext:(UIPageControl *)sender {
  
   
    if ( self.welcomepagecontrol.currentPage==4) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SignUpViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];   }
    else
    {
        int cuttent=(int)self.welcomepagecontrol.currentPage;
        if (screenheight== 480) {
            _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d@2x.png",cuttent+1]];
        }
        else if (screenheight==568)
        {
            _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d-568h@2x.png",cuttent+1]];
        }
        else if (screenheight==667)
        {
            _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d@-667h2x.png",cuttent+1]];
        }
        else if (screenheight==736)
        { _backgroundimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d@3x.png",cuttent+1]];
            
        }

        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
