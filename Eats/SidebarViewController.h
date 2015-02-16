//
//  SidebarViewController.h
//  Appetite
//
//  Created by mjhowell on 2/6/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"

@interface SidebarViewController : UITableViewController

@property (strong, nonatomic) UserProfile *user_prof;
@property (strong, nonatomic) UIImage *user_image;

@end
