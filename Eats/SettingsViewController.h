//
//  SettingsViewController.h
//  Appetite
//
//  Created by mjhowell on 2/6/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import "SWRevealViewController.h"

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;
@property (strong, nonatomic) IBOutlet UILabel *radiusMiles;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (strong, nonatomic) UserProfile *user;

@end
