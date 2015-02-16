//
//  DefaultErrorViewController.m
//  Appetite
//
//  Created by mjhowell on 1/31/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "DefaultErrorViewController.h"

@interface DefaultErrorViewController ()

@end

@implementation DefaultErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.retryButton.layer.cornerRadius=10;
    self.retryButton.clipsToBounds=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
