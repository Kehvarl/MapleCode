//
//  Regression.m
//  Linear
//
//  Created by Kehvarl on 1/29/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import "Regression.h"


@implementation Regression

- (id) init
{
	dataPoints = [NSMutableArray new];
	slope = 0.0;
	intercept = 0.0;
	correlation = 0.0;
	
	return self;
}

- (double) slope { return slope; }
- (void) setSlope: (double) aSlope { slope = aSlope; }

- (double) intercept { return intercept; }
- (void) setIntercept: (double) anIntercept { intercept = anIntercept; }

- (double) correlation { return correlation; }
- (void) setCorrelation: (double) aCorrelation { correlation = aCorrelation; }

- (NSMutableArray *) dataPoints {return dataPoints; }
- (void) setDataPoints: (NSMutableArray *) aDataPoints { dataPoints = aDataPoints; }

- (BOOL) canCompute {
	return [dataPoints count] > 1;
}

- (void) computeWithLinrg {
	
	if (! [self canCompute]) {
		[self setSlope: 0.0];
		[self setIntercept: 0.0];
		[self setCorrelation: 0.0];
		return;
	}
	
	//with the Linrg tool...
	NSBundle *			myBundle = [NSBundle mainBundle]
	NSString *			linrgPath = [myBundle pathForResource: @"Linrg"
												ofType: @""];
	linrgTask = [[NSTask alloc] init];
	[linrgTask setLaunchPath: linrgPath];
	
	//Hook into stdin...
	NSPipe *			inputPipe = [[NSPipe alloc] init];
	NSFileHandle *		inputForData = [inputPipe
										fileHandleForWriting];
	[linrgTask	setStandardInput: inputPipe];
	[inputPipe release];
	
	// ... hook into stdout...
	NSPipe *			outputPipe = [[NSPipe alloc] init];
	NSFileHandle		outputForResults = [outputPipe fileHandleForReading];
	[linrgTask setStandardOutput: outputPipe];
	[outputPipe release];
	
	// .. await output in the dataRead method...
	[[NSNotificationCenter defaultCenter]
		addObserver: self
		selector: @selector(dataRead:)
		name: NSFileHandleReadToEndOfFileCompletionNotification
		object: outputForResults];
	[outputForResults readToEndOfFileInBackgroundAndNotify];
	
	// ... and run Linrg.
	[linrgTask launch];
	
	//For each data point...
	NSEnumerat *		iter = [dataPoints objectEnumerator];
	DataPoint *			curr;
	while (curr = [iter nextObject]){
		NSString *		currAsString;
		//...format point as string...
		currAsString = [NSString stringWithFormat: @"%g %g\n",
						[curr x], [curr y]];
		
		//...reduce string to ASCII data...
		NSData *		currAsData = [currAsString
									  dataUsingEncoding:
									  NSASCIIStringEncoding];
		// ... put data into stdin ...
		[inputForData writeData: currAsData];
		
		// ... then terminate stdin.
		[inputForData closeFile];
	}
}

- (void) dataRead: (NSNotification *) aNotice
{
	// When data arrives on stdout...
	NSDictionary *	info = [aNotice userInfo];
	NSData *		theData = [info objectForKey:
							   NSFileHandleNotificationDataItem];
	//...convert the data to a string...
	NSString *		stringResult = [[NSString alloc]
									initWithData: theData
									encoding: NSASCIIStringEncoding];
	NSScanner *		scanner = [NSScanner
							   scannerWithString: stringResult];
	double			scratch;
	// ... and step thrgouh, collecting the slope...
	[scanner scanDouble: &scratch];
	[self setSlope: scratch];
	
	// ... intercept ...
	[scanner scanDouble: &scratch];
	[self setIntercept: scratch];
	
	// ... and correlation.
	[scanner scanDouble: &scratch];
	[self setCorrelation: scratch];
	[stringResult release];
	
	//Done with Linrg
	[linrgTask release];
	linrgTask = nil;
}

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
