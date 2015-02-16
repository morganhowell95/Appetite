//
//  WebFrameViewController.m
//  Appetite
//
//  Created by mjhowell on 2/2/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "WebFrameViewController.h"

@interface WebFrameViewController ()

@end

@implementation WebFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up UIWebview and load venue content
    self.progress.hidden=NO;
    [self.progress startAnimating];
    self.venueWebView.hidden = YES;
    self.venueWebView.delegate=self;
    self.venueWebView.scalesPageToFit=YES;
    [self loadRequestFromString:self.venueURL];
    self.progress.hidden=YES;
    [self.progress stopAnimating];
    self.venueWebView.hidden=NO;
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.progress.hidden=NO;
    [self.progress startAnimating];
    NSLog(@"error loading webpage");
}

- (void) viewWillAppear:(BOOL)animated
{
  //  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"<<" style: UIBarButtonItemStylePlain target:self action:@selector(backEscape)];
   // self.navBar.leftBarButtonItem = backButton;
}

- (IBAction)backEscape
{
    //[self dismissViewControllerAnimated:YES completion:nil]; // ios 6]
    // NSArray *viewControllers = [self.navigationController viewControllers];
    // UIViewController *popTo = [viewControllers objectAtIndex:0];
    // [self.navigationController popToViewController:popTo animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
    // [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.venueWebView loadRequest:urlRequest];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
