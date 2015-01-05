//
//  EatsChoice.h
//  Eats
//
//  Created by mjhowell on 12/29/14.
//  Copyright (c) 2014 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EatsChoice : NSObject

@property (strong, nonatomic) UIImage *buttonback;
@property (strong, nonatomic) NSString *appetite;
@property int isChosen;

- (instancetype)initWithChoices: (UIImage *)back  appetite: (NSString *)taste;
@end
