//
//  Venue.h
//  Eats
//
//  Created by mjhowell on 1/5/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *coordinates;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *locu_id;
@property (strong, nonatomic) NSString *contact;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

- (instancetype) initWithName:(NSString *)name;

@end
