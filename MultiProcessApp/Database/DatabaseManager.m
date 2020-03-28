//
//  DatabaseManager.m
//  MultiProcessApp
//
//  Created by David Maksa on 19.03.20.
//  Copyright © 2020 David Maksa. All rights reserved.
//

#import "DatabaseManager.h"
#import <YapDatabase/YapDatabase.h>
#import <YapDatabase/YapDatabaseAutoView.h>
#import <YapDatabase/YapDatabaseFilteredView.h>
#import <YapDatabase/YapDatabaseSecondaryIndex.h>
#import <YapDatabase/YapDatabaseRelationship.h>

#import "Message.h"

@interface DatabaseManager()
@property (nonatomic, strong) YapDatabase *database;
@property (nonatomic, strong) dispatch_queue_t fileDatabaseDispatchQueue;
@end

@implementation DatabaseManager


- (void)setupDatabase {

    NSString *path = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.ch.adeya"].path stringByAppendingPathComponent:@"SQLite.sqlite"];
    
    YapDatabaseOptions *databaseOptions = [[YapDatabaseOptions alloc] init];
    databaseOptions.corruptAction = YapDatabaseCorruptAction_Fail;
    databaseOptions.enableMultiProcessSupport = YES;
    databaseOptions.cipherUnencryptedHeaderLength = 32;
    databaseOptions.cipherSaltBlock = ^NSData * _Nonnull{
        return [[@"RandomDatabaseSalt" dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(0, 16)];
    };
    databaseOptions.cipherKeyBlock = ^{
        return [@"DatabaseKey" dataUsingEncoding:NSUTF8StringEncoding];
    };
    
    self.database = [[YapDatabase alloc] initWithPath:path
                                           serializer:[YapDatabase defaultSerializer]
                                         deserializer:NULL
                                         preSanitizer:NULL
                                        postSanitizer:NULL
                                              options:databaseOptions];
    
    self.firstDatabaseConnection = [self.database newConnection];
    self.firstDatabaseConnection.name = @"firstDatabaseConnection";
    self.secondDatabaseConnection = [self.database newConnection];
    self.secondDatabaseConnection.name = @"secondDatabaseConnection";

    YapDatabaseAutoView *view = [self.database registeredExtension:@"view"];
    if (!view) {
         YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:^NSString * _Nullable(YapDatabaseReadTransaction * _Nonnull transaction, NSString * _Nonnull collection, NSString * _Nonnull key, id  _Nonnull object) {
            return @"group";
         }];
        YapDatabaseViewSorting *sorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(YapDatabaseReadTransaction * _Nonnull transaction, NSString * _Nonnull group, NSString * _Nonnull collection1, NSString * _Nonnull key1, id  _Nonnull object1, NSString * _Nonnull collection2, NSString * _Nonnull key2, id  _Nonnull object2) {
            return  [((Message *)object1).uniqueId compare: ((Message *)object2).uniqueId];
        }];
        
        YapDatabaseViewOptions *options = [[YapDatabaseViewOptions alloc] init];
        options.isPersistent = YES;
        options.allowedCollections = [[YapWhitelistBlacklist alloc] initWithWhitelist:[NSSet setWithObject:[Message collection]]];
        view = [[YapDatabaseAutoView alloc] initWithGrouping:grouping sorting:sorting versionTag:@"1" options:options];
        [self.database registerExtension:view withName:@"view"];
    }
    
}

@end
