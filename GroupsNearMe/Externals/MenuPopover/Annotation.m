//
//  Annotation.m
//  Finder
//
//  Created by Sybrant on 20/12/12.
//  Copyright (c) 2012 Sybrant_M1. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

//---------------------------------------------------------------

#pragma mark
#pragma mark init methods

//---------------------------------------------------------------

- (id) initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location {
    self = [super init];
    if (self) {
        title = newTitle;
        self.coordinate = location;
    }
    return self;
}

//---------------------------------------------------------------
- (MKAnnotationView *) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"CustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"mapannotation.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [annotationView setCenterOffset:CGPointMake(0, -32)];
    return annotationView;
}
@end
