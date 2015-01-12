//
//  ViewController.h
//  Eats
//
//  Created by mjhowell on 12/11/14.
//  Copyright (c) 2014 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController <FBLoginViewDelegate,UITextFieldDelegate, NSURLConnectionDelegate,NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *profileID;

//Textfields which conform to delegate
@property (strong, nonatomic) IBOutlet UITextField *fname;
@property (strong, nonatomic) IBOutlet UITextField *lname;
@property (strong, nonatomic) IBOutlet UITextField *age;
@property (strong, nonatomic) IBOutlet UITextField *zipcode;

//email verification, handles: spam, invalid, and valid
@property (strong, nonatomic) IBOutlet UITextField *emailadd;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (copy, nonatomic) NSString *enteredEmailAddress;
@property (retain, nonatomic) NSMutableData *apiReturnXMLData;
@property (weak, nonatomic) IBOutlet UILabel *verificationResults;

//parsed data properties
@property (nonatomic) NSInteger statusNbr;
@property (copy, nonatomic) NSString *hygieneResult;
@property (copy, nonatomic) NSString *currentElement;

//methods conform to FBLogin Delegate
- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView;
- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
- (void) loginViewFetchedUserInfo: (FBLoginView *)loginView user: (id<FBGraphUser>)user;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *verifyContent;

@end

