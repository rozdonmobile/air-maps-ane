//
//  MapNENativeMain.h
//  MapsNE_Native
//
//  Created by Meet Shah on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapWrapper.h"

@interface MapNENativeMain : NSObject {
	MapWrapper *mapWrap;
	UIView *applicationView;
}
@property(retain, readwrite, nonatomic) UIView *applicationView;
@property(retain, nonatomic) MapWrapper *mapWrap;
@end
