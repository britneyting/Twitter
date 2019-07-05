//
//  TweetCell.m
//  twitter
//
//  Created by britneyting on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"

@implementation TweetCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapReply:(id)sender {
}
- (IBAction)didTapRetweet:(id)sender {
    
    // updates color and count of retweet button when pressed/unpressed
    
    if (self.tweet.retweeted){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self unretweeted:self.tweet];
    }
    else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self retweeted:self.tweet];
    }
}

- (void)retweeted:(Tweet *)tweet {
    
    // tells APIManager to send POST request for retweeting
    
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
    [self refreshData:self.tweet];
}

- (void)unretweeted:(Tweet *)tweet {
    
    // tells APIManager to send POST request for unretweeting
    
    [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
        }
    }];
    
    [self refreshData:self.tweet];
}

- (IBAction)didTapFavorite:(id)sender {
    // TODO: Update the local tweet model
    // TODO: Update cell UI
    // TODO: Send a POST request to the POST favorites/create endpoint
    
    if (self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self unfavorite:self.tweet];
    }
    else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self favorited:self.tweet];
    }

}

- (void)favorited:(Tweet *)tweet {
    
    // tells APIManager to send POST request for favoriting
    
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
    [self refreshData:self.tweet];
}

- (void)unfavorite:(Tweet *)tweet {
    
    // tells APIManager to send POST request for unfavoriting
    
    [[APIManager shared] unfavorited:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
        }
    }];
    [self refreshData:self.tweet];
}


- (void)refreshData:(Tweet *)tweet {
    if (self.tweet.retweeted){
        self.retweetsLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
        [self.retweetButton setSelected:YES];
    }
    else{
        self.retweetsLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
        [self.retweetButton setSelected:NO];
    }
    if (self.tweet.favorited){
        self.heartsLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
        [self.heartButton setSelected:YES];
    }
    else{
        self.heartsLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
        [self.heartButton setSelected:NO];
    }
}

@end
