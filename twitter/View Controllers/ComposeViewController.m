//
//  ComposeViewController.m
//  twitter
//
//  Created by britneyting on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (IBAction)exit:(id)sender { // action method for the UIBarButton that allows you to close the screen
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)submitTweet:(id)sender { // checks if the post was successful, and if it is, then calls method on delegate and passes data
    
    [[APIManager shared]postStatusWithText:self.composeTweetView.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self dismissViewControllerAnimated:true completion:nil]; // dismisses the composeViewController after tweeting
        }
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
