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
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *venue_description;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *locu_id;
@property (strong, nonatomic) NSString *contact;
@property (strong, nonatomic) NSString *locality;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *region;

- (instancetype) initWithName:(NSString *)name;

@end
