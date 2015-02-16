//
//  VenueListTableViewController.m
//  Appetite
//
//  Created by mjhowell on 1/26/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "VenueListTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "VenueCollection.h"
#import "CustomAppetiteTableViewCell.h"
#import "WebFrameViewController.h"
#import "VenueDescriptionViewController.h"
#define APP_URL @"http://site-cater.rhcloud.com/"

@interface VenueListTableViewController ()

@end

@implementation VenueListTableViewController{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
  /*  locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //ask for authorization depending on the version of iOS running
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];*/
     [self CurrentLocationIdentifier];

    //start animating activity indicator and instantiate model objects
    self.progress.hidden=NO;
    [self.progress startAnimating];
    self.venueCollection = [[VenueCollection alloc] init];
    self.venueSelect = [[DescriptionRollOut alloc] init];

    //setup default search radius
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // [self.tableView reloadData];
  /*  locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];*/
}

- (void) viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"<<" style: UIBarButtonItemStylePlain target:self action:@selector(backEscape)];
    self.navigationBar.leftBarButtonItem = backButton;
}

- (void) loadVenueRequests
{
    @try{
        self.progress.hidden=NO;
        [self.progress startAnimating];
        
        //Opening HTTP Post request to Appetite Server API for mood swings
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //POST content (being sent)
        NSString *moodSwingGen_url = [NSString stringWithFormat:@"%@tags/venue_search/",APP_URL];
        
        if(!self.user.password && !self.user.email){
            self.fieldPost = @{@"email" : self.user.email, @"password" : self.user.password, @"mood_swing" : @(self.foodSwingChoice), @"latitude" : @(self.latitude), @"longitude": @(self.longitude), @"radius": @(self.user.searchRadius)};
        }
        else{
            self.fieldPost = @{@"mood_swing" : @(self.foodSwingChoice), @"latitude" : @(self.latitude), @"longitude": @(self.longitude), @"radius": @(self.user.searchRadius)};

        }
        
        NSLog(@"JSON REQUEST: %@", self.fieldPost);
        
        //making the request via URL form feed encoded POST
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [jsonAcceptableContentTypes addObject:@"text/plain"];
        jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
        manager.responseSerializer = jsonResponseSerializer;
        
        //The response object pre-parsed into NSDictionary format (during block)
        [manager POST:moodSwingGen_url parameters:self.fieldPost
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             //hault load progress meter and parse result for mood generation
             self.progress.hidden=YES;
             [self.progress stopAnimating];
             [self loadJSONObjects:responseObject];
             [self APIReturnComplete];
         }
              failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             //hault load progress meter and report error
             self.progress.hidden=YES;
             [self.progress stopAnimating];
             [self performSegueWithIdentifier:@"error3" sender: nil];
         }];
    }
    @catch (NSException *e){
        NSLog(@"%@", e.reason);
        [self performSegueWithIdentifier:@"error3" sender:nil];
    }
}

//Locu response parse followed by loading the data dynamically into model objects

