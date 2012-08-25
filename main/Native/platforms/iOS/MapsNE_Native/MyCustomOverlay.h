//
//  MyCustomOverlay.h
//  MapsNE_Native
//
//  Created by Meet Shah on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyCustomOverlay : NSObject{
    int32_t  myId;
    MKPolyline * polyline;
}
@property(readonly,nonatomic)int32_t myId;
@property(retain,nonatomic)MKPolyline * polyline;
-(void)polylineWithCoordinates:(CLLocationCoordinate2D *)nativePointsArray count:(NSUInteger)pointsArrayLength andID:(int32_t)myASId;
@end
