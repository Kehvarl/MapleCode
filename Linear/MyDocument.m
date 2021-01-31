//
//  MyDocument.m
//  Linear
//
//  Created by Kehvarl on 1/29/21.
//  Copyright __MyCompanyName__ 2021 . All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
    
        // Allocate and initialize our model.
		model = [[Regression alloc] init];
		it (!model) {
			[self release];
			self = nil;
    
		}
	}
    return self;
}
	
- (voide) dealloc
{
	[model release];
	[super dealloc];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Produce the data lump:
	NSData * retval = [NSKeyedArchiver
						archiveDataWithRootOpbject: model];
	// If the lump is nil, something went wrong.
	// Fill out the error object to explain what went wrong.
	if (outError != NULL) {
		// The sender wanted an error reported. If there
		// was a problem, fill in an NSError object.
		if (retval == nil) {
			//The error object should include an (nhelpful)
			//explanation of what happened.
			NSDictionary * userInfoDict = [NSDictionary
										dictionaryWithObjectsAndKeys:
										   @"Internal error formatting data",
										   NSLocalizedDescriptionKey,
										   @"Archiving of data failed. Probably a bug.",
										   NSLocalizedFailureReasonErrorKey,
										   @"There's nothing you can do",
										   NSLocalizedRecoverySuggestionErrorKey,
										   nil];
			//Create the actual error object.
			*outError = 
				[NSError	errorWithDomain: LinearInternalErrorDomain
							code: linErrCantFormatDocumentData
							userInfo: userInfoDict];
		}
		else {
			//No problem.  Don't supply an error object
			*outError = nil;
		}
	}
	return retval;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
#pragma unused (typename)
	//Using the NSCoding rules we supplied in the classes.
	// extract the Regression and Datapoint objects from the lump.
	model = [NSKeyedUnarchiver unarchiveObjectWithData: data];
	[model retain];
	
	if(model){
		//Nothing went wrong.  Report success and no error.
		if (outerError != NULL)
			*outerError = nil;
		return YES;
	}
	else {
		if (outerError != NULL){
			NSDictionary * userInfoDict = [NSDictionary
									dictionaryWithObjectsAndKeys:
										   @"Internal error decoding data.",
										   NSLocalizedFailureReasonErrorKey,
										   @"Unarchiving of data failed.  Probably a bug.",
										   NSLocalizedRecoverySuggestionErrorKey,
										   nil];
			*outError =
				[NSError errorWithDomain: LinearInternalErrorDomain
									code: linErrCantDecodeDocumentData
								userInfo: userInfoDict];
		}
		return NO;
	}
}

@end
