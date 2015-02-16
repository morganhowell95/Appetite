//
//  ViewController.h
//  Eats
//
//  Created by mjhowell on 12/11/14.
//  Copyright (c) 2014 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "UserProfile.h"

@interface ViewController : UIViewController <FBLoginViewDelegate,UITextFieldDelegate, NSURLConnectionDelegate,NSXMLParserDelegate, GPPSignInDelegate>

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *profileID;

//User Attributes, collected in separate model
@property (strong, nonatomic) UserProfile *user;

//Appetite server post
@property (strong, nonatomic) NSDictionary *fieldPost;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progress;

//Buttons and account messages
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *CancelButton;
@property (strong, nonatomic) IBOutlet UILabel *successMessage;

//Textfields for the creation of a new account, including email verification
@property (strong, nonatomic) IBOutlet UITextField *appetiteNameSubmission;
@property (strong, nonatomic) IBOutlet UITextField *appetiteEmailSubmission;
@property (strong, nonatomic) IBOutlet UITextField *appetitePasswordSubmission;

//Textfields for the submission of a signin with a valid account
@property (strong, nonatomic) IBOutlet UITextField *appetiteEmailAccount;
@property (strong, nonatomic) IBOutlet UITextField *appetitePassword;

//email verification, handles: spam, invalid, and valid
@property (strong, nonatomic) IBOutlet UITextField *emailadd;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (retain, nonatomic) NSMutableData *apiReturnXMLData;
@property (weak, nonatomic) IBOutlet UILabel *verificationResults;

//GooglePlus
@property (retain, nonatomic) IBOutlet GPPSignInButton *googlePlusSignIn;



//methods conform to FBLogin Delegate
- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView;
- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView;
- (void) loginViewFetchedUserInfo: (FBLoginView *)loginView user: (id<FBGraphUser>)user;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *verifyContent;

@end

