//
//  AppetiteChoiceViewController.m
//  Appetite
//
//  Created by mjhowell on 1/19/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "AppetiteChoiceViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FoodSwingsViewController.h"
#import "SWRevealViewController.h"

#define APP_URL @"http://site-cater.rhcloud.com/"

@interface AppetiteChoiceViewController (){
    NSArray *week;
    NSArray *time;
}

@end

@implementation AppetiteChoiceViewController

- (void)viewDidLoad {
    
    //construct super class view and activate activity indicator
    [super viewDidLoad];
    self.progress.hidden=NO;
    [self.progress startAnimating];
    
    
    //capturing information about the current time context
    NSTimeZone *preferredTimeZone = [NSTimeZone localTimeZone];
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    NSMutableString *display = [[NSMutableString alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitHour) fromDate:currentTime];
    int hrs = (int)[components hour];
    [myFormatter setTimeZone:preferredTimeZone];
    [myFormatter setDateFormat:@"c"]; // day number (format: 7 for saturday)
    
    NSString *dayOfWeek = [myFormatter stringFromDate:currentTime];
    NSInteger numberOfDay = [dayOfWeek integerValue];

    //array allocation and initialization of time context
    week = [[NSArray alloc] initWithObjects:
            @"Sunday", @"Monday", @"Tuesday", @"Wednesday",
            @"Thursday", @"Friday", @"Satuday", nil];
    time = [[NSArray alloc] initWithObjects:
            @"Morning", @"Afternoon", @"Afternoon",
            @"Evening", @"Night", nil];
    
    NSLog(@"%d",hrs);
    
    //construction and identification of time context along with mood ids
    [display appendString:week[numberOfDay-1]];
    self.timeContextLabel.text = [self chooseTimePeriod:display hours:hrs];
    [self moodIDGeneration];
    self.shuffle.layer.cornerRadius=10;
    self.shuffle.clipsToBounds=YES;
    self.user.searchRadius=2414;

    //Visual Component Manipulation: Borders, Auto-Constraints, and Location
//---------------------------------------------------------------------------------------
    UIButton *firstbutton = [self.moodOptions firstObject];
    
    //add border to buttons
    for(UIButton *button in self.moodOptions){
        [[button layer] setBorderWidth:0.35f];
        [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
        [NSLayoutConstraint constraintWithItem:button
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:firstbutton
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:1.0
                                      constant:0];
    }
    //toggling the side drawer
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

//---------------------------------------------------------------------------------------
}

- (void)moodIDGeneration
{
    @try{
        //Opening HTTP Post request to Appetite Server API
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //POST content (being sent)
        NSString *moodGen_url = [NSString stringWithFormat:@"%@tags/mood/",APP_URL];
      
        if((self.user.password != nil) && (self.user.email != nil))
            self.fieldPost = @{@"email" : self.user.email, @"password" : self.user.password, @"count" : @6};
        else{
            self.fieldPost = @{@"count": @6};
        }
        
        //making the request via URL form feed encoded POST
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [jsonAcceptableContentTypes addObject:@"text/plain"];
        jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
        manager.responseSerializer = jsonResponseSerializer;
        
            //The response object pre-parsed into NSDictionary format (during block)
            [manager POST:moodGen_url parameters:self.fieldPost
                  success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 //uncomment below line to see JSON server responds with
                  NSLog(@"JSON: %@", responseObject);
                 
                 int index = 0; //update buttons in sequential order
                 for(NSDictionary *dic in responseObject)
                 {
                     NSString *count = [dic valueForKey:@"pk"];
                     NSString *title = [dic valueForKey:@"name"];
                     NSString *image_url = [dic valueForKey:@"image_url"];
                     [[self.moodOptions objectAtIndex:index] setMoodID: (int) [count integerValue]];
                     [self setImageIcon:index ImageUrl:image_url];
                     [[self.moodOptions objectAtIndex:index] setTitle:title forState:UIControlStateNormal];
                     index++;
                 }
                 //hault load progress meter and parse result for mood generation
                 self.progress.hidden=YES;
                 [self.progress stopAnimating];
             }
                  failure:
             ^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
                 //hault load progress meter and report error
                 self.progress.hidden=YES;
                 [self.progress stopAnimating];
                 [self performSegueWithIdentifier:@"error1" sender: nil];
             }];
    }
    @catch (NSException *e){
        NSLog(@"%@", e.reason);
        [self performSegueWithIdentifier:@"error1" sender:nil];
    }
}

//read image from Appetite server and set the respective button background to the image
- (void) setImageIcon: (int) index ImageUrl: (NSString *) url
{
    //image url composition
    NSString *imagecomp_url = [NSString stringWithFormat:@"%@static/%@",APP_URL, url];
    NSURL *image_url = [NSURL URLWithString:imagecomp_url];
    NSData *data = [NSData dataWithContentsOfURL:image_url];
    UIImage *image = [UIImage imageWithData: data];
    
    //setting the image to the respective option
    [[self.moodImages objectAtIndex:index] setImage:image];
}

//chooses the appropriate time setting based on current time
- (NSString *) chooseTimePeriod: (NSMutableString *) finalTime hours: (int) hrs
{
    if(hrs<12){
        [finalTime appendFormat: @" %@", time[0]];
    }
    else if (hrs==12){
        [finalTime appendFormat: @" %@", time[1]];
    }
    else if (hrs>12 && hrs< 16)
    {
        [finalTime appendFormat: @" %@", time[2]];
    }
    else if(hrs>=16 && hrs <17)
    {
        [finalTime appendFormat: @" %@", time[3]];
    }
    else
    {
        [finalTime appendFormat: @" %@", time[4]];
    }
    return finalTime;
}

//Triggers when user selects mood- Button Actions
- (IBAction)moodSelectionAction:(CustomButton *)sender {
    [self performSegueWithIdentifier:@"food_swing" sender:sender];
}
- (IBAction)shuffleAction:(id)sender {
    [self moodIDGeneration];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(CustomButton *)sender
{
   
    if([segue.destinationViewController isKindOfClass:[FoodSwingsViewController class] ]){
        FoodSwingsViewController *dest = (FoodSwingsViewController *) segue.destinationViewController;
        self.user.current_mood = sender.titleLabel.text;
        dest.user = self.user;
         NSLog(@"MOOOOD CHOSEEEEN: %d",sender.moodID);
        dest.chosen_mood = sender;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
