//
//  PinAnnotation.h
//  MapsNE_Native
//
//  Created by user1 on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PinAnnotation : MKAnnotationView {
    UIView *calloutView;
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    UIImage *normalPin;
    UIImage *selectedPin;
    CGMutablePathRef retPath;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subtitleLabel;

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;
-(CGPathRef)roundedRectPath:(CGRect)rect radius:(CGFloat)radius;

@end
