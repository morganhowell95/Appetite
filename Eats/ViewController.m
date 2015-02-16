//
//  ViewController.m
//  Eats
//
//  Created by mjhowell on 12/11/14.
//  Copyright (c) 2014 Guru. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppetiteChoiceViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#define APP_URL @"http://site-cater.rhcloud.com/"
#define kGooglePlus @"498208626822-cf0pue9k6vqnn4mqte69uf2gcdsnipht.apps.googleusercontent.com"
#import "SWRevealViewController.h"

@interface ViewController ()
{
    BOOL _viewDidAppear;
    BOOL _viewIsVisible;
    NSURLConnection *currentConnection;
    NSXMLParser *xmlParser;
}

@end

@implementation ViewController
@synthesize loginView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //fb login view intialization
//    [self setLoginView:[[FBLoginView alloc] init]];
//    loginView.center = self.view.center;
//    [self.view addSubview:loginView];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    if([self isSessionOpen]){
        NSLog(@"Login Success");
    }
    
    //GooglePlus SignIn Initialization
    //self.googlePlusSignIn.frame = CGRectMake(231, 271, 45, 45);
    GPPSignIn *googlePlus = [GPPSignIn sharedInstance];
    googlePlus.shouldFetchGooglePlusUser = YES;
    googlePlus.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    googlePlus.clientID = kGooglePlus;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    googlePlus.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    googlePlus.scopes = @[ @"profile", @"email"];            // "profile" scope
    
    //delegates connected and submission setup
    self.appetitePasswordSubmission.secureTextEntry=YES;
    self.appetitePassword.secureTextEntry=YES;
    self.emailadd.delegate=self;
    self.appetitePassword.delegate=self;
    self.appetiteEmailAccount.delegate=self;
    self.appetitePasswordSubmission.delegate=self;
    self.appetiteEmailSubmission.delegate=self;
    self.appetiteNameSubmission.delegate=self;
    googlePlus.delegate = self;
    loginView.delegate = self;
   // self.loginView.frame = CGRectMake(121, 271, 45, 45);
    
    //round edges on buttons on create account page
    self.submitButton.layer.cornerRadius=10;
    self.submitButton.clipsToBounds=YES;
    self.CancelButton.layer.cornerRadius=10;
    self.CancelButton.clipsToBounds=YES;
    self.successMessage.text=@"";
   
    self.user = [[UserProfile alloc] init];
    self.progress.hidden=YES;
    [self.progress stopAnimating];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //AppetiteChoiceViewController *dest = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"account_created"] || [segue.identifier isEqualToString:@"login_verified"]){
        //sift through the first object held in the navigation controller (AppetiteChoiceViewController)
        //UINavigationController *navigationController = segue.destinationViewController;
        //AppetiteChoiceViewController *dest = (AppetiteChoiceViewController * )navigationController.topViewController;
        SWRevealViewController *dest = (SWRevealViewController *) segue.destinationViewController;
        dest.user = self.user;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)emailTextField {
    [emailTextField resignFirstResponder];
    return YES;
}
- (IBAction)logInSubmission:(id)sender {

    //submit button triggers email address being captured in UIField
    self.user.email = self.appetiteEmailAccount.text;
    self.user.password = self.appetitePassword.text;
    NSString *login_url = [NSString stringWithFormat:@"%@user/login/",APP_URL];
    self.progress.hidden=NO;
    [self.progress startAnimating];
    NSLog(@"user logging in \"%@\"", self.user.email);
    
    //Opening HTTP Post request to Appetite Server API
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    //POST content (being sent)
    self.fieldPost = @{@"email" : self.user.email, @"password" : self.user.email};
    
    //making the request via URL form feed encoded POST
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/plain"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    manager.responseSerializer = jsonResponseSerializer;
    
    
    //The response object pre-parsed into NSDictionary format (during block)
    [manager POST:login_url parameters:self.fieldPost
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         //clear text fields and hault load progress meter
         self.appetiteNameSubmission.text=@"";
         self.appetiteEmailSubmission.text=@"";
         self.appetitePasswordSubmission.text=@"";
         self.progress.hidden=YES;
         [self.progress stopAnimating];
         NSNumber *result = [responseObject valueForKey:@"code"];
         NSLog(@"Code Result: %@", result);
         if(result.integerValue == 0)
         {
             [self performSegueWithIdentifier:@"login_verified" sender:nil];
         }
         else
         {
             [self displayAccountCreationError];
         }
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         [self displayAccountCreationError];
         //clear text fields and hault load progress meter
         self.appetiteNameSubmission.text=@"";
         self.appetiteEmailSubmission.text=@"";
         self.appetitePasswordSubmission.text=@"";
         self.progress.hidden=YES;
         [self.progress stopAnimating];
         
     }];
}

