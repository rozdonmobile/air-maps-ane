//
//  MapWrapper.m
//  MapsNE_Native
//
//  Created by Meet Shah on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapWrapper.h"
#import "UtilityClass.h"
#import "MyCustomAnnotation.h"
#import "MyCustomOverlay.h"

#import "FlashRuntimeExtensions.h"

extern FREObject getContext2();

@implementation MapWrapper
@synthesize mapView,parentView;

NSMutableArray * annotationsArray=nil;
NSMutableArray * overlaysArray=nil;

-(void)initWithDefaultFrame
{
    //default size
    CGRect frame=CGRectMake(50, 50, 300,300);
    //Create a MKMapView Object
	MKMapView *aView=[[MKMapView alloc] initWithFrame:frame];
    aView.delegate=self;
	mapView=aView;
    
    annotationsArray=[[NSMutableArray alloc] init];
    overlaysArray=[[NSMutableArray alloc] init];
}

-(void)setParentView:(UIView *)pV
{
    parentView=pV;
}

//Sets the viewPort i.e the bounds of the map View
-(void)setViewPort:(CGRect)frame
{
    [mapView setFrame:frame];
}

//Returns the viewPort i.e the bounds of the map View
-(CGRect)getViewPort
{
	return mapView.frame;
}

//Adds the mapView onto the main View root View Controller
-(void)showMap
{
	NSLog(@"*******************In showMapView function********************");
	if([mapView superview]==nil)
	{
		NSLog(@"Adding a Map View");
		[parentView addSubview:mapView];
	}
}

//Removes the mapView from the main View root View Controller
-(void)hideMap
{	
	NSLog(@"*******************In hideMapView function********************");
	if([mapView superview]!=nil)
	{
		NSLog(@"Removing a Map View");
		[mapView removeFromSuperview];
	}
	
}

-(void)showUserLocation:(BOOL)show{
	mapView.showsUserLocation=show;
}

-(void)panTo:(CLLocationCoordinate2D)newCenter{
	[mapView setCenterCoordinate:newCenter animated:YES];
}
-(void)setZoom:(MKCoordinateRegion)newRegion{
	
	MKCoordinateRegion rtf=[mapView regionThatFits:newRegion];
	NSLog(@"Coordinate that fits :%f %f",rtf.span.latitudeDelta,rtf.span.longitudeDelta);
	
	[mapView setRegion:newRegion animated:YES];	
}

-(double)getZoom{
	//return mapView.region.span;
	double z=[UtilityClass zoomFromSpan:[mapView region].span forMap:mapView];
	return z;
}
-(void)setMapCenter:(CLLocationCoordinate2D)newCenter
{
	[mapView setCenterCoordinate:newCenter animated:YES];
}
-(CLLocationCoordinate2D)getMapCenter
{
	return [mapView centerCoordinate];
}

-(void)zoomToRect:(MKMapRect)newRect
{
    mapView.visibleMapRect=newRect;
}

-(void)addOverlayControl:(MyCustomOverlay *)overlay
{
    NSLog(@"Overlay Adding in Wrapper Class");
    [mapView addOverlay:overlay.polyline];
    [overlaysArray addObject:overlay];
}
-(void)removeOverlayControlWithOverlayID:(int32_t)myAsId
{
    NSLog(@"Removing Element from wrapper class");
    MyCustomOverlay *abc=nil;
    for(int i=0;i<[overlaysArray count];i++)
    {
        abc=[overlaysArray objectAtIndex:i];
        if([abc myId]==myAsId)
        {
            [overlaysArray removeObject:abc];
            NSLog(@"Element Removed with Id %d",i);
            [mapView removeOverlay:abc.polyline];
            break;
        }
    }
}

