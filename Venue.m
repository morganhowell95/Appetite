//
//  Venue.m
//  Eats
//
//  Created by mjhowell on 1/5/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "Venue.h"

@implementation Venue


//constructing a venue object with only the name (not the designated constructor)
- (instancetype) initWithName:(NSString *)name
{
    
    self = [super init];
    
    
    if(self){
        self.name=name;
    }
    
    return self;
}

@end
