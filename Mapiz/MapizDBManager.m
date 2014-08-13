//
//  MapizDBManager.m
//  Mapiz
//
//  Created by samuel on 10/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizDBManager.h"

static MapizDBManager *sharedInstance = nil;
static sqlite3 *database = nil;
//static sqlite3_stmt *statement = nil;

@implementation MapizDBManager

+(MapizDBManager*)getSharedInstance{
  if (!sharedInstance) {
    sharedInstance = [[super allocWithZone:NULL]init];
    [sharedInstance createDB];
  }
  return sharedInstance;
}

-(void)createDB{
  NSString *docsDir;
  NSArray *dirPaths;
  // Get the documents directory
  dirPaths = NSSearchPathForDirectoriesInDomains
  (NSDocumentDirectory, NSUserDomainMask, YES);
  docsDir = dirPaths[0];
  // Build the path to the database file
  databasePath = [[NSString alloc] initWithString:
                  [docsDir stringByAppendingPathComponent: @"mapiz.db"]];

  NSFileManager *filemgr = [NSFileManager defaultManager];
  if ([filemgr fileExistsAtPath: databasePath ] == NO) {
    [self createUserTable];
  }
}

-(void)dropUserTable {
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
    char *errMsg;
    const char *sql_stmt = "drop table if exists friends";
    sqlite3_stmt *statement = nil;
    sqlite3_exec(database, sql_stmt, NULL, &statement, &errMsg);
    sqlite3_finalize(statement);
    sqlite3_close(database);
  }
}

- (void)resetUserTable {
  [self dropUserTable];
  [self createUserTable];
}

-(void)createUserTable {
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
    char *errMsg;
    const char *sql_stmt = "create table if not exists friends (id text primary key, username text, display_name text)";
    sqlite3_stmt *statement = nil;
    sqlite3_exec(database, sql_stmt, NULL, &statement, &errMsg);
    sqlite3_finalize(statement);
    sqlite3_close(database);
  }
}

- (BOOL) saveUser:(NSString *)_id username:(NSString *)username displayName:(NSString *)displayName {
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
    BOOL b = [self _saveUser:_id username:username displayName:displayName];
    sqlite3_close(database);
    return b;
  }
  return NO;
}

- (BOOL) saveUserOpened:(NSString *)_id username:(NSString *)username displayName:(NSString *)displayName {
  return [self _saveUser:_id username:username displayName:displayName];
}

- (BOOL) saveUserOpened:(MapizUser *)user {
  return [self saveUserOpened:user._id username:user.username displayName:user.displayName];
}

- (BOOL) saveUser:(MapizUser *)user {
  return [self saveUser:user._id username:user.username displayName:user.displayName];
}

- (void) saveUsers:(NSArray *) records {
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
    MapizDBManager *dbManager = [MapizDBManager getSharedInstance];
    for(NSDictionary *friend in records) {
      MapizUser *user = [[MapizUser alloc] initWithResponse:friend];
      BOOL success = [self saveUserOpened:user];
    }
    sqlite3_close(database);
  }
}

- (BOOL) _saveUser:(NSString *)_id username:(NSString *)username displayName:(NSString *)displayName {
  NSString *insertSQL = [NSString stringWithFormat:@"insert into friends (id,username,display_name) values (\"%@\",\"%@\",\"%@\")",_id,username,displayName ?: @""];
  const char *insert_stmt = [insertSQL UTF8String];
  sqlite3_stmt *statement = nil;
  sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
  if (sqlite3_step(statement) == SQLITE_DONE) {
    return YES;
  } else {
    NSLog(@"%s",sqlite3_errmsg(database));
    return NO;
  }
  sqlite3_finalize(statement);
  
  return NO;
}

-(MapizUser *)findUserByID:(NSString *)_id {
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
    NSString *querySQL = [NSString stringWithFormat:
                          @"select username, display_name from friends where id=\"%@\"",_id];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
      if (sqlite3_step(statement) == SQLITE_ROW) {
        
        MapizUser *mapizUser = [[MapizUser alloc] init];
        mapizUser._id = _id;
        mapizUser.username = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 0)];
        mapizUser.displayName = [[NSString alloc]initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 1)];
        return mapizUser;
      } else {
        NSLog(@"Not found");
        return nil;
      }
      sqlite3_finalize(statement);
      
    }
  }
  return nil;
}

-(NSMutableArray *)searchUsersStartingWithLetter: (NSString *)letter query: (NSString *)query {
  NSMutableArray *results = [[NSMutableArray alloc] init];
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
    
    NSString *querySQL = [NSString stringWithFormat:
                          @"select id, username, display_name from friends where username LIKE \"%@%%\" ORDER BY username",letter];
    
    if([query length] > 1) {
      querySQL = [NSString stringWithFormat:
                  @"select id, username, display_name from friends where username LIKE \"%@%%\" AND (username LIKE \"%%%@%%\" OR display_name LIKE \"%%%@%%\") ORDER BY username",letter, query, query];
    }
    
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
     
      while(sqlite3_step(statement) == SQLITE_ROW) {
        MapizUser *mapizUser = [[MapizUser alloc] init];
        mapizUser._id = [[NSString alloc] initWithUTF8String:
                         (const char *) sqlite3_column_text(statement, 0)];
        mapizUser.username = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 1)];
        mapizUser.displayName = [[NSString alloc]initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 2)];
        [results addObject:mapizUser];
      }
      
      sqlite3_finalize(statement);
      sqlite3_close(database);
      
    }
    
  }
  
  return results;
}

@end
