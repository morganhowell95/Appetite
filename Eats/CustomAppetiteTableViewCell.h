//
//  CustomAppetiteTableViewCell.h
//  Appetite
//
//  Created by mjhowell on 1/31/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAppetiteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *phoneCall;
@property (weak, nonatomic) IBOutlet UIButton *navDirect;
@property (weak, nonatomic) IBOutlet UIImageView *compassView;
@property (weak, nonatomic) IBOutlet UILabel *addressLocation;
@property (strong, nonatomic) IBOutlet UILabel *venueName;


@end
