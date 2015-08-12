//
//  MemberDetailViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <ParseUI/PFImageView.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "KxMenu.h"
#import <Accounts/Accounts.h>
@interface MemberDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    Generic *sharedObj;
    NSMutableArray *memberArray,*mygroupArray,*adminArray;
    int memberCount;
    BOOL MemberAdmin;
    UITapGestureRecognizer*singletap;
    SLComposeViewController *mySlcomposerView;

}
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property (strong, nonatomic) IBOutlet UIView *fullimgview;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet PFImageView *backgroundImageview;
@property(nonatomic,assign)BOOL fromFeed,fromComment;
@property(strong,nonatomic)NSString*memberNo,*memberName;
@property(strong,nonatomic)PFFile*MemberimageUrl;
@property (strong, nonatomic) IBOutlet UILabel *namelabel;
@property (strong, nonatomic) IBOutlet UILabel *joindatelbl;
@property (strong, nonatomic) IBOutlet UILabel *addinfolbel;
@property(nonatomic,assign)int indexValue;
- (IBAction)makeAdmin:(id)sender;
- (IBAction)removeMemberAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *adminBtn;
@property (strong, nonatomic) IBOutlet UIButton *removeMemberbtn;
- (IBAction)close:(id)sender;
- (IBAction)sharepic:(id)sender;
@property (strong, nonatomic) IBOutlet PFImageView *fullmemberimage;

@end
