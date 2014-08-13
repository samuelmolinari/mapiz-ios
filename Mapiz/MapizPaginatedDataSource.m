//
//  MapizPaginatedDataSource.m
//  Mapiz
//
//  Created by samuel on 13/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizPaginatedDataSource.h"

@implementation MapizPaginatedDataSource

NSMutableArray *sections;
NSMutableArray *sectionsCount;
BOOL currentlyLoading;
int pageInMemory = 5;
int pageSize = 25;


- (id) init {
  self = [super init];
  
  currentlyLoading = NO;
  
  return self;
}

- (BOOL) hasItem: (NSObject*) item {
  for(NSArray *sectionItems in sections) {
    if ([sectionItems indexOfObject: item] != NSNotFound) {
      return YES;
    }
  }
  return NO;
}

- (NSIndexPath*) getIndexPathOfItem:(NSObject *) item {
  int sectionIndex = 0;
  for(NSArray *sectionItems in sections) {
    NSUInteger index = [sectionItems indexOfObject: item];
    if (index != NSNotFound) {
      NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:sectionIndex];
      return indexPath;
    }
    sectionIndex++;
  }
  
  return NULL;
}

- (void) addItem:(NSObject*) item toIndexPath: (NSIndexPath*) indexPath {
  NSMutableArray * sectionItems = [sections objectAtIndex:indexPath.section];
  [sectionItems insertObject:item atIndex:indexPath.row];
  [self updateCountForSection:indexPath.section];
}

- (void) addItem:(NSObject*) item {
  [self addItem: item toIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (void) removeItem:(NSObject*) item {
  int sectionIndex = 0;
  for(NSMutableArray *sectionItems in sections) {
    
    NSUInteger index = [sectionItems indexOfObject: item];
    if (index != NSNotFound) {
      [sectionItems removeObjectAtIndex:index];
      [self updateCountForSection:sectionIndex];
    }
  }
}

- (void) updateCountForSection:(NSInteger) sectionIndex {
  [sectionsCount replaceObjectAtIndex:sectionIndex withObject:[NSNumber numberWithUnsignedLong:[[sections objectAtIndex:sectionIndex] count]]];
}

- (void) whenFetchedRecords: (NSArray *) records atPage: (int) page {
  
  for(NSObject *record in records) {
    
  }
}

@end
