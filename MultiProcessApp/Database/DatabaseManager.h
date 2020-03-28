//
//  DatabaseManager.h
//  MultiProcessApp
//
//  Created by David Maksa on 19.03.20.
//  Copyright © 2020 David Maksa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YapDatabase/YapDatabase.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseManager : NSObject

@property (nonatomic, strong, readonly) YapDatabase *database;
@property (nonatomic, strong) YapDatabaseConnection *firstDatabaseConnection;
@property (nonatomic, strong) YapDatabaseConnection *secondDatabaseConnection;

- (void)setupDatabase;

@end

NS_ASSUME_NONNULL_END
