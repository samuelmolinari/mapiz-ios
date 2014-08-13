//
//  MapizPin.m
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import "MapizPin.h"

@implementation MapizPin

@synthesize _id;
@synthesize _type;
@synthesize _status;
@synthesize colour;
@synthesize sender;
@synthesize recipient;
@synthesize recipientHereAt;
@synthesize senderHereAt;
@synthesize senderLocation;
@synthesize recipientLocation;

- (id) initWithResponse: (NSDictionary*) response {
  self = [super init];
  
  self._id = [response valueForKeyPath:@"_id"];
  self._type = [[response valueForKeyPath:@"_type"] intValue];
  self._status = [[response valueForKeyPath:@"_status"] intValue];
  self.colour = [[response valueForKeyPath:@"colour"] intValue];

  self.sender = [[MapizUser alloc] initWithResponse:@{
                                                      @"_id": [response valueForKeyPath:@"sender_id"],
                                                      @"username": [response valueForKeyPath:@"sender.username"],
                                                      @"display_name": [response valueForKeyPath:@"sender.display_name"] ?: @""
                                                      }];
  
  self.recipient = [[MapizUser alloc] initWithResponse:@{
                                                      @"_id": [response valueForKeyPath:@"recipient_id"],
                                                      @"username": [response valueForKeyPath:@"recipient.username"],
                                                      @"display_name": [response valueForKeyPath:@"recipient.display_name"] ?: @""
                                                      }];

  double senderLat = [[[response valueForKeyPath:@"sender.lat_lon.lat"] stringValue] doubleValue];
  double senderLng = [[[response valueForKeyPath:@"sender.lat_lon.lon"] stringValue] doubleValue];
  self.senderLocation = [[CLLocation alloc] initWithLatitude:senderLat longitude:senderLng];
  
  double recipientLat = [[[response valueForKeyPath:@"sender.lat_lon.lat"] stringValue] doubleValue];
  double recipientLng = [[[response valueForKeyPath:@"sender.lat_lon.lon"] stringValue] doubleValue];
  self.recipientLocation = [[CLLocation alloc] initWithLatitude:recipientLat longitude:recipientLng];
  
  NSTimeInterval senderTimestamp = [[response valueForKeyPath:@"sender.here_at.$date"] longValue] / 1000;
  self.senderHereAt = [[NSDate alloc] initWithTimeIntervalSince1970:senderTimestamp];
  
  NSTimeInterval recipientTimestamp = [[response valueForKeyPath:@"recipient.here_at.$date"] longValue] / 1000;
  self.recipientHereAt = [[NSDate alloc] initWithTimeIntervalSince1970:recipientTimestamp];
  
  return self;
}

- (BOOL) isImHereType {
  return self._type == PinTypeImHere;
}

- (BOOL) isWhereAreYouType {
  return self._type == PinTypeWhereAreYou;
}

- (BOOL) isMeetup {
  return self._type == PinTypeMeetMeThere;
}

+ (void) callWhereAreYou: (NSArray *) recipients responseCallback:(MeteorClientMethodCallback) responseCallback {
  [[MapizDDPClient getInstance] callMethodName: @"submitPin"
                                    parameters: @[[NSNumber numberWithInteger:PinTypeWhereAreYou], recipients]
                              responseCallback: responseCallback];
}

+ (void) callImHere:(NSArray *)recipients coordinates:(CLLocation *)location hereAt:(NSDate *)hereAt responseCallback:(MeteorClientMethodCallback)responseCallback {
  [MapizPin callSubmitPinOfType:PinTypeImHere toRecipients:recipients withCoordinates:location at:hereAt responseCallback:responseCallback];
}

+ (void) callSubmitPinOfType:(int)type
            toRecipients:(NSArray *)recipients
             withCoordinates:(CLLocation *)location
                          at:(NSDate *)at
            responseCallback:(MeteorClientMethodCallback)responseCallback {
  
  [[MapizDDPClient getInstance] callMethodName: @"submitPin"
                                    parameters: @[
                                                  [NSNumber numberWithInteger: type],
                                                  recipients, @{
                                                    @"lat_lon" : @{
                                                        @"lat" : [NSNumber numberWithDouble: location.coordinate.latitude],
                                                        @"lon" : [NSNumber numberWithDouble: location.coordinate.longitude]
                                                        },
                                                    @"here_at" : [NSNumber numberWithLongLong: ([at timeIntervalSince1970] * 1000)],
                                                    @"colour" : [NSNumber numberWithInt:[MapizUser getPinColour]]
                                                    }]
                              responseCallback: responseCallback];
  
}

+(NSString*) pinImage:(int)colour {
  switch (colour) {
    case PinColourGreen:
      return @"ic_marker_green.png";
    case PinColourPurple:
      return @"ic_marker_purple.png";
    case PinColourOrange:
      return @"ic_marker_orange.png";
    case PinColourBlack:
      return @"ic_marker_black.png";
    case PinColourRed:
      return @"ic_marker_red.png";
    case PinColourYellow:
      return @"ic_marker_yellow.png";
  }
  return @"ic_marker_blue.png";
}

+(UIColor *) pinColour:(int)colourCode {
  switch (colourCode) {
    case PinColourGreen:
      return [UIColor greenPin];
    case PinColourPurple:
      return [UIColor purplePin];
    case PinColourOrange:
      return [UIColor orangePin];
    case PinColourBlack:
      return [UIColor blackPin];
    case PinColourRed:
      return [UIColor redPin];
    case PinColourYellow:
      return [UIColor yellowPin];
  }
  return [UIColor bluePin];
}


@end
