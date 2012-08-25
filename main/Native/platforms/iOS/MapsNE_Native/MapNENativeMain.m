//
//  MapNENativeMain.m
//  MapsNE_Native
//
//  Created by Meet Shah on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapNENativeMain.h"
#import "FlashRuntimeExtensions.h"
#import <MapKit/MapKit.h>
#import "QuartzCore/CAEAGLLayer.h"

#import "MyCustomAnnotation.h"
#import "MyCustomOverlay.h"
#import "UtilityClass.h"

// Objective-C code
#import <UIKit/UIKit.h>

@implementation MapNENativeMain
@synthesize applicationView,mapWrap;
@end


MapNENativeMain* refToSelf;
FREContext ctxRef=nil;
float scaleFactor=1.0;

FREContext getContext2(){
    return ctxRef;
}

// Creates a Map View Object
FREObject createMapViewHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In createMapViewHandler function********************");
    
    [refToSelf setMapWrap:[[MapWrapper alloc] init]];
    [[refToSelf mapWrap] initWithDefaultFrame];
    [[refToSelf mapWrap] setParentView:[refToSelf applicationView]];
    //[refToSelf mapView].showsUserLocation=true;
    
	return NULL;
}

// Show a Map View Object
FREObject showMapViewHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In showMapViewHandler function********************");
	
	[[refToSelf mapWrap] showMap];
	return NULL;
}

// Remove a Map View Object
FREObject hideMapViewHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In hideMapViewHandler function********************");
	
	[[refToSelf mapWrap] hideMap];
	return NULL;
}

// Returns the bounds of Map View in pixel coordinates
FREObject getViewPortHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In getViewPortHandler function********************");
	CGRect frame=[[refToSelf mapWrap] getViewPort];
	
	NSLog(@"*******************Constructing Rectangle FRE Object from native CGRect*****************");
	FREObject* argV=(FREObject*)malloc(sizeof(FREObject)*4);
	FREObject returnObject;
	FRENewObjectFromDouble(frame.origin.x*scaleFactor, &argV[0]);
	FRENewObjectFromDouble(frame.origin.y*scaleFactor, &argV[1]);
	FRENewObjectFromDouble(frame.size.width*scaleFactor, &argV[2]);
	FRENewObjectFromDouble(frame.size.height*scaleFactor, &argV[3]);
	
	int i= FRENewObject((const uint8_t*)"flash.geom.Rectangle",4,argV,&returnObject,NULL);
	if (i!=FRE_OK) {
		NSLog(@"Call to FRENewObject reply value is %d",i);
	}
	return returnObject;
}

// Changes the bounds of Map View to new pixel coordinates
FREObject setViewPortHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In setViewPortHandler function********************");
	
	NSLog(@"*******************Constructing native CGRect from Rectangle FRE Object*****************");
	FREObject x;
	FREObject y;
	FREObject width;
	FREObject height;
	
	FREGetObjectProperty(argv[0], (const uint8_t*)"x", &x, NULL);
	FREGetObjectProperty(argv[0], (const uint8_t*)"y", &y, NULL);
	FREGetObjectProperty(argv[0], (const uint8_t*)"width", &width, NULL);
	FREGetObjectProperty(argv[0], (const uint8_t*)"height", &height, NULL);
	
	CGRect frame;
	double d1,d2,d3,d4;
	
	FREGetObjectAsDouble(x, &d1);frame.origin.x=d1/scaleFactor;
	FREGetObjectAsDouble(y, &d2);frame.origin.y=d2/scaleFactor;	
	FREGetObjectAsDouble(width, &d3);frame.size.width=d3/scaleFactor;
	FREGetObjectAsDouble(height, &d4);frame.size.height=d4/scaleFactor;
	[[refToSelf mapWrap] setViewPort:frame];
	return NULL;
}

