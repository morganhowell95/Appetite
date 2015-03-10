//
//  FoodSwingsViewController.m
//  Appetite
//
//  Created by mjhowell on 1/21/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "FoodSwingsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "VenueListTableViewController.h"
#define APP_URL @"http://site-cater.rhcloud.com/"

@interface FoodSwingsViewController ()

@end

@implementation FoodSwingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadFoodSwing];
    self.food_choice.text = self.chosen_mood.titleLabel.text;

    
    //place border around buttons
    for(UIButton *button in self.foodSwingChoices){
        [[button layer] setBorderWidth:0.35f];
        [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"<<" style: UIBarButtonItemStylePlain target:self action:@selector(Back)];
    self.navigationBar.leftBarButtonItem = backButton;
}

- (void) loadFoodSwing {
    
    @try{
        self.progress.hidden=NO;
        [self.progress startAnimating];
        
        //Opening HTTP Post request to Appetite Server API for mood swings
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //POST content (being sent)
        NSString *moodSwingGen_url = [NSString stringWithFormat:@"%@tags/mood_swing/",APP_URL];
        
        NSLog(@"MOOOD ID: %d", self.chosen_mood.moodID);
        
        if((self.user.password!=nil) && (self.user.email!=nil)){
            self.fieldPost = @{@"email" : self.user.email, @"password" : self.user.password, @"mood" : @(self.chosen_mood.moodID)};
        }
        else{
            self.fieldPost = @{@"mood" : @(self.chosen_mood.moodID)};
        }
        
        
        NSLog(@"CHOSEN MOOD ID SUBMITTED: %d", self.chosen_mood.moodID);
        
        //making the request via URL form feed encoded POST
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [jsonAcceptableContentTypes addObject:@"text/plain"];
        jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
        manager.responseSerializer = jsonResponseSerializer;
        
        //The response object pre-parsed into NSDictionary format (during block)
        [manager POST:moodSwingGen_url parameters:self.fieldPost
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //uncomment to print the JSON that the server responds with
             NSLog(@"JSON: %@", responseObject);
            
            int mood_count=0;
             for(NSDictionary *dict in responseObject) {
                 NSString *count = [dict valueForKey:@"pk"];
                 [[self.foodSwingChoices objectAtIndex:mood_count] setTitle:[dict valueForKey:@"name"] forState: UIControlStateNormal];
                   [[self.foodSwingDescriptions objectAtIndex:mood_count] setText:[dict valueForKey:@"description"]];
                 [[self.foodSwingChoices objectAtIndex:mood_count] setFoodSwingID:(int) [count integerValue]];
                 mood_count++;
                 
                 //hault load progress meter and parse result for mood generation
                 self.progress.hidden=YES;
                 [self.progress stopAnimating];
             }
         }
              failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             //hault load progress meter and report error
             self.progress.hidden=YES;
             [self.progress stopAnimating];
              [self performSegueWithIdentifier:@"error2" sender:nil];
         }];
    }
    @catch (NSException *e){
        NSLog(@"%@", e.reason);
        [self performSegueWithIdentifier:@"error2" sender:nil];
    }
    
    
}

//Food Swing button action event
- (IBAction)foodSwingChoiceEvent:(CustomButton *)sender {
    [self performSegueWithIdentifier:@"load_venues" sender:sender];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Back
{
    //[self dismissViewControllerAnimated:YES completion:nil]; // ios 6]
   // NSArray *viewControllers = [self.navigationController viewControllers];
   // UIViewController *popTo = [viewControllers objectAtIndex:0];
   // [self.navigationController popToViewController:popTo animated:YES];
   [self.navigationController popViewControllerAnimated:NO];
   // [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(CustomButton *)sender
{
    VenueListTableViewController *dest = [segue destinationViewController];
    dest.user=self.user;
    dest.foodSwingChoice = sender.foodSwingID;
}


@end
