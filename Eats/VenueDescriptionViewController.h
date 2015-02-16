//
//  VenueDescriptionViewController.h
//  Appetite
//
//  Created by mjhowell on 1/31/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Venue.h"
#import "UserProfile.h"

@interface VenueDescriptionViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *venueMapView;
@property (strong, nonatomic) IBOutlet UILabel *venueName;
@property (strong, nonatomic) IBOutlet UIButton *directionsButton;
@property (strong, nonatomic) IBOutlet UIButton *websiteButton;
@property (strong, nonatomic) IBOutlet UIButton *phoneCallButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (strong, nonatomic) IBOutlet UILabel *venueDescription;
@property (strong, nonatomic) IBOutlet UILabel *venueAddress;

@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) UserProfile *user;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end
