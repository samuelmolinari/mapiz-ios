//
//  MapizDangerImportantButton.m
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizDangerImportantButton.h"

@implementation MapizDangerImportantButton

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
  UIColor* color2 = [UIColor colorWithRed: 0.73 green: 0.33 blue: 0.34 alpha: 1];
  UIColor* color = [UIColor colorWithRed: 0.85 green: 0.38 blue: 0.4 alpha: 1];
  
  //// Rectangle Drawing
  UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rect cornerRadius: 3];
  [color2 setFill];
  [rectanglePath fill];
  
  //  CGContextAddPath(context, rectanglePath.CGPath);
  
  //// Rectangle 2 Drawing
  UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, rect.size.width, rect.size.height - 3) cornerRadius: 3];
  [color setFill];
  [rectangle2Path fill];
  
  [rectanglePath appendPath:rectangle2Path];
  
  CGContextAddPath(context, rectanglePath.CGPath);
  
  UIGraphicsPopContext();
  UIGraphicsEndImageContext();
  
}

@end
