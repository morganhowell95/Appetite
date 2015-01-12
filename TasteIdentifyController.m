//
//  TasteIdentifyController.m
//  Eats
//
//  Created by mjhowell on 12/15/14.
//  Copyright (c) 2014 Guru. All rights reserved.
//

#import "TasteIdentifyController.h"
#import "EatsOptions.h"
#import "EatsChoice.h"
#import "AFHTTPRequestOperationManager.h"
#import "PreferenceSearchViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.height
#define kScreenHeight [UIScreen mainScreen].bounds.size.width
#define locuName   @"mjhowell@live.unc.edu"
#define locuKey @"348b2f6cc9b7c265d94ed414fc4c689e812a73b7"

@interface TasteIdentifyController (){
    UILabel *coordinates;
    UIImage *profilepic;
    NSMutableString *firstName;
    NSArray *week;
    NSArray *time;
}
@end

@implementation TasteIdentifyController
@synthesize coordinates;
@synthesize locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(CLLocationManager.locationServicesEnabled){
        [self startStandardUpdates];
    } else {
        NSLog(@"Please give GPS authorization");
    }
    
    if([self userName]){
        [self parseName];
        [[self userName] appendString:@"!"];
        self.displayName.text = [self userName];
        self.profilePictureView.profileID = self.profileID;
        NSLog(@"PROFILE ID: %@",[self profileID]);
    }
    
    //Date Catch: catches current day of the week and time of day
    CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
    CFTimeZoneRef tz = CFTimeZoneCopySystem();
    SInt32 weekdayNumber = CFAbsoluteTimeGetDayOfWeek(at, tz);
    NSDate *currentTime = [NSDate date];
    NSMutableString *display = [[NSMutableString alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSHourCalendarUnit) fromDate:currentTime];
    int hrs = (int)[components hour];
    
    //Picker View Initialization and main display label set according to current time
    self.pickWheel.delegate=self;
    week = [[NSArray alloc] initWithObjects:
             @"Monday", @"Tuesday", @"Wednesday",
             @"Thursday", @"Friday", @"Satuday",
             @"Sunday", nil];
     [self.pickWheel selectRow:weekdayNumber-1 inComponent:0 animated:YES];
    self.pickWheelTime.delegate=self;
    [display appendString:week[weekdayNumber-1]];
    
    time = [[NSArray alloc] initWithObjects:
            @"Morning", @"Noon", @"Afternoon",
            @"Evening", @"Night", nil];
    [self.pickWheelTime selectRow:2 inComponent:0 animated:YES];
    [self loadChoices];
    self.CurrentTimeOfDay.text = [self chooseTimePeriod:display hours:hrs];
    
    //initial search for restaraunts and venue collection model
    self.searchRadius=1000;
    self.venueCollection = [[VenueCollection alloc] init];
    
    //loading measure- activity indicator view
    self.spinner.hidden=NO;
    [self.spinner startAnimating];
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

//choices are loaded randomly
- (void) loadChoices
{
    //load array of images and text to select button views fro
    EatsOptions *button_loads = [[EatsOptions alloc] init];
    int num_options = [button_loads.options count];
    
    //align the buttons within an array for option delegation (either smart or random delegation)
    //no loaded profile assumes random delegation
    NSArray *buttons = [[NSArray alloc] initWithObjects: self.button01, self.button02, self.button03, self.button04, self.button05, self.button06, nil];
    
    //chooses random options based on basic linear probing technique
    for(int i=0;i<6;i++){
        int random_pick = abs(arc4random() % num_options);
        EatsChoice *choice = [button_loads.options objectAtIndex:random_pick];
        if(!choice.isChosen){
            [buttons[i] setTitle:choice.appetite forState: UIControlStateNormal];
            [buttons[i] setBackgroundImage: choice.buttonback forState:UIControlStateNormal];
            [choice setIsChosen:YES];
        }
        else{
            for(int j=0;j<num_options;j++){
                EatsChoice *choice = [button_loads.options objectAtIndex:(random_pick+j)%num_options];
                if(!choice.isChosen){
                    [buttons[i] setTitle:choice.appetite forState: UIControlStateNormal];
                    [buttons[i] setBackgroundImage: choice.buttonback forState:UIControlStateNormal];
                    [choice setIsChosen:YES];
                    break;
                }
            }
        }
    }
}

- (IBAction)shuffle:(UIButton *)sender
{
    [self loadChoices];
}