FREObject getCenterHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In getCenterHandler function********************");
	CLLocationCoordinate2D mapCenter=[[refToSelf mapWrap] getMapCenter];
	
	
	NSLog(@"*******************Constructing Custom LatLng FRE Object from native CGRect*****************");
	FREObject* argV=(FREObject*)malloc(sizeof(FREObject)*2);
	FREObject returnObject;
	FRENewObjectFromDouble(mapCenter.latitude, &argV[0]);
	FRENewObjectFromDouble(mapCenter.longitude, &argV[1]);
	
	int i= FRENewObject((const uint8_t*)"com.adobe.nativeExtensions.maps.LatLng",2,argV,&returnObject,NULL);
	if (i!=FRE_OK) {
		NSLog(@"Call to FRENewObject reply value is %d",i);
	}
	return returnObject;
	

}

FREObject setCenterHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In setCenterHandler function********************");
	
	NSLog(@"*******************Constructing native CLLocationCoordinate2D from Custom LatLng FRE Object*****************");
	FREObject lat;
	FREObject lng;

	if(FRECallObjectMethod(argv[0], (const uint8_t*)"lat",0,nil, &lat, NULL) != FRE_OK) NSLog(@"Error ");
	FRECallObjectMethod(argv[0], (const uint8_t*)"lng",0,nil, &lng, NULL);
	
	CLLocationCoordinate2D newCenter;
	double nlat,nlng;
	
	FREGetObjectAsDouble(lat, &nlat);newCenter.latitude=nlat;
	FREGetObjectAsDouble(lng, &nlng);newCenter.longitude=nlng;
	
	[[refToSelf mapWrap] setMapCenter:newCenter];
	
	return NULL;
	
}

FREObject panToHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In panToHandler function********************");
	
	NSLog(@"*******************Constructing native CLLocationCoordinate2D from Custom LatLng FRE Object*****************");
	FREObject lat;
	FREObject lng;
	
	if(FRECallObjectMethod(argv[0], (const uint8_t*)"lat",0,nil, &lat, NULL) != FRE_OK) NSLog(@"Error ");
	FRECallObjectMethod(argv[0], (const uint8_t*)"lng",0,nil, &lng, NULL);
	
	CLLocationCoordinate2D newCenter;
	double nlat,nlng;
	
	FREGetObjectAsDouble(lat, &nlat);newCenter.latitude=nlat;
	FREGetObjectAsDouble(lng, &nlng);newCenter.longitude=nlng;
	
	[[refToSelf mapWrap] panTo:newCenter];
	return NULL;
	
}


FREObject getZoomHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In getZoomHandler function********************");
	
	NSLog(@"*******************Constructing FRE Object from native Double*****************");
	FREObject returnObject;
	
	//Both latitude and longitude are same for this NE so return any of them
	FRENewObjectFromDouble([[refToSelf mapWrap] getZoom], &returnObject);
	return returnObject;
	
}



FREObject setZoomHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In setZoomHandler function********************");
	
	NSLog(@"*******************Constructing native Double from FRE Number*****************");
	double newZoomNative;
	
	FREGetObjectAsDouble(argv[0], &newZoomNative);
	
	newZoomNative = MIN(newZoomNative, 28);
    
    MKMapView *tempMapView=[[refToSelf mapWrap] mapView];
    // use the zoom level to compute the region
    MKCoordinateSpan span = [UtilityClass coordinateSpanWithMapView:tempMapView centerCoordinate:[tempMapView centerCoordinate] andZoomLevel:newZoomNative];
    MKCoordinateRegion newRegion = MKCoordinateRegionMake(tempMapView.region.center, span);
	
	NSLog(@"Setting new Zoom to %f",newZoomNative);
	
	[[refToSelf mapWrap] setZoom:newRegion];

	return NULL;
}


