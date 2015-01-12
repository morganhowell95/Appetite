//
//  ViewController.m
//  Eats
//
//  Created by mjhowell on 12/11/14.
//  Copyright (c) 2014 Guru. All rights reserved.
//

#import "ViewController.h"
#import "TasteIdentifyController.h"
#define kStrikeIronUserID   @"mjhowell@live.unc.edu"
#define kStrikeIronPassword @"7m5jmj"

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
@synthesize enteredEmailAddress = _enteredEmailAddress;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //fb login view intialization
//    [self setLoginView:[[FBLoginView alloc] init]];
//    loginView.center = self.view.center;
//    [self.view addSubview:loginView];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    loginView.delegate = self;
    if([self isSessionOpen]){
        NSLog(@"Login Success");
    }
    
    self.emailadd.delegate=self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TasteIdentifyController *dest = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"Login"]){
        dest.userName = [[NSMutableString alloc] initWithString:_name];
        dest.profileID = _profileID;
        NSLog(@"USER NAME SET");
        NSLog(@"INSTANCE USERNAME: %@",_name);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"loginViewShowingLoggedOutUser:");
}

- (void) loginViewFetchedUserInfo: (FBLoginView *)loginView user: (id<FBGraphUser>)user
{
    NSLog(@"loginViewFetchedUserInfo");
    _name = [user name];
    _profileID = user.id;
    
    //Comment the line below out to deactivate Facebook login
    [self performSegueWithIdentifier:@"Login" sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)emailTextField {
    [emailTextField resignFirstResponder];
    return YES;
}

- (IBAction)exit:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)verifyResults:(id)sender {
    
    //submit button triggers email address being captured in UIField
    self.enteredEmailAddress = self.emailadd.text;
    self.verificationResults.text = @"";
    
    //REST call string entered according to account registered above
    NSString *restCallString = [NSString stringWithFormat:@"http://ws.strikeiron.com/StrikeIron/EMV6Hygiene/VerifyEmail?LicenseInfo.RegisteredUser.UserID=%@&LicenseInfo.RegisteredUser.Password=%@&VerifyEmail.Email=%@&VerifyEmail.Timeout=30", kStrikeIronUserID, kStrikeIronPassword, self.enteredEmailAddress];
    NSLog(@"Email address being checked: %@", self.enteredEmailAddress);
    NSLog(@"---------------------------------- \n REST STRING APPLIED: %@ \n ------------------------------ \n", restCallString);
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    if(currentConnection)
    {
        [currentConnection cancel];
        currentConnection = nil;
        self.apiReturnXMLData = nil;
    }
    
    currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    
    // If the connection was successful, create the XML that will be returned.
    self.apiReturnXMLData = [NSMutableData data];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive:");
    // Logs 'install' and 'app activate' App Events.
    [FBAppEvents activateApp];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // create our XML parser with the return data from the connection
    xmlParser = [[NSXMLParser alloc] initWithData:self.apiReturnXMLData];
    
    // setup the delgate (see methods below)
    
    [xmlParser setDelegate:self];
    
    // start parsing. The delgate methods will be called as it is iterating through the file.
    [xmlParser parse];
    
    currentConnection = nil;
}
//METHODS THAT CONFORM TO NSXMLParserDelegate PROTOCOL
    
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary *)attributeDict{;
    // Log the error - in this case we are going to let the user pass but log the message
    if( [elementName isEqualToString:@"Error"])
    {
        NSLog(@"Web API Error!");
    }
    
    // Pull out the elements we care about.
    if( [elementName isEqualToString:@"StatusNbr"] ||
       [elementName isEqualToString:@"HygieneResult"])
    {
        self.currentElement = [[NSString alloc] initWithString:elementName];
        NSLog(@"the current element: %@ ", self.currentElement);
    }
    
    NSLog(@"ELEMENT NAME: %@", elementName);
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {

    if([self.currentElement isEqualToString:@"StatusNbr"])
    {
        self.statusNbr = [string intValue];
        self.currentElement = nil;
    }
    else if([self.currentElement isEqualToString:@"HygieneResult"])
    {
        self.hygieneResult = [[NSString alloc] initWithString:string];
        self.currentElement = nil;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //pass
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    // Determine what we are going to display in the label
    if([self.hygieneResult isEqualToString:@"Spam Trap"])
    {
        self.verificationResults.text = @"This email is associated with spam";
    }
    else if(self.statusNbr >= 300 || (self.statusNbr==0 && self.hygieneResult==nil))
    {
        self.verificationResults.text = @"Invalid email, please re-enter";
    }
    else
    {
        self.verificationResults.text = @"Thank you for your submission";
    }
    
    self.apiReturnXMLData = nil;
}


@end
