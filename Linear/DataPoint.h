//
//  DataPoint.h
//  Linear
//
//  Created by Kehvarl on 1/29/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DataPoint : NSObject <NSCoding> {
	double		x;
	double		y;
}
- (id) init;
- (id) initWithX: (double) xValue y: (double) yvalue;

- (double)		x;
- (void) setX:	(double)	newValue;
- (double)		y;
- (void) setY:	(double)	newValue;

@end