FREObject addAnnotationHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In addOverlayHandler function********************");
    
    NSLog(@"*******************Coverting Marker object to native Annotation Object*********************");
    
    FREObject latLng,title,subtitle,my_Id,fillColor;
    int32_t myAsId,intColor;
    MKPinAnnotationColor pinColor;
    FREGetObjectProperty(argv[0], (const uint8_t*)"latLng", &latLng, NULL);
    FREGetObjectProperty(argv[0], (const uint8_t*)"title", &title, NULL);
    FREGetObjectProperty(argv[0], (const uint8_t*)"subtitle", &subtitle, NULL);
    FREGetObjectProperty(argv[0], (const uint8_t*)"myId", &my_Id, NULL);
    FREGetObjectProperty(argv[0], (const uint8_t*)"fillColor", &fillColor, NULL);
    FREGetObjectAsInt32(fillColor,&intColor);
    pinColor=(MKPinAnnotationColor)intColor;
    FREGetObjectAsInt32(my_Id,&myAsId);
    
    NSLog(@"%d is the value",myAsId);
    
    
    FREObject lat;
	FREObject lng;
    if(FRECallObjectMethod(latLng, (const uint8_t*)"lat",0,nil, &lat, NULL) != FRE_OK) NSLog(@"Error ");
	FRECallObjectMethod(latLng, (const uint8_t*)"lng",0,nil, &lng, NULL);
    
    MyCustomAnnotation *annotation1= [MyCustomAnnotation alloc];

    CLLocationCoordinate2D annLocation1;
    FREGetObjectAsDouble(lat, &(annLocation1.latitude));
	FREGetObjectAsDouble(lng, &(annLocation1.longitude));
    const uint8_t* titleN;
    const uint8_t* subtitleN;
    uint32_t titleLength,subtitleLength;
    FREGetObjectAsUTF8(title, &titleLength, &titleN);
    FREGetObjectAsUTF8(subtitle, &subtitleLength, &subtitleN);
    
    [annotation1 initWithId:myAsId andTitle:[NSString stringWithFormat:@"%s",titleN] andSubtitle:[NSString stringWithFormat:@"%s",subtitleN]];
    [annotation1 setCoordinate:annLocation1];

    NSLog(@"Creating Marker with color %d",pinColor);
    if(pinColor==0)
        [annotation1 setMarkerPinColor:MKPinAnnotationColorRed];
    else if(pinColor==1)
        [annotation1 setMarkerPinColor:MKPinAnnotationColorGreen];
    else if(pinColor==2)
        [annotation1 setMarkerPinColor:MKPinAnnotationColorPurple];
    else
        pinColor=MKPinAnnotationColorRed;
	[[refToSelf mapWrap] addMarkerAnnotation:annotation1];
	
	return NULL;
}

FREObject removeAnnotationHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In removeOverlayHandler function********************");
    FREObject my_Id;
    int32_t myAsId;
    
    FREGetObjectProperty(argv[0], (const uint8_t*)"myId", &my_Id, NULL);
    FREGetObjectAsInt32(my_Id,&myAsId);
	[[refToSelf mapWrap] removeMarkerAnnotationWithMarkerID:myAsId];
    
	return NULL;
}

FREObject addPolylineHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In addPolylineHandler function********************");
    
    NSLog(@"*******************Coverting Polyline AS object to native MKPolyline Object*********************");
    
    FREObject pointsArray,my_Id;
//    FREObject fillColor;
    int32_t myAsId;
//    int32_t intColor;
    //MKPinAnnotationColor pinColor;
    FREGetObjectProperty(argv[0], (const uint8_t*)"myId", &my_Id, NULL);
    FREGetObjectProperty(argv[0], (const uint8_t*)"points", &pointsArray, NULL);
