//
//  AppetiteRootViewController.h
//  Eats
//
//  Created by mjhowell on 1/17/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppetiteRootViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *Logo;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@end
