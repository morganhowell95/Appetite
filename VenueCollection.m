//
//  VenueCollection.m
//  Eats
//
//  Created by mjhowell on 1/5/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "VenueCollection.h"

@implementation VenueCollection

- (instancetype) init
{
    
    self=[super init];
    
    if(self){
        self.venue_collection = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