- (void) parseName
{
  NSArray *words = [self.userName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self setUserName:nil];
    [self setUserName:[[NSMutableString alloc] initWithString:words[0]]];
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

- (void) incrementSearchRadius
{
    if(self.searchRadius<100000)
    {
        self.searchRadius= self.searchRadius*1.5;
    }
}


- (void) locuRequestOrigin
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //EXAMPLES JSON FEED
  //  self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[ @"name", @"location", @"contact"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}]};
    
    //The response object pre-parsed into NSDictionary format (during block)
    [manager POST:@"https://api.locu.com/v2/venue/search" parameters:self.JSONfeed
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
        [self loadJSONObjects:responseObject];
        //illustrate end of Locu JSON request, then segue forward
        [self APIReturnComplete];
    }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void) loadJSONObjects: (NSDictionary *) parsedResult
{
    //Parse keys from NSDictionary (derived from JSON response object) and update respective models
    NSArray *results = [parsedResult valueForKey:@"venues"];
    NSLog(@"Count %d", results.count);
    
    for (NSDictionary *groupDic in results) {
        Venue *new_entry = [[Venue alloc] init];
        
        for (NSString *key in groupDic) {
            if([key isEqualToString:@"name"]){
                new_entry.name=[groupDic valueForKey:key];
            }
            if([key isEqualToString:@"location"]){
                new_entry.location=[groupDic valueForKey:key];
                
              
                NSDictionary *location = [groupDic valueForKey:key];
    
                //cycle though different location features (tracking venue coordinates)
                for(NSString *secondary_key in location){
                    if([secondary_key isEqualToString:@"address1"]){
                        new_entry.address = [[groupDic valueForKey:@"address1"] valueForKey:secondary_key];
                    }
                    if([secondary_key isEqualToString:@"geo"]){
                        NSDictionary *coor = [location valueForKey:@"geo"];
                        NSArray *latlong = [coor valueForKey:@"coordinates"];
                        new_entry.latitude = [latlong objectAtIndex:1];
                        new_entry.longitude = [latlong objectAtIndex:0];
                    }
                    
                }                
            }
            if([key isEqualToString:@"locu_id"]){
                new_entry.locu_id=[groupDic valueForKey:key];
            }
            if([key isEqualToString:@"contact"]){
                new_entry.contact=[groupDic valueForKey:key];
            }
        }
          [self.venueCollection.venue_collection addObject:new_entry];
    }
}


//MapKit request for lattitude and longitude coordinates
- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    NSLog(@"calling start updating location");
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSLog(@"iOS not supported");
}

- (void)locationManager:(CLLocationManager *)manager
didUpdateLocations:(NSArray *)locations {
    NSLog(@"event triggered");
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSString *newloc = [ NSString stringWithFormat:@"latitude %+.6f, longitude %+.6f\n",
                            location.coordinate.latitude,
                            location.coordinate.longitude];
        coordinates.text = newloc;
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
        NSLog(@"Set Latitude: %f", self.latitude);
        NSLog(@"Set Longitude: %f", self.longitude);
        self.spinner.hidden=YES;
        [self.spinner stopAnimating];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"error fetching location data");
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    [self startStandardUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    NSLog(@"DID FINISH LAUNCHING WITH OPTIONS");
    return YES;
}

//Data source controls for picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger) component
{
    if([pickerView isEqual:self.pickWheel]){
        return 7;
    }
    else{
        return 5;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if([pickerView isEqual:self.pickWheel]){
        if (component == 0) {
            return [week objectAtIndex:row];
        }
        return [week objectAtIndex:row];
    }
    else{
        if (component == 0) {
            return [time objectAtIndex:row];
        }
        return [time objectAtIndex:row];
    }
}


//Prior to segue activation, JSON is retrieved via Locu API depending on certain filters and attributes (set in specificTasteIdentityRequest)
//JSON objects are then dynamically loaded into the models and sent to the destination segue
//The destination segue holds a subclassed UITableViewController embedded within a UIViewController which is loaded up using a mutable array from the JSON model objects constructed
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"locu latitude: %f", self.latitude);
    NSLog(@"locu latitude: %f", self.longitude);
    if (!(self.latitude) && !(self.longitude)){[self startStandardUpdates];}
    
    //delegates objects to the destination segue controller
    PreferenceSearchViewController *dest = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"preferenceSearch"]){
        [dest setVenue_collection:self.venueCollection];
        dest.latitude = self.latitude;
        dest.longitude = self.longitude;
    }
    
}

//Represents the preliminary "secret sauce" to sending out queries based on the user's current mood in a particular time setting
//Currently the functionality is basic - only simple queries for certain items on the menu. However in the next update, these queries will start involving more complicated requests (more tailored to a person's appetite).
- (void)specificTasteIdentityRequest: (id) sender
{
    
    //activity indicator view activation (load screen)
    self.spinner.hidden=NO;
    [self.spinner startAnimating];
    
    
    if([[sender currentTitle] isEqualToString:@"Date Night"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"steak"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Girls Night"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"wine"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Baked"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"cookies",@"name":@"pizza",@"name":@"burrito"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Games On"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"wings"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Out Drinking"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"alcohol",@"name":@"beer",@"name":@"shots",@"name":@"wine"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Sober Up"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"pizza",@"name":@"burrito",@"name":@"sandwich"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"On The Go"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"hotdog",@"name":@"fries",@"name":@"cheeseburger"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Studying"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"coffee"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Dessert"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"dessert"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Diet"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"salad"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Cheap"]){
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"burrito",@"name":@"cheeseburger",@"name":@"fast food"}]};
        [self locuRequestOrigin];
    }
    
    if([[sender currentTitle] isEqualToString:@"Sushi"]){
        NSLog(@"Searching for great places to eat Sushi...");
        self.JSONfeed = @{@"api_key" : locuKey, @"fields" : @[@"name", @"location", @"contact",@"extended"],@"venue_queries": @[@{@"location":@{@"geo":@{@"$in_lat_lng_radius":@[@(self.latitude),@(self.longitude),@(self.searchRadius)]}}}], @"menu_item_queries": @[@{@"name":@"sushi",@"name":@"sashimi"}]};
        [self locuRequestOrigin];
    }
}

//progress meter hault, then segue executed
- (void) APIReturnComplete
{
    [self.spinner stopAnimating];
    self.spinner.hidden=YES;
    [self performSegueWithIdentifier:@"preferenceSearch" sender:self];
}

//Execution method for all button actions 
- (IBAction)ChoiceSelection:(id)sender {
       [self specificTasteIdentityRequest:sender];
}

//exit to segue backwards
- (IBAction)exit:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
