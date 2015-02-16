//
//  WebFrameViewController.h
//  Appetite
//
//  Created by mjhowell on 2/2/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebFrameViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *venueWebView;
@property (strong, nonatomic) NSString *venueURL;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progress;


- (void)loadRequestFromString:(NSString*)urlString;
@end
