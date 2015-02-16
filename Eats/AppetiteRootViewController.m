//
//  AppetiteRootViewController.m
//  Eats
//
//  Created by mjhowell on 1/17/15.
//  Copyright (c) 2015 Guru. All rights reserved.
//

#import "AppetiteRootViewController.h"
#import "Tutorial.h"

@interface AppetiteRootViewController ()
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation AppetiteRootViewController

//Page control methods synced with scroll view object
- (void)loadPage:(NSInteger)page {
    //pass: all images loaded at startup
}

- (void)purgePage:(NSInteger)page {
    //pass all images loaded at startup
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
     CGFloat pageWidth = self.scroll_view.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scroll_view.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //retrieve object view form storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Tutorial *firstpage = [storyboard instantiateViewControllerWithIdentifier:@"Tutorial"];
    Tutorial *secondpage = [storyboard instantiateViewControllerWithIdentifier:@"Tutorial"];
    Tutorial *thirdpage = [storyboard instantiateViewControllerWithIdentifier:@"Tutorial"];
    
    
    self.pageImages = [NSArray arrayWithObjects:
                       firstpage,
                       secondpage,
                       thirdpage,
                       nil];
    
    //disable scroll indicators
    [self.scroll_view setShowsHorizontalScrollIndicator:NO];
    [self.scroll_view setShowsVerticalScrollIndicator:NO];
    self.scroll_view.delegate=self;
    
    //add controllers to childview
    [self addChildViewController:firstpage];
    [self addChildViewController:secondpage];
    [self addChildViewController:thirdpage];
    
    
    //instantiatie content and set views
    CGFloat width = self.scroll_view.frame.size.width;
    CGFloat height = self.scroll_view.frame.size.height;
    firstpage.view.frame = CGRectMake(0, 0, width, height);
    [self.scroll_view addSubview:firstpage.view];
    firstpage.tutorial_step.text = @"Appetite is a new approach for finding venues.";
    firstpage.image1.image = [UIImage imageNamed:@"tut1"];
    secondpage.view.frame = CGRectMake(width, 0, width, height);
    [self.scroll_view addSubview:secondpage.view];
    secondpage.tutorial_step.text= @"It allows you to choose a mood and \"food swings\".";
    secondpage.image1.image = [UIImage imageNamed:@"tut2"];
    thirdpage.view.frame = CGRectMake(width * 2, 0, width, height);
    [self.scroll_view addSubview:thirdpage.view];
    thirdpage.tutorial_step.text=@"So that you can find your personal appetite, fast.";
    thirdpage.image1.image = [UIImage imageNamed:@"tut3"];
    
    //track page count (also via loadVisiblePages)
    NSInteger pageCount = self.pageImages.count;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGSize pagesScrollViewSize = self.scroll_view.frame.size;
    self.scroll_view.contentSize = CGSizeMake(pagesScrollViewSize.width * 3, pagesScrollViewSize.height);
    [self loadVisiblePages];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
