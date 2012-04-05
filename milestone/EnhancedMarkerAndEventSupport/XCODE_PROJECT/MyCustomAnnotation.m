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
@synthesize coordinate,title,subtitle,detailBtn;
-(void)initWithId:(int32_t)anyId
{
    myId=anyId;
    markerPinColor=MKPinAnnotationColorRed;
    NSLog(@"Assigining %d color by default",markerPinColor);
}
-(void)setDetail:(int32_t)param
{
    if(param ==1)
    {    
        detailBtn = true;
    }
    else 
    {
        detailBtn= false;
    }
}
@end
