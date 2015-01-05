//
//  EatsChoice.m
//  Eats
//
//  Created by mjhowell on 12/29/14.
//  Copyright (c) 2014 Guru. All rights reserved.
//

#import "EatsChoice.h"

@implementation EatsChoice

//initialize each option choice (updated through buttons in Taste Identify Contoller) with a corresponding "taste" of food and picture
- (instancetype) initWithChoices: (UIImage *)back  appetite: (NSString *)taste
{
    
    self = [super init];
    
    if(self){
        [self setButtonback:back];
        [self setAppetite:taste];
        
    }
    
    
    return self;
}

- (instancetype) init
{
    return [self initWithChoices:nil appetite:nil];
}

@end
