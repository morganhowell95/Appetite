//
//  VenueListTableViewController.h
//  Appetite
//
//  Created by mjhowell on 1/26/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UserProfile.h"
#import "VenueCollection.h"
#import "DescriptionRollOut.h"

@interface VenueListTableViewController : UIViewController <CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource>

//View component handlers
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//User attributes
@property (strong, nonatomic) UserProfile *user;
@property int foodSwingChoice;
@property (strong, nonatomic) DescriptionRollOut *venueSelect;

//tracking user's location
@property float latitude;
@property float longitude;

//Venue Information
@property (strong, nonatomic) VenueCollection *venueCollection;
@property (strong, nonatomic) NSDictionary *fieldPost;



@end
