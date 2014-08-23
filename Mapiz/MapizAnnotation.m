//
//  MapizAnnotation.m
//  Mapiz
//
//  Created by samuel on 15/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizAnnotation.h"
#import "MapizPinView.h"

@implementation MapizAnnotation

- (id)initWithPin:(MapizPin *)pin {
  self = [super init];
  
  if(self) {
    _pin = pin;
    if([pin isWhereAreYouType] && [pin isSender] && [pin hasReply]) {
      _coordinate = pin.recipientLocation.coordinate;
    } else {
      _coordinate = pin.senderLocation.coordinate;
    }
    
  }
  
  return self;
}

- (MKAnnotationView *) annotationView {
  MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MapizAnnotation"];
  
  MapizPinView *pinView = [[[NSBundle mainBundle] loadNibNamed:@"PinView" owner:nil options:nil] lastObject];
  
  [pinView.pinImage setImage:[UIImage imageNamed:[MapizPin pinImage:_pin.colour]]];
  
  [pinView.pinLabel setFont: [UIFont fontWithName:@"FontAwesome" size:18]];
  if([_pin isMeetup]) {
    if([_pin hasReply]) {
    
      if([_pin recipientIsGoing]) {
        [pinView.pinLabel setText:@"\uf00c"];
      } else {
        [pinView.pinLabel setText:@"\uf00d"];
      }
    
    } else {
      [pinView.pinLabel setText:@"\uf128"];
    }
  } else {
    if([_pin isWhereAreYouType] && [_pin hasReply]) {
      [pinView.pinLabel setText:[[_pin.recipient.username substringToIndex:1] uppercaseString]];
    } else {
      [pinView.pinLabel setText:[[_pin.sender.username substringToIndex:1] uppercaseString]];
    }
    
  }
  
  
//  [pinView.pinLabel setText:[[_pin.sender.username substringToIndex:1] uppercaseString]];

  UIGraphicsBeginImageContext(pinView.bounds.size);
  
  [pinView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  annotationView.centerOffset = CGPointMake(-30,-60);
  
  [annotationView addSubview:pinView];
  
  return annotationView;
}

@end
