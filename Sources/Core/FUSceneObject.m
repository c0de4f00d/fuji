//
//  FUSceneObject.m
//  Fuji
//
//  Created by David Hart on 3/27/12.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#import "FUSceneObject.h"


@implementation FUSceneObject

#pragma mark - Class Methods

+ (SEL)visitSelector
{
	NSString* selectorString = [NSString stringWithFormat:@"visit%@:", NSStringFromClass(self)];
	return NSSelectorFromString(selectorString);
}

#pragma mark - Public Methods

- (void)acceptVisitor:(id)visitor
{
	Class currentAncestor = [self class];
	
	while ([currentAncestor isSubclassOfClass:[FUSceneObject class]])
	{
		SEL visitSelector = [currentAncestor visitSelector];
		
		if ([visitor respondsToSelector:visitSelector])
		{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
			[visitor performSelector:visitSelector withObject:self];
#pragma clang diagnostic pop
			break;
		}
		
		currentAncestor = [currentAncestor superclass];
	}
}

@end
