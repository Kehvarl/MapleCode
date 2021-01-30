//
//  MyDocument.h
//  Linear
//
//  Created by Kehvarl on 1/29/21.
//  Copyright __MyCompanyName__ 2021 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class Regression;
@interface MyDocument : NSDocument
{
	Regression * model;
}

- (IBAction compute: (id) sender;
@end

