//
//  ComposeViewController.h
//  twitter
//
//  Created by britneyting on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

// we want the ComposeViewController to notify the TimelineViewController that we have a new tweet, so that we can add the tweet to the tweets array and reload the table view.

@protocol ComposeViewControllerDelegate // Need this here bc any other view controllers could potentially be presenting the ComposeViewController, not just the TimelineViewController. This protocol creates a contract betwen the ComposeViewController and whichever view controller presented it.

- (void)didTweet:(Tweet *)tweet; // the controller that conforms to the above protocol needs to implement this method inside so they can communicate with each other

@end

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeBarButton; //A UIBarButtonItem is a special button that’s designed to go into a navigation bar.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetBarButton;
@property (weak, nonatomic) IBOutlet UITextView *composeTweetView;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate; // The designation of weak with delegate properties has to do with ARC and avoiding memory leaks.

@end



NS_ASSUME_NONNULL_END
