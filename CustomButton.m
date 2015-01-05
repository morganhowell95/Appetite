//
//  CustomButton.m
//  Eats
//
//  Created by mjhowell on 1/4/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        self.imageView.alpha = 1;
    } else {
        self.imageView.alpha = .15;
    }
}

- (void) setBackgroundAlpha: (double) alp
{
    self.imageView.alpha = .15;
}

@end
