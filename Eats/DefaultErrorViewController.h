//
//  DefaultErrorViewController.h
//  Appetite
//
//  Created by mjhowell on 1/31/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"

@interface DefaultErrorViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *retryButton;
@property (strong, nonatomic) UserProfile *user;

@end
