//
//  SettingsViewController.m
//  Appetite
//
//  Created by mjhowell on 2/6/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    self.radiusSlider.value = self.user.searchRadius*0.00062137f;
    if (revealViewController)
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    int num_miles = (int) self.radiusSlider.value;
    
    if(num_miles==1){
        self.radiusMiles.text = [NSString stringWithFormat:@"%d mile", num_miles];
    }
    else{
        self.radiusMiles.text = [NSString stringWithFormat:@"%d miles", num_miles];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sliderValueChanged:(id)sender
{
    // Set the label text to the value of the slider as it changes
    self.radiusMiles.text = [NSString stringWithFormat:@"%d miles", (int) self.radiusSlider.value];
    self.user.searchRadius = (int) (self.radiusSlider.value/0.00062137f);
    self.revealViewController.user = self.user;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Changing now!!!");
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
