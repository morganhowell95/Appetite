//
//  Tutorial.m
//  Eats
//
//  Created by mjhowell on 1/18/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "Tutorial.h"

@interface Tutorial ()

@end

@implementation Tutorial

- (instancetype) init{
    
    self = [super init];
    
    if(self){
        self.image1 = [[UIImageView alloc] init];
        self.tutorial_step = [[UILabel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
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
