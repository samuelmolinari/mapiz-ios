//
//  MapizPrimaryImportant.m
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizPrimaryImportantButton.h"

@implementation MapizPrimaryImportantButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

///*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.302 green: 0.808 blue: 0.702 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.282 green: 0.702 blue: 0.616 alpha: 1];
    
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
//*/

@end