//    FREGetObjectProperty(argv[0], (const uint8_t*)"fillColor", &fillColor, NULL);
//    FREGetObjectAsInt32(fillColor,&intColor);
//    pinColor=(MKPinAnnotationColor)intColor;
    FREGetObjectAsInt32(my_Id,&myAsId);
    
    uint32_t pointsArrayLength=0;
    FREGetArrayLength(pointsArray, &pointsArrayLength);
    
    CLLocationCoordinate2D * nativePointsArray=malloc(sizeof(CLLocationCoordinate2D)*pointsArrayLength);
    
    NSLog(@"%d is the value",pointsArrayLength);
    FREObject tempPoint;
    for (uint32_t i=0; i<pointsArrayLength; i++) {
        FREGetArrayElementAt(pointsArray, i, &tempPoint);
        FREObject lat;
        FREObject lng;
        if(FRECallObjectMethod(tempPoint, (const uint8_t*)"lat",0,nil, &lat, NULL) != FRE_OK) NSLog(@"Error ");
        if(FRECallObjectMethod(tempPoint, (const uint8_t*)"lng",0,nil, &lng, NULL) != FRE_OK) NSLog(@"Error ");
        FREGetObjectAsDouble(lat, &(nativePointsArray[i].latitude));
        FREGetObjectAsDouble(lng, &(nativePointsArray[i].longitude));
        NSLog(@"Coordinate %d is %f %f",i,nativePointsArray[i].latitude,nativePointsArray[i].longitude);
    }
    
    MyCustomOverlay * myOverlay=[MyCustomOverlay alloc];
    [myOverlay polylineWithCoordinates:nativePointsArray count:pointsArrayLength andID:myAsId];
    [[refToSelf mapWrap] addOverlayControl:myOverlay];

//    NSLog(@"Creating Marker with color %d",pinColor);
//    if(pinColor==0)
//        [annotation1 setMarkerPinColor:MKPinAnnotationColorRed];
//    else if(pinColor==1)
//        [annotation1 setMarkerPinColor:MKPinAnnotationColorGreen];
//    else if(pinColor==2)
//        [annotation1 setMarkerPinColor:MKPinAnnotationColorPurple];
//    else
//        pinColor=MKPinAnnotationColorRed;
//	[[refToSelf mapWrap] addMarkerAnnotation:annotation1];
	
	return NULL;
}

FREObject removePolylineHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In removeOverlayHandler function********************");
    FREObject my_Id;
    int32_t myAsId;
    
    FREGetObjectProperty(argv[0], (const uint8_t*)"myId", &my_Id, NULL);
    FREGetObjectAsInt32(my_Id,&myAsId);
	[[refToSelf mapWrap] removeOverlayControlWithOverlayID:myAsId];
    
	return NULL;
}

FREObject setMapTypeHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In setMapTypeHandler function********************");
    int32_t mapType;

    FREGetObjectAsInt32(argv[0],&mapType);
    if(mapType==0)
        [[[refToSelf mapWrap] mapView] setMapType:MKMapTypeStandard];
    else if(mapType==1)
        [[[refToSelf mapWrap] mapView] setMapType:MKMapTypeSatellite];
    else if(mapType==2)
        [[[refToSelf mapWrap] mapView] setMapType:MKMapTypeHybrid];
	return NULL;
}

FREObject drawViewPortToBitmapDataHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
	NSLog(@"*******************In drawViewPortToBitmapDataHandler function********************");
    
    /*capture screenshot of mapview*/
    UIGraphicsBeginImageContextWithOptions([[refToSelf mapWrap] mapView].bounds.size, YES, scaleFactor);
    [[[refToSelf mapWrap] mapView].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"mapview captured onto image");
    
    /*Create a BitmapContext for holding the image data*/
    CGImageRef cgImageRef=[image CGImage];
    CGContextRef myBitmapContext = [UtilityClass createBitmapContext:CGImageGetWidth(cgImageRef):CGImageGetHeight(cgImageRef)];
    if(myBitmapContext==nil)
    {
        NSLog(@"Error no memory in context");
        return NULL;
    }
    NSLog(@"Bitmap Context created successfully");
    
    /*capturing cgimage to bitmapcontext created above*/
    size_t bdWidth=CGImageGetWidth(cgImageRef);
    size_t bdHeight=CGImageGetHeight(cgImageRef);
    CGRect rect={{0,0},{bdWidth,bdHeight}};
    CGContextDrawImage(myBitmapContext, rect, cgImageRef);
    //Another method : [[refToSelf mapView].layer renderInContext:myBitmapContext];
    NSLog(@"CGImage captured to bitmapContext");
    
    /*taking the actual bitmap data from bitmapContext*/
    CGBitmapInfo info = CGImageGetBitmapInfo(cgImageRef);
    size_t bpp=CGImageGetBitsPerPixel(cgImageRef);
    size_t bpr=CGImageGetBytesPerRow(cgImageRef);
    size_t bpc=CGImageGetBitsPerComponent(cgImageRef);
    NSLog(
          @"\n"
          "===== INFORMATION =====\n"
          "CGImageGetHeight: %d\n"
          "CGImageGetWidth:  %d\n"
          "CGImageGetColorSpace: %@\n"
          "CGImageGetBitsPerPixel:     %d\n"
          "CGImageGetBitsPerComponent: %d\n"
          "CGImageGetBytesPerRow:      %d\n"
          "CGImageGetBitmapInfo: 0x%.8X\n"
          "  kCGBitmapAlphaInfoMask     = %s\n"
          "  kCGBitmapFloatComponents   = %s\n"
          "  kCGBitmapByteOrderMask     = %s\n"
          "  kCGBitmapByteOrderDefault  = %s\n"
          "  kCGBitmapByteOrder16Little = %s\n"
          "  kCGBitmapByteOrder32Little = %s\n"
          "  kCGBitmapByteOrder16Big    = %s\n"
          "  kCGBitmapByteOrder32Big    = %s\n",
          (int)bdWidth,
          (int)bdHeight,
          CGImageGetColorSpace(cgImageRef),
          (int)bpp,
          (int)bpc,
          (int)bpr,
          (unsigned)info,
          (info & kCGBitmapAlphaInfoMask)     ? "YES" : "NO",
          (info & kCGBitmapFloatComponents)   ? "YES" : "NO",
          (info & kCGBitmapByteOrderMask)     ? "YES" : "NO",
          (info & kCGBitmapByteOrderDefault)  ? "YES" : "NO",
          (info & kCGBitmapByteOrder16Little) ? "YES" : "NO",
          (info & kCGBitmapByteOrder32Little) ? "YES" : "NO",
          (info & kCGBitmapByteOrder16Big)    ? "YES" : "NO",
          (info & kCGBitmapByteOrder32Big)    ? "YES" : "NO"
          );
    uint32_t *data=CGBitmapContextGetData(myBitmapContext);
    
    if(data)
    {
        FREBitmapData bitmapData;
        FREAcquireBitmapData(argv[0], &bitmapData);
        
        for(int i=0;i<bdHeight;i++)
        {
            for(int j=0;j<bdWidth;j++)
            {
                //NSLog(@"%x %x %x %x ",data[i*bpr+j*4],data[i*bpr+j*4+1],data[i*bpr+j*4+2],data[i*bpr+j*4+3]);
//                if(j==10)
//                    NSLog(@"%x D",data[i*bdWidth+j]);
                uint32_t a=data[i*bdWidth+j];
                uint32_t r=a&0x00ff0000;r=r>>16;
                uint32_t b=a&0x000000ff;b=b<<16;
                a=a&0xff00ff00;
                a=a|r;
                a=a|b;
                *(bitmapData.bits32+i*bdWidth+j)=a;
//                if(j==10)
//                    NSLog(@"%x",a);
            }   
        }
        
        //memcpy(bitmapData.bits32, data, 2000);
        FREInvalidateBitmapDataRect(argv[0], 0, 0, bdWidth, bdHeight);
        FREReleaseBitmapData(argv[0]);
        NSLog(@"bitmap data from bitmapcontext obtained. Returning .....");
    }
    else
    {
        NSLog(@"bitmap data from bitmapcontext is null");
    }
    
    /*assuming that the bitmap will be created after capturing the bitmapData*/
    //FREInvalidateBitmapDataRect(bitmapData, 0, 0, bdWidth, bdHeight);
    
	return NULL;
}

