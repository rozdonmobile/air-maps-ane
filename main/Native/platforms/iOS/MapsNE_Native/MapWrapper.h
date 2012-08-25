//
//  MapWrapper.h
//  MapsNE_Native
//
//  Created by Meet Shah on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MyCustomAnnotation.h"
#import "MyCustomOverlay.h"

@interface MapWrapper : NSObject<MKMapViewDelegate>

-(void)setParentView:(UIView *)pV;
-(void)setViewPort:(CGRect)frame;
-(CGRect)getViewPort;
-(void)showMap;
-(void)hideMap;
-(void)showUserLocation:(BOOL)show;
-(void)panTo:(CLLocationCoordinate2D)newCenter;
-(void)setZoom:(MKCoordinateRegion)newRegion;
-(double)getZoom;
-(void)setMapCenter:(CLLocationCoordinate2D)newCenter;
-(CLLocationCoordinate2D)getMapCenter;
-(void)zoomToRect:(MKMapRect)newRect;
-(void)initWithDefaultFrame;
-(void)addMarkerAnnotation:(MyCustomAnnotation *)tAnn;
-(void)removeMarkerAnnotationWithMarkerID:(int32_t)myAsId;
-(void)openMarkerWithMarkerID:(int32_t)myID;
-(void)closeMarkerWithMarkerID:(int32_t)myID;
-(void)removeOverlayControlWithOverlayID:(int32_t)myASId;
-(void)addOverlayControl:(MyCustomOverlay *)overlay;

@property(retain, readonly, nonatomic) MKMapView *mapView;
@property(retain, nonatomic) UIView *parentView;

@end
