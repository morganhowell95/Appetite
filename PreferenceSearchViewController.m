//
//  PreferenceSearchViewController.m
//  Eats
//
//  Created by mjhowell on 1/5/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "PreferenceSearchViewController.h"

@interface PreferenceSearchViewController ()

@end

@implementation PreferenceSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //initializetable view 
//    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
//   // self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    //latitude and longitude originally set to first suggestion
    Venue *first_suggestion = [self.venue_collection.venue_collection firstObject];
    self.latitude = [first_suggestion.latitude doubleValue];
    self.longitude = [first_suggestion.longitude doubleValue];
    NSLog(@"latitude: %f longitude:%f", self.latitude, self.longitude);
    
    //Setting up map delegate
    self.mapView.showsUserLocation=YES;
    float spanX = 0.01025;
    float spanY = 0.01025;
    MKCoordinateRegion region;
    region.center.latitude = self.latitude;
    region.center.longitude = self.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
    
   // self.view = self.tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
   // Region *region = [regions objectAtIndex:section];
    NSLog(@"count of rows in section: %d", [self.venue_collection.venue_collection count]);
    return [self.venue_collection.venue_collection count];
}


/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    //Region *region = [regions objectAtIndex:section];
    return @"EXAMPLE TITLE FOR HEADER ON SECTION";
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    
    
    //import item from list and display as label within custom rows
    Venue *venue = [self.venue_collection.venue_collection objectAtIndex:indexPath.row];
    cell.textLabel.text = venue.name;
    UIFont *eats_standard_font = [UIFont fontWithName:@"American Typewriter" size:13];
    [cell.textLabel setFont:eats_standard_font];
    
    // returns custom cell for a row that matches a given index
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