//set user location to visible or not visibile
FREObject showUserLocationHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    NSLog(@"*******************In showUserLocationHandler function********************");
    int32_t showMe;
    
    FREGetObjectAsInt32(argv[0],&showMe);
    if(showMe==1)
        [[refToSelf mapWrap] showUserLocation:YES];
    else if(showMe==0)
        [[refToSelf mapWrap] showUserLocation:NO];
    return NULL;
}

// sets the zoom and location of the map to fit in a specified rectangle
FREObject zoomToRectHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    NSLog(@"*******************In zoomToRectHandler function********************");
    
    FREObject x;
    FREObject y;
    FREObject width;
    FREObject height;
    
    FREGetObjectProperty(argv[0], (const uint8_t*)"x", &x, NULL);
    FREGetObjectProperty(argv[0], (const uint8_t*)"y", &y, NULL);
    FREGetObjectProperty(argv[0], (const uint8_t*)"width", &width, NULL);
    FREGetObjectProperty(argv[0], (const uint8_t*)"height", &height, NULL);
    
    CLLocationCoordinate2D coord;
    CLLocationCoordinate2D coord2;
    
    double d1,d2,d3,d4;
    
    FREGetObjectAsDouble(x, &d1);coord.latitude = d1;
    FREGetObjectAsDouble(y, &d2);coord.longitude = d2;
    FREGetObjectAsDouble(width, &d3);coord2.latitude = d3;
    FREGetObjectAsDouble(height, &d4);coord2.longitude = d4;
    
    MKMapPoint mp1 = MKMapPointForCoordinate(coord);
    MKMapPoint mp2 = MKMapPointForCoordinate(coord2);
    
    MKMapRect mr = MKMapRectMake (fmin(mp1.x, mp2.x),
                                  fmin(mp1.y, mp2.y),
                                  fabs(mp1.x - mp2.x),
                                  fabs(mp1.y - mp2.y));
    [[refToSelf mapWrap] zoomToRect:mr];
    return NULL;
}


//opens the callout of the pin with the given id
FREObject closeMarkerHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    NSLog(@"*******************In closeMarkerHandler function********************");
    int32_t ID;
    
    FREGetObjectAsInt32(argv[0],&ID);
    [[refToSelf mapWrap] closeMarkerWithMarkerID:ID];
    return NULL;
}

//opens the callout of the pin with the given id
FREObject openMarkerHandler(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    NSLog(@"*******************In openMarkerHandler function********************");
    int32_t ID;
    
    FREGetObjectAsInt32(argv[0],&ID);
    [[refToSelf mapWrap] openMarkerWithMarkerID:ID];
    return NULL;
}

