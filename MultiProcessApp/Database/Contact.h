//
//  Contact.h
//  MultiProcessApp
//
//  Created by David Maksa on 22.03.20.
//  Copyright © 2020 David Maksa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Contact : NSObject

@property (nonatomic, strong) NSString *uniqueId;

+(NSString *)collection;

@end

NS_ASSUME_NONNULL_END
