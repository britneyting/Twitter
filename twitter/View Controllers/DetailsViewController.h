//
//  DetailsViewController.h
//  twitter
//
//  Created by britneyting on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewControllerDelegate<NSObject> // Need this here bc any other view controllers could potentially be presenting the ComposeViewController, not just the TimelineViewController. This protocol creates a contract betwen the ComposeViewController and whichever view controller presented it.

- (void)updateData:(UIViewController *)viewController; // the controller that conforms to the above protocol needs to implement this method inside so they can communicate with each other

@end

@interface DetailsViewController : UIViewController

@property (nonatomic, weak) Tweet *tweet;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate; // The designation of weak with delegate properties has to do with ARC and avoiding memory leaks.

@end

NS_ASSUME_NONNULL_END
