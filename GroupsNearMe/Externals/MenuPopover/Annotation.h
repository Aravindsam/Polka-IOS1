//
//  Annotation.h
//  Finder
//
//  Created by Sybrant on 20/12/12.
//  Copyright (c) 2012 Sybrant_M1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Annotation : NSObject<MKAnnotation> {
	
	CLLocationCoordinate2D	coordinate;
	NSString*				title;
	NSString*				subtitle;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, copy)		NSString*				title;
@property (nonatomic, copy)		NSString*				subtitle;
- (MKAnnotationView *) annotationView;
- (id) initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location;
@end