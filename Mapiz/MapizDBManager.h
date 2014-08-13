//
//  MapizDBManager.h
//  Mapiz
//
//  Created by samuel on 10/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapizUser.h"
#import <sqlite3.h>

@interface MapizDBManager : NSObject {
  NSString *databasePath;
}

+(MapizDBManager*)getSharedInstance;
-(void)createDB;
-(void)dropUserTable;
-(void)resetUserTable;
-(void)createUserTable;
-(BOOL) saveUser:(NSString*)_id
        username:(NSString*)username
     displayName:(NSString*)displayName;
-(BOOL) saveUser:(MapizUser*)user;
-(void) saveUsers:(NSArray *)records;
-(MapizUser*) findUserByID:(NSString*)_id;
-(NSMutableArray*) findUsersStartingWithLetter:(NSString*)letter;
-(NSMutableArray*) searchUsersStartingWithLetter:(NSString*)letter
                                           query:(NSString*)query;

@end
