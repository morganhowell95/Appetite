//
//  AppetiteChoiceViewController.h
//  Appetite
//
//  Created by mjhowell on 1/19/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import "CustomButton.h"

@interface AppetiteChoiceViewController : UIViewController

//View components that trigger actions relevant to selecting a specific "food mood"
@property (strong, nonatomic) IBOutlet UINavigationItem *appetiteNavigationBar;
@property (strong, nonatomic) IBOutlet UILabel *timeContextLabel;
@property (strong, nonatomic) IBOutletCollection(CustomButton) NSArray *moodOptions;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *moodImages;
@property (strong, nonatomic) IBOutlet UIButton *shuffle;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;



//Appetite server POST data
@property (strong, nonatomic) NSDictionary *fieldPost;

//user collected attributes (user profile includes search radius)
@property (strong, nonatomic) UserProfile *user;



@end
