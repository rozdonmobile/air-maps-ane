//
//  MapNENativeMain.h
//  MapsNE_Native
//
//  Created by Meet Shah on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapNENativeMain : NSObject<MKMapViewDelegate> {
	
	MKMapView *mapView;
	UIView *applicationView;
}


-(void)setViewPort:(CGRect)frame;
-(CGRect)getViewPort;
-(void)showMap;
-(void)hideMap;
-(void)showUserLocation;
-(void)panTo:(CLLocationCoordinate2D)newCenter;
-(void)setZoom:(MKCoordinateRegion)newRegion;
-(double)getZoom;
-(void)setMapCenter:(CLLocationCoordinate2D)newCenter;
-(CLLocationCoordinate2D)getMapCenter;


-(double)zoomFromSpan:(MKCoordinateSpan)mapSpan;

@property(retain, nonatomic) MKMapView *mapView;
@property(retain, nonatomic) UIView *applicationView;

@end
