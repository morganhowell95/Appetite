//
//  TasteIdentifyController.h
//  Eats
//
//  Created by mjhowell on 12/15/14.
//  Copyright (c) 2014 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "CustomButton.h"
#import "VenueCollection.h"

@interface TasteIdentifyController : UIViewController <CLLocationManagerDelegate, FBLoginViewDelegate,  UIPickerViewDelegate, UIPickerViewDataSource>


//delegate objects
@property CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableString *userName;
@property (strong, nonatomic) NSString *profileID;
@property double latitude;
@property double longitude;
@property int searchRadius;

//JSON Parsing Structures (input and parsed output)
@property (strong, nonatomic) NSDictionary * JSONfeed;
@property (strong, nonatomic) NSData *locuResponse;
@property (strong, nonatomic) NSArray *JSONPostParsed;
@property (strong, nonatomic) VenueCollection *venueCollection;

//connected view components
@property (nonatomic, retain) IBOutlet UILabel *coordinates;
@property (nonatomic, retain) IBOutlet UILabel *displayName;
@property (strong, nonatomic) IBOutlet UILabel *CurrentTimeOfDay;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickWheel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickWheelTime;
@property (strong, nonatomic) IBOutlet UIButton *button01;
@property (strong, nonatomic) IBOutlet UIButton *button02;
@property (strong, nonatomic) IBOutlet UIButton *button03;
@property (strong, nonatomic) IBOutlet UIButton *button04;
@property (strong, nonatomic) IBOutlet UIButton *button05;
@property (strong, nonatomic) IBOutlet UIButton *button06;


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void) incrementSearchRadius;


@end