- (void) loadJSONObjects: (NSDictionary *) parsedResult
{
    //Parse keys from NSDictionary (derived from JSON response object) and update respective models
    NSArray *results = [parsedResult valueForKey:@"venues"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *groupDic in results) {
        Venue *new_entry = [[Venue alloc] init];
        
        for (NSString *key in groupDic) {
            if([key isEqualToString:@"name"]){
                new_entry.name=[groupDic valueForKey:key];
            }
            if([key isEqualToString:@"contact"]){
                NSDictionary *contact = [groupDic valueForKey:key];
                new_entry.phone = [contact valueForKey:@"phone"];
            }
            if([key isEqualToString:@"website_url"]){
                new_entry.website=[groupDic valueForKey:key];
            }
            
            //Uncomment to begin incorporating menu query functionality
           /* if([key isEqualToString:@"menus"]){
                NSArray *sections = [groupDic valueForKey:@"sections"];
                NSDictionary *firstSubSet = [sections firstObject];
                NSArray *
                //new_entry.venue_description = [contents valueForKey:@"description"];
                
            }*/
            
            if([key isEqualToString:@"location"]){
                NSDictionary *location = [groupDic valueForKey:key];
                new_entry.address = [location valueForKey:@"address1"];
                new_entry.locality = [location valueForKey:@"locality"];
                new_entry.region = [location valueForKey:@"region"];
                NSDictionary *coor = [location valueForKey:@"geo"];
                NSArray *latlong = [coor valueForKey:@"coordinates"];
                new_entry.latitude = [latlong objectAtIndex:1];
                new_entry.longitude = [latlong objectAtIndex:0];
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

//progress meter hault, then segue executed
- (void) APIReturnComplete
{
    [self.progress stopAnimating];
    self.progress.hidden=YES;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.tableView];
    [self.tableView setScrollEnabled:YES];
    [self.tableView reloadData];
    NSLog(@"Locu Response Successful");
}

//Table View Delegate methods (loading the venues into cells and accounting for number of response objects)
/*----------------------------------------------------------------------------------*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return ([self.venueCollection.venue_collection count]*2);
    
    // Return the number of rows in the section.
    NSInteger numOfRowsIncludeSeparator = 0;
    NSInteger model_count = self.venueCollection.venue_collection.count;
    
    if (model_count > 0) {
        NSInteger numOfSeperators = model_count - 1;
        numOfRowsIncludeSeparator = model_count + numOfSeperators;
    }
    
    return numOfRowsIncludeSeparator;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *appCustomCell = @"AppetiteCell";
    static NSString *customSeparate = @"Divide";
    //CustomAppetiteTableViewCell *cell = nil;
    
    if(indexPath.row%2==0){
        CustomAppetiteTableViewCell *cell = (CustomAppetiteTableViewCell *) [tableView dequeueReusableCellWithIdentifier:appCustomCell];
        if (!cell)
        {
            cell = [[CustomAppetiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appCustomCell];
        }
        
        //import item from list and display as label within custom rows
        Venue *venue = [self.venueCollection.venue_collection objectAtIndex:(indexPath.row/2)];
        cell.venueName.text = venue.name;
        NSLog(@"Venue Address: %@", venue.address);
        NSString *addressDescription;
        if(venue.address){
            addressDescription = [[NSString alloc] initWithFormat:@"%@ %@",venue.address,venue.locality];
        }
        else if(venue.locality)
        {
            addressDescription = [[NSString alloc] initWithFormat:@"%@", venue.locality];
        }
        else
        {
            addressDescription = @"";
            
        }
        
        NSLog(@"The website for \"%@\" is: \"%@\"", venue.name,venue.website);
        
        //add tags to the UIButton fields so that venues can be correlated with specific contact information
        cell.addressLocation.text = addressDescription;
        cell.phoneCall.tag = (indexPath.row/2);
        cell.navDirect.tag = (indexPath.row/2);
        [cell.phoneCall addTarget:self action:@selector(makePhoneCall:) forControlEvents:UIControlEventTouchUpInside];
        [cell.navDirect addTarget:self action:@selector(navToDest:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [cell.contentView.layer setBorderWidth:1.0f];
          NSLog(@"making content....");
        
        
        //phone and sphere buttons for calling and website navigation
        if(!venue.phone){
            cell.phoneCall.hidden=YES;
        }
        else{
            cell.phoneCall.hidden=NO;
        }
        if(!venue.website){
            cell.navDirect.hidden=YES;
        }
        else
        {
            cell.navDirect.hidden=NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NSLog(@"separator");
        CustomAppetiteTableViewCell *cell = (CustomAppetiteTableViewCell *) [tableView dequeueReusableCellWithIdentifier:customSeparate];
        
        if(!cell)
        {
            //cell = [[[NSBundle mainBundle] loadNibNamed:@"SeparatorCell" owner:self options:nil] objectAtIndex:0];
                cell = [[CustomAppetiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customSeparate];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row%2==0) ? 78 : 20;
}

//opening the website of the selected venue
-(void) navToDest: (UIButton *) sender
{
    Venue *venue = [self.venueCollection.venue_collection objectAtIndex:sender.tag];
    self.venueSelect.venueURLWebView = venue.website;
    self.venueSelect.venueSelected = nil;
    if(venue.website){
        [self performSegueWithIdentifier:@"web_venue" sender:self.venueSelect];
    }
    else
    {
        NSLog(@"venue selected does not have a website listed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venue selected does not have a listed phone number at this time"
                                                        message:@"The more we grow however, the more information per venue we will add"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"No website applicable for the selected venue");
    }
}


//calling the selected venue
- (void) makePhoneCall: (UIButton *) sender
{
    NSLog(@"making phone call....");
    Venue *venue = [self.venueCollection.venue_collection objectAtIndex:sender.tag];
    if(venue.phone){
        NSString *cleanedString = [[venue.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", cleanedString]];
        [[UIApplication sharedApplication] openURL: telURL];

    }
    else
    {
        NSLog(@"venue selected does not have a listed phone number");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venue selected does not have a listed phone number at this time"
                                                        message:@"The more we grow however, the more information per venue we will add"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//navigating to the venue description with further options to navigate, call, and explore
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Venue *venue = [self.venueCollection.venue_collection objectAtIndex:(indexPath.row/2)];
    self.venueSelect.venueSelected = venue;
    self.venueSelect.venueURLWebView = nil;
    [self performSegueWithIdentifier:@"venue_description" sender:self.venueSelect];
}


/*----------------------------------------------------------------------------------*/



//MapKit request for latitude and longitude coordinates, updating the user's location
/*----------------------------------------------------------------------------------*/

#pragma mark - CLLocationManagerDelegate

/*- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
   // CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
      //  longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        //latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        self.latitude = currentLocation.coordinate.latitude;
        self.longitude = currentLocation.coordinate.longitude;
        self.progress.hidden=YES;
        [self.progress stopAnimating];
        [self loadVenueRequests];
        [locationManager stopUpdatingLocation];
    }
}*/

//------------ Current Location Address-----
-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    locationManager = [CLLocationManager new];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //ask for authorization depending on the version of iOS running
    //------
}

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
    NSLog(@"Location Captured");
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, activate update
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
        NSLog(@"Set Latitude: %f", self.latitude);
        NSLog(@"Set Longitude: %f", self.longitude);
        self.progress.hidden=YES;
        [self.progress stopAnimating];
        [manager stopUpdatingLocation];
        [self loadVenueRequests];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"error fetching location data: %@", error.description);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We were unable to process your location"
                                                    message:@"Please make sure to enable location services for Appetite and try again."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self CurrentLocationIdentifier];
}

//*----------------------------------------------------------------------------------*/


- (IBAction)backEscape
{
    //[self dismissViewControllerAnimated:YES completion:nil]; // ios 6]
    // NSArray *viewControllers = [self.navigationController viewControllers];
    // UIViewController *popTo = [viewControllers objectAtIndex:0];
    // [self.navigationController popToViewController:popTo animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
    // [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DescriptionRollOut *venue = (DescriptionRollOut *) sender;
 
    //Depending on how the DescriptionRollout object is loaded up
    //a particular segue, either the web view controller or the venue description controller,
    //will be nvaigated to
    
    if(venue.venueURLWebView && !venue.venueSelected){
        WebFrameViewController *dest = [segue destinationViewController];
        dest.venueURL = venue.venueURLWebView;
    }
    if(venue.venueSelected && !venue.venueURLWebView){
        VenueDescriptionViewController *dest = [segue destinationViewController];
        dest.venue = venue.venueSelected;
        dest.user = self.user;
    }
}


@end
