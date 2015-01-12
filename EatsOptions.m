//
//  EatsOptions.m
//  Eats
//
//  Created by mjhowell on 12/29/14.
//  Copyright (c) 2014 Guru. All rights reserved.
//

#import "EatsOptions.h"
#import "EatsChoice.h"

@implementation EatsOptions

- (instancetype) init
{
    
    self = [super init];
    
    if(self){
        
        self.options = [[NSArray alloc] initWithObjects:
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"date"] appetite:@"Date Night"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"girlsnightout"] appetite:@"Girls Night"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"weedicon"] appetite:@"Baked"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"sportscomplete"] appetite:@"Games On"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"outdrunkingicon"] appetite:@"Out Drinking"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"soberuppizzalogo"] appetite:@"Sober Up"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"fastfood"] appetite:@"On The Go"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"study"] appetite:@"Studying"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"cherries"] appetite:@"Dessert"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"diet"] appetite:@"Diet"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"savemoney"] appetite:@"Cheap"],
                   [[EatsChoice alloc] initWithChoices:[UIImage imageNamed:@"sushi"] appetite:@"Sushi"],
                   nil];
        
        
    }
    return self;
}

@end
