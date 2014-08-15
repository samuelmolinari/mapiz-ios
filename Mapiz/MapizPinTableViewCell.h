//
//  MapizPinTableViewCell.h
//  Mapiz
//
//  Created by samuel on 14/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapizPinTableViewCell : UITableViewCell {
  IBOutlet UIView *square;
  IBOutlet UILabel *username;
  IBOutlet UILabel *createdAt;
  IBOutlet UILabel *caption;
  IBOutlet UILabel *icon;
  IBOutlet UILabel *subIcon;
}

@property (nonatomic, retain) IBOutlet UIView *square;
@property (nonatomic, retain) IBOutlet UILabel *username;
@property (nonatomic, retain) IBOutlet UILabel *createdAt;
@property (nonatomic, retain) IBOutlet UILabel *caption;
@property (nonatomic, retain) IBOutlet UILabel *icon;
@property (nonatomic, retain) IBOutlet UILabel *subIcon;

-(void) setSquareColour: (UIColor*) color;

@end
