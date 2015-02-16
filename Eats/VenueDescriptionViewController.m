//
//  VenueDescriptionViewController.m
//  Appetite
//
//  Created by mjhowell on 1/31/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "VenueDescriptionViewController.h"

@interface VenueDescriptionViewController ()

@end

@implementation VenueDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //activating activity indicator
    self.progress.hidden=NO;
    [self.progress startAnimating];
    
    //rounding the corners of the buttons
    self.directionsButton.layer.cornerRadius=10;
    self.directionsButton.clipsToBounds=YES;
    self.websiteButton.layer.cornerRadius=10;
    self.websiteButton.clipsToBounds=YES;
    self.phoneCallButton.layer.cornerRadius=10;
    self.phoneCallButton.clipsToBounds=YES;
    
    //setting up the map delegate and placing pin at coordinates
    self.venueMapView.showsUserLocation=YES;
    float spanX = 0.03025;
    float spanY = 0.03025;
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center.latitude = [self.venue.latitude doubleValue];
    region.center.longitude = [self.venue.longitude doubleValue];
    self.venueName.text = self.venue.name;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D center;
    center.latitude = [self.venue.latitude doubleValue];
    center.longitude = [self.venue.longitude doubleValue];
    [annotation setCoordinate:center];
    [annotation setTitle:self.venue.name]; //You can set the subtitle too
    [self.venueMapView addAnnotation:annotation];
    [self.venueMapView setRegion:region animated:YES];
    [self.venueMapView selectAnnotation:annotation animated: YES];
    
    
    
    //settings venue address, if null blank
    NSString *addressDescription;
    if(self.venue.address){
        addressDescription = [[NSString alloc] initWithFormat:@"%@ %@",self.venue.address, self.venue.locality];
    }
    else if(self.venue.locality)
    {
        addressDescription = [[NSString alloc] initWithFormat:@"%@", self.venue.locality];
    }
    else
    {
        addressDescription = @"";
        
    }
    self.venueAddress.text = addressDescription;
    
    //setting venue quote or description, if null leave blank
    self.venueDescription.text = [[NSString alloc] initWithFormat:@"\"An ideal venue for: %@\"", self.user.current_mood];
    
    //deactivitating activity indicator    
    self.progress.hidden=YES;
    [self.progress stopAnimating];
}

- (void) viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"<<" style: UIBarButtonItemStylePlain target:self action:@selector(Back)];
    self.navigationBar.leftBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Button Events
-------------------------------------------------------------------------------------------------------- */

//open apple maps and navigate to selected venue
- (IBAction)directionAction:(id)sender {
    CLLocationCoordinate2D latlong;
    latlong.latitude = [self.venue.latitude doubleValue];
    latlong.longitude = [self.venue.longitude doubleValue];
    
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: latlong addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = self.venue.name;
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
}

//navigate to the selected venue's website
- (IBAction)websiteAction:(id)sender {
    if(self.venue.website){
        [self performSegueWithIdentifier:@"venue_webview" sender:nil];
    }
    else
    {
        NSLog(@"venue selected does not have a website listed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venue selected does not have a listed website at this time"
                                                        message:@"The more we grow however, the more information per venue we will add"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"No website applicable for the selected venue");
    }
}

//prompt the user to make a phone call to the selected venue
- (IBAction)phoneCallAction:(id)sender {
    NSLog(@"making phone call....");
    NSString *phone_number = self.venue.phone;
    
    if(phone_number){
        NSString *cleanedString = [[phone_number componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", cleanedString]];
        [[UIApplication sharedApplication] openURL: telURL];
    }
    else {
        NSLog(@"venue selected does not have a listed phone number");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venue selected does not have a listed phone number at this time"
                                                        message:@"The more we grow however, the more information per venue we will add"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (IBAction)Back
{
    //[self dismissViewControllerAnimated:YES completion:nil]; // ios 6]
    // NSArray *viewControllers = [self.navigationController viewControllers];
    // UIViewController *popTo = [viewControllers objectAtIndex:0];
    // [self.navigationController popToViewController:popTo animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
    // [self dismissViewControllerAnimated:YES completion:nil];
}


/*
 ---------------------------------------------------------------------------------------------------------*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
