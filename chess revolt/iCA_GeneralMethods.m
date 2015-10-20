//
//  iCA_GeneralMethods.m
//  MAS AlertCentral
//
//  Created by Fog City Solutions on 10/10/13.
//  Copyright (c) 2013 Mobile Alert Software. All rights reserved.
//

#import "iCA_GeneralMethods.h"

@implementation iCA_GeneralMethods

// Is a string nil or empty (no characters?) 
+(BOOL)stringIsEmpty:(NSString *)string
{
	if (NOT string OR [string equals:@""] OR [string length] == 0)
		return YES;
	else
		return NO;
}



// *********************************************************************
// Method:	Gets a random number within a range
// Call:	int newNumber = [aClass intInRangeMinimum:1 andMaximum:100];
//**********************************************************************
+ (int) randomIntegerInRangeMinimum:(int)min andMaximum:(int)max
{
    if (min > max) { return -1; }
    int adjustedMax = (max + 1) - min; // arc4random returns within the set {min, (max - 1)}
    int random = arc4random() % adjustedMax;
    int result = random + min;
    return result;
}




@end

