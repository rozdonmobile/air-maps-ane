//
//  UtilityClass.m
//  MapsNE_Native
//
//  Created by Meet Shah on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UtilityClass.h"
#import "QuartzCore/CAEAGLLayer.h"

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

@implementation UtilityClass

//Helper methods for mapping the google Maps zoomLevel to iOS MKCordinateSpan
+ (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

+ (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

+ (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

+ (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
	
}
+ (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapViewLocal
							 centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
								 andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapViewLocal.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}


+(double)zoomFromSpan:(MKCoordinateSpan)mapSpan
forMap:(MKMapView *)mapView
{
	CGPoint topLeftPt;topLeftPt.x=0;topLeftPt.y=0;
	CLLocationCoordinate2D topLeftCoordinate=[mapView convertPoint:topLeftPt toCoordinateFromView:mapView];
	
	NSLog(@"%f %f top Left",topLeftCoordinate.latitude,topLeftCoordinate.longitude);
	
	CGPoint bottomRightPt;bottomRightPt.x=mapView.bounds.size.width;bottomRightPt.y=mapView.bounds.size.height;
	CLLocationCoordinate2D bottomRightCoordinate=[mapView convertPoint:bottomRightPt toCoordinateFromView:mapView];
	
	NSLog(@"%f %f bottom right",bottomRightCoordinate.latitude,bottomRightCoordinate.longitude);
	
	double leftPixelX=[self longitudeToPixelSpaceX:topLeftCoordinate.longitude];
	double rightPixelX=[self longitudeToPixelSpaceX:bottomRightCoordinate.longitude];
	double scaledMapWidth=rightPixelX-leftPixelX;
	
	double topPixelY=[self latitudeToPixelSpaceY:topLeftCoordinate.latitude];
	double bottomPixelY=[self latitudeToPixelSpaceY:bottomRightCoordinate.latitude];
	double scaledMapHeight=topPixelY-bottomPixelY;
	
	double zoomScale=scaledMapWidth / mapView.bounds.size.width;
	double zoomScaleVerify=-1 * (scaledMapHeight / mapView.bounds.size.height);
	NSLog(@"%f %f zoom and verify",zoomScale, zoomScaleVerify);
	
	double zoomExponent=logf(zoomScale)/logf(2.0f);
	double zoomLevel=20-zoomExponent;
	NSLog(@"%f %f Exponent and Level",zoomExponent,zoomLevel);
	
	return zoomLevel;
}

/************* Code for creating bitmap graphics context****************************/
+(CGContextRef) createBitmapContext: (int) pixelsWide :(int) pixelsHigh
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    bitmapBytesPerRow   = (pixelsWide * 4);// 1
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc( bitmapByteCount);// 3
    memset(bitmapData, 0, sizeof(bitmapData));
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,// 4
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        free (bitmapData);// 5
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease( colorSpace );// 6
    
    return context;// 7
}

@end
