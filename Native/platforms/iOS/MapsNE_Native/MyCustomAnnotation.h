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
    NSString * _title;
    NSString * _subtitle;
    int32_t  myId;
    MKPinAnnotationColor markerPinColor;
}
@property(readonly,nonatomic) int32_t myId;
@property(readwrite,nonatomic) MKPinAnnotationColor markerPinColor;
@property(readwrite,nonatomic) CLLocationCoordinate2D coordinate;
-(void)initWithId:(int32_t)anyId andTitle:(NSString *)anyTitle andSubtitle:(NSString *)anySubtitle;
-(NSString *)title;
-(NSString *)subtitle;
@end
