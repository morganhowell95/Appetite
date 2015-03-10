//
//  FoodSwingsViewController.h
//  Appetite
//
//  Created by mjhowell on 1/21/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import "CustomButton.h"

@interface FoodSwingsViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(CustomButton) NSArray *foodSwingChoices;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *foodSwingDescriptions;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic) IBOutlet UILabel *food_choice;

//user and user selection attributes
@property (strong, nonatomic) UserProfile *user;
@property (strong, nonatomic) CustomButton *chosen_mood;

//Appetite server POST data
@property (strong, nonatomic) NSDictionary *fieldPost;

@end
