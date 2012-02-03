//
//  MyCustomAnnotation.h
//  MapExplore
//
//  Created by Meet Shah on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyCustomAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    int32_t  myId;
    MKPinAnnotationColor markerPinColor;
}
@property(readonly,nonatomic) int32_t myId;
@property(readwrite,nonatomic) MKPinAnnotationColor markerPinColor;
@property(readwrite,nonatomic) CLLocationCoordinate2D coordinate;
@property(retain,nonatomic) NSString * title;
@property(retain,nonatomic) NSString * subtitle;
-(void)initWithId:(int32_t)anyId;
@end
