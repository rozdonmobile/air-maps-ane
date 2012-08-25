//
//  MyCustomAnnotation.m
//  MapExplore
//
//  Created by Meet Shah on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyCustomAnnotation.h"


@implementation MyCustomAnnotation
@synthesize myId,markerPinColor;
@synthesize coordinate;

-(void)initWithId:(int32_t)anyId andTitle:(NSString *)anyTitle andSubtitle:(NSString *)anySubtitle
{
    myId=anyId;
    markerPinColor=MKPinAnnotationColorRed;
    _title=[anyTitle retain];
    _subtitle=[anySubtitle retain];
    NSLog(@"Assigining %d color by default",markerPinColor);
}

-(NSString *)title
{
    return _title;
}

-(NSString *)subtitle
{
    return _subtitle;
}
@end
