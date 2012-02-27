//
//  UIDevice+HDAdditions.m
//  MOAdditions
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIDevice+MOAdditions.h"


@implementation UIDevice (MOAdditions)

#pragma mark - Class Methods

+ (NSSet*)platformSuffixes
{
	static NSSet* kPlatformSuffixes = nil;
	
	if (kPlatformSuffixes == nil)
	{
		kPlatformSuffixes = [NSSet setWithObjects:@"~iphone", @"~ipad", nil];
	}
	
	return kPlatformSuffixes;
}

#pragma mark - Properties

- (NSString*)platformSuffix
{
	return ([self userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? @"~ipad" : @"~iphone";
}

@end
