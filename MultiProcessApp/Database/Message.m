//
//  Message.m
//  MultiProcessApp
//
//  Created by David Maksa on 19.03.20.
//  Copyright © 2020 David Maksa. All rights reserved.
//

#import "Message.h"

@interface Message()

@end

@implementation Message

- (instancetype)init {
    self = [super init];
    self.uniqueId = [[NSUUID UUID] UUIDString];
    return self;
}

+ (NSString *)collection {
    return @"Message";
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
