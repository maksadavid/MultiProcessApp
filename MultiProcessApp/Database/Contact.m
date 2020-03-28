//
//  Contact.m
//  MultiProcessApp
//
//  Created by David Maksa on 22.03.20.
//  Copyright © 2020 David Maksa. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (instancetype)init {
    self = [super init];
    self.uniqueId = [[NSUUID UUID] UUIDString];
    return self;
}

+ (NSString *)collection {
    return @"Contact";
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.uniqueId forKey:@"uniqueId"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if ((self = [super init])) {
        self.uniqueId = [coder decodeObjectForKey:@"uniqueId"];
    }
    return self;
}

@end
