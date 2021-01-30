//
//  Regression.h
//  Linear
//
//  Created by Kehvarl on 1/29/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Regression : NSObject <NSCoding> {
	NSMutableArray *	dataPoints;
	double				slope;
	double				intercept;
	double				correlation;
	
	NSTask				linrgTask;
}

- (id) init;

- (double) slope;
- (void) setSlope: (double) aSlope);

- (double) intercept;
- (void) setIntercept: (double) anIntercept;

- (double) correlation;
- (void) setCorrelation: (double) aCorrelation;

- (NSMutableArray *) dataPoints;
- (void) setDataPoints: (NSMutableArray *) aDataPoints;

- (BOOL) canCompute;
- (void) computeWithLinrg;
@end