-(void)addMarkerAnnotation:(MyCustomAnnotation *)tAnn
{
    [mapView addAnnotation:tAnn];
    [annotationsArray addObject:tAnn];
}
-(void)removeMarkerAnnotationWithMarkerID:(int32_t)myAsId
{
    MyCustomAnnotation *abc=NULL;
    for(int i=0;i<[annotationsArray count];i++)
    {
        abc=[annotationsArray objectAtIndex:i];
        if([abc myId]==myAsId)
        {
            [annotationsArray removeObject:abc];
            NSLog(@"Element Removed with Id %d",i);
            [mapView removeAnnotation:abc];
            break;
        }
    }
}

//opens the callout of the pin with the given id 
-(void)openMarkerWithMarkerID:(int32_t)param
{
    MyCustomAnnotation *abc=NULL;
    for(int i=0;i<[annotationsArray count];i++)
    {
        abc=[annotationsArray objectAtIndex:i];
        if([abc myId]==param)
        {
            id<MKAnnotation> myAnnotation = [self.mapView.annotations objectAtIndex:i];
            [self.mapView selectAnnotation:myAnnotation animated:YES];
            int32_t myInt = [abc myId];
            NSString *myOutStr = [NSString stringWithFormat:@"%d", myInt];
            FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"PIN_SELECTED", (const uint8_t *)myOutStr.UTF8String);
            break;
        }
        
    }
}
//closes the callout of the pin with the given id 
-(void)closeMarkerWithMarkerID:(int32_t)param
{
    MyCustomAnnotation *abc=NULL;
    for(int i=0;i<[annotationsArray count];i++)
    {
        abc=[annotationsArray objectAtIndex:i];
        if([abc myId]==param)
        {
            id<MKAnnotation> myAnnotation = [self.mapView.annotations objectAtIndex:i];
            [self.mapView deselectAnnotation:myAnnotation animated:YES];
            int32_t myInt = [abc myId];
            NSString *myOutStr = [NSString stringWithFormat:@"%d", myInt];
            FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"PIN_DESELECTED", (const uint8_t *)myOutStr.UTF8String);
            break;
        }
        
    }
}

//MKMapView Delegate Event Handlers:
-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
	NSLog(@"Loading Map");
	FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"WillStartLoadingMap", (const uint8_t*)"");
}
-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
	NSLog(@"Map Loading Finished");
	FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"DidFinishLoadingMap", (const uint8_t*)"");	
}
-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
	NSLog(@"Error Loading Map");
	FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"DidFailLoadingMap", (const uint8_t*)"");
}

//Annotation Event handlers
-(MKAnnotationView *)mapView:(MKMapView *)mapViewLocal viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView* pinView=(MKPinAnnotationView*)[mapViewLocal dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotation"];
    if(!pinView)
    {
        NSLog(@"Didn't Got from deque");
        pinView=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotation"] autorelease];
    }
    else
    {
        NSLog(@"Readily Got from deque");
        pinView.annotation=annotation;
    }
    pinView.pinColor=[((MyCustomAnnotation*)annotation) markerPinColor];
    pinView.canShowCallout=YES;
    NSLog(@"Returning PinView %d",[((MyCustomAnnotation*)annotation) markerPinColor]);
    return pinView;
}

//Overlay Event Handlers
-(MKOverlayView *)mapView:(MKMapView *)mapViewLocal viewForOverlay:(id<MKOverlay>)overlay
{
    NSLog(@"Creating View for Overlay");
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView* aView=[[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
        aView.strokeColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth=4;
        NSLog(@"Returning PolyLineView for Overlay");
        return aView;
    }
    return nil;
}

//select and deselect
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    MyCustomAnnotation *selAnnotation = view.annotation;
    int32_t myInt=[selAnnotation myId];
    NSLog(@"Dispatching PIN Deslected event");
    NSString *myOutStr = [NSString stringWithFormat:@"%d", myInt];
    FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"PIN_DESELECTED", (const uint8_t*)myOutStr.UTF8String);
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Dispatching PIN Selected event");
    MyCustomAnnotation *selAnnotation = view.annotation;
    int32_t myInt = [selAnnotation myId];
    NSString *myOutStr = [NSString stringWithFormat:@"%d", myInt];
    FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"PIN_SELECTED", (const uint8_t *)myOutStr.UTF8String);
}

@end
