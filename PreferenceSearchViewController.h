//
//  PreferenceSearchViewController.h
//  Eats
//
//  Created by mjhowell on 1/5/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "ViewController.h"
#import "Venue.h"
#import "VenueCollection.h"
#import <MapKit/MapKit.h>

@interface PreferenceSearchViewController : ViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) VenueCollection *venue_collection;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property double latitude;
@property double longitude;

@end
