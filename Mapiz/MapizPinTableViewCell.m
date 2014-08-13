//
//  MapizPinTableViewCell.m
//  Mapiz
//
//  Created by samuel on 14/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizPinTableViewCell.h"

@implementation MapizPinTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
