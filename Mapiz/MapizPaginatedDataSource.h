//
//  MapizPaginatedDataSource.h
//  Mapiz
//
//  Created by samuel on 13/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapizPaginatedDataSource : NSObject<UITableViewDataSource>
  typedef void(^PageFetchedCallback)(NSArray *records);
@end
