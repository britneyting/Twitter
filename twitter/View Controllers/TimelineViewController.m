//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h" // need this library if you want to display images (ex: profile pictures)
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DateTools.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, DetailsViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) IBOutlet UITableView *tableView; // step 1: view controller has a tableView as a subview
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self; // step 3: view controller becomes its dataSource and delegate in viewDidLoad
    self.tableView.delegate = self;
    
    [self getTimeline];
    
    // code for activity indicator (refresh)
    self.refreshControl = [[UIRefreshControl alloc] init]; // do self refreshControl instead of UIRefreshControl *refreshControl since we already declared the variable refreshControl in properties
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0]; // inserts the activity indicator at index0 (before the first tweet)
    
}

// Get timeline
- (void)getTimeline {
    
    [self.activityIndicator startAnimating];

    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) { // step 4: make API request
        if (tweets) {
            self.tweets = [[NSMutableArray alloc] initWithArray:tweets]; // initializes an array filled with Tweets. Step 6: view controller stores that data passed into the completion handler
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            
            [self.tableView reloadData]; // step 7: reload the table view
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];

    }];
}

// step 9: numberOfRows returns the # of items returned from the API
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    // step 10:
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath]; // identifier is named TweetCell (click on Tweet Cell in storyboard and rename identifier to TweetCell
        
    Tweet *tweet = self.tweets[indexPath.row]; // Tweet class is blueprint for each tweet. (similar to NSDictionary *movie in FlixApp. We then call the tweets with self.tweets
    
    cell.tweet = tweet;
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.tweetboxLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    cell.retweetsLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.heartsLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    // sets propic image
    NSURL *profilePicURL = [NSURL URLWithString:tweet.user.profilePic]; // NSURL checks to make sure link is a valid URL
    cell.propicImage.image = nil;
    [cell.propicImage setImageWithURL:profilePicURL];
    
    return cell;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (void)didTweet:(Tweet *)tweet { // the composeViewController sends the text in the composeTweetView over here as a Tweet object to post
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)updateData:(UIViewController *)viewController {
    
}

#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueToCompose"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"segueToDetails"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
        [self addChildViewController:detailsViewController];
        detailsViewController.delegate = self;
        NSLog(@"Tapping on a tweet!");
    }

}


@end
