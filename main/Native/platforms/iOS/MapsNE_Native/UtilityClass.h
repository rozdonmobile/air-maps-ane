//
//  UtilityClass.h
//  MapsNE_Native
//
//  Created by Meet Shah on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UtilityClass : NSObject



+ (double)longitudeToPixelSpaceX:(double)longitude;
+ (double)latitudeToPixelSpaceY:(double)latitude;
+ (double)pixelSpaceXToLongitude:(double)pixelX;
+ (double)pixelSpaceYToLatitude:(double)pixelY;
+(CGContextRef) createBitmapContext:(int)pixelsWide:(int)pixelsHigh;
+(MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapViewLocal
							 centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                andZoomLevel:(NSUInteger)zoomLevel;
+(double)zoomFromSpan:(MKCoordinateSpan)mapSpan
                            forMap:(MKMapView *)mapView;

@end