//triggers credential registration upon the creation of a new account
- (IBAction)verifyResults:(id)sender {
    
    //submit button triggers email address being captured in UIField
    self.user.name = self.appetiteNameSubmission.text;
    self.user.email = self.appetiteEmailSubmission.text;
    self.user.password = self.appetitePasswordSubmission.text;
    NSString *createAccount_url = [NSString stringWithFormat:@"%@user/create/",APP_URL];
    self.progress.hidden=NO;
    [self.progress startAnimating];
    NSLog(@"Account being created for user \"%@\" under email \"%@\"", self.user.name, self.user.email);
    
    //Opening HTTP Post request to Appetite Server API
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    self.fieldPost = @{@"email" : self.user.email, @"password" : self.user.email, @"name" : self.user.name};

    //making the request via URL form feed encoded POST
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/plain"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    manager.responseSerializer = jsonResponseSerializer;
    
    
    //The response object pre-parsed into NSDictionary format (during block)
    [manager POST:createAccount_url parameters:self.fieldPost
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        // self.successMessage.text=@"Account creation successful!";
         NSLog(@"JSON: %@", responseObject);
         //clear text fields and hault load progress meter
         self.appetiteNameSubmission.text=@"";
         self.appetiteEmailSubmission.text=@"";
         self.appetitePasswordSubmission.text=@"";
         self.progress.hidden=YES;
         [self.progress stopAnimating];
         NSNumber *result = [responseObject valueForKey:@"code"];
         NSLog(@"Code Result: %@", result);
         if(result.integerValue == 0)
         {
             [self performSegueWithIdentifier:@"account_created" sender:self];
         }
         else{
             [self displayAccountCreationError];
         }
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         [self displayAccountCreationError];
         //clear text fields and hault load progress meter
         self.appetiteNameSubmission.text=@"";
         self.appetiteEmailSubmission.text=@"";
         self.appetitePasswordSubmission.text=@"";
         self.progress.hidden=YES;
         [self.progress stopAnimating];
     }];
    

}

- (void) displayAccountCreationError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid account credentials"
                                                    message:@"please try again"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


//METHODS THAT CONFORM TO NSURLConnectionDelegate PROTOCOL

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    [self.apiReturnXMLData setLength:0];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [self.apiReturnXMLData appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"URL Connection Failed!");
    currentConnection = nil;
}

//exit to track back to the previous segue
- (IBAction)exit:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Google Plus API Login, conforming to protocol methods
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
}


//Facebook API login, conforming to protocol methods
- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"loginViewShowingLoggedOutUser:");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive:");
    // Logs 'install' and 'app activate' App Events.
    [FBAppEvents activateApp];
}

- (BOOL)isSessionOpen
{
    return FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    // You can add your app-specific url handling code here if needec
    return wasHandled;
    
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"Access Granted");
}

- (void) loginViewFetchedUserInfo: (FBLoginView *)loginView user: (id<FBGraphUser>)user
{
    NSLog(@"loginViewFetchedUserInfo");
    _name = [user name];
    _profileID = user.objectID;
    
    //Comment the line below out to deactivate Facebook login
    //[self performSegueWithIdentifier:@"Login" sender:self];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    [FBProfilePictureView class];
    return YES;
}


@end
