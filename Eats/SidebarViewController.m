//
//  SidebarViewController.m
//  Appetite
//
//  Created by mjhowell on 2/6/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "SidebarViewController.h"
#import "UserImageProfileTableViewCell.h"
#import "SMOptionsTableViewCell.h"
#import "AppetiteChoiceViewController.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *appCustomCell = @"user_profile";
    if(indexPath.row==0){
        UserImageProfileTableViewCell *cell = (UserImageProfileTableViewCell *) [tableView dequeueReusableCellWithIdentifier:appCustomCell];
        
        if (!cell)
        {
            cell = [[UserImageProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appCustomCell];
        }
        cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bitmap_profile_tile"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        
        if(self.user_prof.email){
            cell.userProfileIdentifier.text =self.user_prof.email;
        }
        else {
            cell.userProfileIdentifier.text = @"Eat Smart, Buddy!";
        }
        NSLog(@"USER PROFILE");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    
    //static NSString *appCustomCell = @"user_profile";
    //static NSString *options = @"options";
    static NSString *CellIdentifier = @"Cell";
    
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"user_profile";
            break;
            
        case 1:
            CellIdentifier = @"home";
            break;
            
        case 2:
            CellIdentifier = @"settings";
            break;
        case 3:
            CellIdentifier = @"signOut";
            break;
        default:
            break;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    return cell;
    
    
  /*  //the first cell of the table display's the user's profile name along with a picture
    if(indexPath.row==0){
        UserImageProfileTableViewCell *cell = (UserImageProfileTableViewCell *) [tableView dequeueReusableCellWithIdentifier:appCustomCell];
            
            if (!cell)
            {
                cell = [[UserImageProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appCustomCell];
            }
        cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bitmap_profile_tile"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        
        if(self.user_prof.email){
            cell.userProfileIdentifier.text =self.user_prof.email;
        }
        else {
            cell.userProfileIdentifier.text = @"Eat Smart, Buddy!";
        }
        NSLog(@"USER PROFILE");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    //the cells after the first represent options avaiable to the user through the sidebar
    else if(indexPath.row>0){
        SMOptionsTableViewCell *cell = (SMOptionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:options];
        
        if (!cell)
        {
            cell = [[SMOptionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:options];
        }
        switch (indexPath.row){
            case 1:
                cell.icon.image = [UIImage imageNamed:@"ic_home"];
                cell.iconLabel.text = @"Home";
                break;
            case 2:
                cell.icon.image = [UIImage imageNamed:@"ic_settings"];
                cell.iconLabel.text = @"Settings";
                break;
            case 3:
                cell.icon.image = [UIImage imageNamed:@"sign_out"];
                cell.iconLabel.text = @"Sign Out";
                break;
            default:
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    return nil;*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row>0) ?  60: 105;
}

//navigating to the venue description with further options to navigate, call, and explore
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //programatic options to further specify actions with the click of a side menu option
    switch (indexPath.row){
        case 0:
            break;
        case 1:
            break;
        case 2:
            //[self performSegueWithIdentifier:@"set_radius" sender:nil];
            break;
        case 3:{
            AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [aDelegate resetWindowToInitialView];
            break;
        }
        default:
            NSLog(@"testtt");
            break;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Set the title of navigation bar by using the menu items
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    NSLog(@"THE SOURCE: %@", NSStringFromClass([segue.sourceViewController class]));
    
    if ([segue.identifier isEqualToString:@"go_home"]) {
        UINavigationController *navController = segue.destinationViewController;
        AppetiteChoiceViewController *home = [navController childViewControllers].firstObject;
        home.user = self.user_prof;
        NSLog(@"it worked!!!!!");
    }
    if ([segue.identifier isEqualToString:@"settings"]) {
        UINavigationController *navController = segue.destinationViewController;
        SettingsViewController *settings = [navController childViewControllers].firstObject;
        settings.user = self.user_prof;
    }
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
