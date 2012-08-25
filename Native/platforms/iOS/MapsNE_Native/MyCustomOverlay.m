//
//  MyCustomOverlay.m
//  MapsNE_Native
//
//  Created by Meet Shah on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCustomOverlay.h"

@implementation MyCustomOverlay
@synthesize myId,polyline;

-(void)initWithId:(int32_t)anyId
{
    
}
-(void) polylineWithCoordinates:(CLLocationCoordinate2D *)nativePointsArray count:(NSUInteger)pointsArrayLength andID:(int32_t)myASId{
    polyline=[MKPolyline polylineWithCoordinates:nativePointsArray count:pointsArrayLength];
    myId=myASId;
    return; 
}
@end
