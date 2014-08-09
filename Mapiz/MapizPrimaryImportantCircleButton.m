//
//  MapizPrimaryImportantCircleButton.m
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizPrimaryImportantCircleButton.h"

@implementation MapizPrimaryImportantCircleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSaveGState(context);
  
  //// Color Declarations
  UIColor* color = [UIColor colorWithRed: 0.302 green: 0.808 blue: 0.702 alpha: 1];
  UIColor* color2 = [UIColor colorWithRed: 0.282 green: 0.702 blue: 0.616 alpha: 1];
  
  //// Rectangle Drawing
  UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:rect];
  [color2 setFill];
  [circlePath fill];
  
  //  CGContextAddPath(context, rectanglePath.CGPath);
  
  //// Rectangle 2 Drawing
  UIBezierPath* circlePath2 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, rect.size.width, rect.size.height - 3)];
  [color setFill];
  [circlePath2 fill];
  
  [circlePath appendPath:circlePath2];
  
  CGContextAddPath(context, circlePath.CGPath);
  
  UIGraphicsPopContext();
  UIGraphicsEndImageContext();
  
}


@end
