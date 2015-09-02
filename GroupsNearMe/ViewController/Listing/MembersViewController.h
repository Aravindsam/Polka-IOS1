//
//  MembersViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/4/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
@interface MembersViewController : UIViewController
{
    Generic *sharedObj;
    NSMutableArray *resultArray;
    NSMutableArray*tempsearchArray,*searchresults;
        int arrayindex;
    BOOL search;
}
- (IBAction)back:(id)sender;
@property(nonatomic,assign)int recordCount,pageCount;
@property (strong, nonatomic) IBOutlet UITableView *membertableView;
@property (strong, nonatomic) IBOutlet UISearchBar *thesearchbar;
@end
