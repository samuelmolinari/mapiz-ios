//
//  MapizPinView.h
//  Mapiz
//
//  Created by samuel on 16/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapizPinView : UIView {
  IBOutlet UIImageView *pinImage;
  IBOutlet UILabel *pinLabel;
}

@property (nonatomic,retain) IBOutlet UIImageView *pinImage;
@property (nonatomic,retain) IBOutlet UILabel *pinLabel;

@end