// A native context instance is created
void MapsExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
	NSLog(@"*******************In context Initializer********************");
	*numFunctionsToTest = 20;
	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction)*20);
	
	func[0].name = (const uint8_t*)"createMapView";
	func[0].functionData = NULL;
	func[0].function = &createMapViewHandler;
	
	func[1].name = (const uint8_t*)"showMapView";
	func[1].functionData = NULL;
	func[1].function = &showMapViewHandler;
	
	func[2].name = (const uint8_t*)"hideMapView";
	func[2].functionData = NULL;
	func[2].function = &hideMapViewHandler;
	
	func[3].name = (const uint8_t*)"getViewPort";
	func[3].functionData = NULL;
	func[3].function = &getViewPortHandler;
	
	func[4].name = (const uint8_t*)"setViewPort";
	func[4].functionData = NULL;
	func[4].function = &setViewPortHandler;
	
	func[5].name = (const uint8_t*)"getCenter";
	func[5].functionData = NULL;
	func[5].function = &getCenterHandler;
	
	func[6].name = (const uint8_t*)"setCenter";
	func[6].functionData = NULL;
	func[6].function = &setCenterHandler;
	
	func[7].name = (const uint8_t*)"panTo";
	func[7].functionData = NULL;
	func[7].function = &panToHandler;
	
	func[8].name = (const uint8_t*)"getZoom";
	func[8].functionData = NULL;
	func[8].function = &getZoomHandler;
	
	func[9].name = (const uint8_t*)"setZoom";
	func[9].functionData = NULL;
	func[9].function = &setZoomHandler;
    
    func[10].name=(const uint8_t*)"addOverlay";
    func[10].functionData=NULL;
    func[10].function=&addAnnotationHandler;
	
    func[11].name=(const uint8_t*)"removeOverlay";
    func[11].functionData=NULL;
    func[11].function=&removeAnnotationHandler;
    
    func[12].name=(const uint8_t*)"setMapType";
    func[12].functionData=NULL;
    func[12].function=&setMapTypeHandler;
    
    func[13].name=(const uint8_t*)"drawViewPortToBitmapData";
    func[13].functionData=NULL;
    func[13].function=&drawViewPortToBitmapDataHandler;
    
    func[14].name=(const uint8_t*)"showUserLocation";
    func[14].functionData=NULL;
    func[14].function=&showUserLocationHandler;
    
    func[15].name=(const uint8_t*)"zoomToRect";
    func[15].functionData=NULL;
    func[15].function=&zoomToRectHandler;
    
    func[16].name=(const uint8_t*)"openMarker";
    func[16].functionData=NULL;
    func[16].function=&openMarkerHandler;
    
    func[17].name=(const uint8_t*)"closeMarker";
    func[17].functionData=NULL;
    func[17].function=&closeMarkerHandler;
    
    func[18].name=(const uint8_t*)"addPolyline";
    func[18].functionData=NULL;
    func[18].function=&addPolylineHandler;
	
    func[19].name=(const uint8_t*)"removePolyline";
    func[19].functionData=NULL;
    func[19].function=&removePolylineHandler;
    
	*functionsToSet = func;
	
	//Initialize the Class which contains the feature implemetation and set refToSelf
	MapNENativeMain * t = [[MapNENativeMain alloc] init];
    refToSelf = t;
    
	//Set the Main application view into applicationView property of this class for further use in program
	[refToSelf setApplicationView:[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController].view];
	
	ctxRef = ctx;
    NSLog(@"%s ************",ctxType);
	
	//CAEAGLLayer *layer=(CAEAGLLayer *)([[refToSelf applicationView] layer]);
	//NSLog([NSString stringWithFormat: @"*******************Retina Now******************** %f",layer.contentsScale]);
	
	scaleFactor=[[refToSelf applicationView] contentScaleFactor];
	if([[refToSelf applicationView] contentScaleFactor] > 1.0 )
	{
		NSLog(@"*******************Retina******************** %f",[[refToSelf applicationView] contentScaleFactor]);
	}
	else {
		NSLog(@"*******************Non Retina******************** %f",[[refToSelf applicationView] contentScaleFactor]);
	}

		
}

CGPoint doubleMe(CGPoint oldPt){
	CGPoint newPt;
	newPt.x=oldPt.x*2.0;
	newPt.y=oldPt.y*2.0;
	return newPt;
}

CGPoint halfMe(CGPoint oldPt){
	CGPoint newPt;
	newPt.x=oldPt.x/2.0;
	newPt.y=oldPt.y/2.0;
	return newPt;
}

// A native context instance is disposed
void MapsExtensionContextFinalizer(FREContext ctx) {
	NSLog(@"*******************In context finalizer********************");
	[[refToSelf mapWrap] mapView].delegate=nil;
	[[[refToSelf mapWrap] mapView] release];
    [[refToSelf mapWrap] release];
	[refToSelf release];
	return;
}

// Initialization function of each extension
void MapsExtensionExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
					FREContextFinalizer* ctxFinalizerToSet) {
	NSLog(@"*******************In extension initializer********************");
	*extDataToSet = NULL;
	*ctxInitializerToSet = &MapsExtensionContextInitializer;
	*ctxFinalizerToSet = &MapsExtensionContextFinalizer;
}

// Called when extension is unloaded
void MapsExtensionExtFinalizer(void* extData) {
	NSLog(@"*******************In extension finalizer********************");
	return;
}
