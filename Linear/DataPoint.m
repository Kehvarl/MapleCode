//
//  DataPoint.m
//  Linear
//
//  Created by Kehvarl on 1/29/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import "DataPoint.h"


@implementation DataPoint
// Default initializer. Sets X and Y to 0.0.
- (id) init
{
	return [self initWithX: 0.0 Y: 0.0];
}

- (id) initWithX: (double) xValue Y: (double) yValue
{
	if (self = [super init]) {
		x = xValue;
		y = yValue;
	}
	return self;
}

#pragma mark Key-Value Coding
//Getters and Setters for the x and y attributes
- (double) x {return x; }
- (void) setX (double) newValue { x = newValue; }

- (double) y {return y;}
- (void) setY (double) newValue { y = newValue; }

#pragma mark NSCoding

- (void) encodeWithCoder: (NSCoder *) coder
{
	[coder encodeDouble: x forKey: @"x"];
	[coder encodeDouble: y forKey: @"y"];
}

- (id) initWithCoder: (NSCoder *) coder
{
	[self setX: [coder decodeDoubleForKey: @"x"]];
	[self setY: [coder decodeDoubleForKey: @"y"]];
	return self;
}

@end