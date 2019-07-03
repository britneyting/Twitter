//
//  User.m
//  twitter
//
//  Created by britneyting on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User


// this initializer takes the data (in the form of a dictionary), pulls the data, and forms an empty instance of the class. Then when the app needs to read the data, it'll fill in the object.
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePic = dictionary[@"profile_image_url_https"];
        // Initialize any other properties
    }
    return self;
}

@end
