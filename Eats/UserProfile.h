//
//  UserProfile.h
//  Eats
//
//  Created by mjhowell on 1/18/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *personal_id;
@property (strong, nonatomic) NSString *current_mood;
@property (strong, nonatomic) NSString *FBname;
@property (strong, nonatomic) NSString *FBpicture;
@property int searchRadius;

@end
