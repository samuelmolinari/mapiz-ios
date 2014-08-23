//
//  MapizPin.h
//  Mapiz
//
//  Created by samuel on 09/08/2014.
//  Copyright (c) 2014 Mapiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MapizDDPClient.h"
#import "UIColor+CustomColors.h"

@interface MapizPin : NSObject

typedef NS_ENUM(NSInteger, Colour) {
  PinColourBlue   = 0,
  PinColourPurple = 1,
  PinColourOrange = 2,
  PinColourRed    = 3,
  PinColourGreen  = 4,
  PinColourYellow = 5,
  PinColourBlack  = 6
};

typedef NS_ENUM(NSInteger, Type) {
  PinTypeImHere       = 0,
  PinTypeWhereAreYou  = 1,
  PinTypeMeetMeThere  = 2
};

typedef NS_ENUM(NSInteger, Status) {
  PinStatusSending  = 0,
  PinStatusReceived = 1,
  PinStatusOpened   = 2,
  PinStatusReplied  = 3,
  PinStatusComplete = 4,
  PinStatusLocked   = 5
};

@property (nonatomic, retain) NSString *_id;
@property (nonatomic) int _status;
@property (nonatomic) int _type;
@property (nonatomic) int colour;
@property (nonatomic, retain) MapizUser *sender;
@property (nonatomic, retain) MapizUser *recipient;
@property (nonatomic, retain) CLLocation *senderLocation;
@property (nonatomic, retain) CLLocation *recipientLocation;
@property (nonatomic, retain) NSDate *senderHereAt;
@property (nonatomic, retain) NSDate *recipientHereAt;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic) BOOL recipientIsGoing;

- (id) initWithResponse: (NSDictionary*) response;
- (id) initWithNotification: (NSDictionary*) userInfo;

- (BOOL) isRecipient;
- (BOOL) isSender;
- (BOOL) isImHereType;
- (BOOL) isWhereAreYouType;
- (BOOL) isMeetup;
- (BOOL) hasReply;

+ (NSString *)pinImage: (int)colour;
+ (UIColor *)pinColour: (int)colourCode;

+ (void) callWhereAreYou: (NSArray *) recipients responseCallback:(MeteorClientMethodCallback) responseCallback;

+ (void) callImHere: (NSArray *) recipients
        coordinates:(CLLocation *)location
             hereAt:(NSDate *)hereAt
   responseCallback:(MeteorClientMethodCallback) responseCallback;

+ (void) callSubmitPinOfType:(int)type
                toRecipients:(NSArray *)recipients
             withCoordinates:(CLLocation *)location
                          at:(NSDate *)at
            responseCallback:(MeteorClientMethodCallback)responseCallback;

+ (void) callAcceptMeetupInvite: (NSString *) pinId
               responseCallback:(MeteorClientMethodCallback) responseCallback;

+ (void) callTurnDownMeetupInvite: (NSString *) pinId
                 responseCallback:(MeteorClientMethodCallback) responseCallback;

+ (void) callRemove: (NSString *) pinId
                 responseCallback:(MeteorClientMethodCallback) responseCallback;

@end
