//
//  iCA_GeneralMethods.h
//  MAS AlertCentral
//
//  Created by Fog City Solutions on 10/10/13.
//  Copyright (c) 2013 Mobile Alert Software. All rights reserved.
//

// These are methods that will be useful for use in all apps.  Things like "digits only from a string", or "ISEMPTY"

#import <Foundation/Foundation.h>


@interface iCA_GeneralMethods : NSObject
+(BOOL)stringIsEmpty:(NSString *)string;
+ (int) randomIntegerInRangeMinimum:(int)min andMaximum:(int)max;


@end
