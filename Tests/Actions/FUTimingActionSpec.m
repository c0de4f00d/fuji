//
//  FUTimingActionSpec.m
//  Fuji
//
//  Created by David Hart.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#include "Prefix.pch"
#import "Fuji.h"
#import "FUTestSupport.h"


static NSString* const FUActionNilMessage = @"Expected 'action' to not be nil";
static NSString* const FUFunctionNullMessage = @"Expected 'function' to not be NULL";


SPEC_BEGIN(FUTimingAction)

describe(@"A timing action", ^{
	it(@"is a finite action", ^{
		expect([FUTimingAction class]).to.beSubclassOf([FUTimedAction class]);
	});
	
	context(@"initializing with a nil action", ^{
		it(@"throws an exception", ^{
			assertThrows([[FUTimingAction alloc] initWithAction:nil function:FUTimingLinear], NSInvalidArgumentException, FUActionNilMessage);
		});
	});
	
	context(@"initializing with a NULL function", ^{
		it(@"throws an exception", ^{
			FUTimedAction* action = mock([FUTimedAction class]);
			assertThrows([[FUTimingAction alloc] initWithAction:action function:NULL], NSInvalidArgumentException, FUFunctionNullMessage);
		});
	});
	
	context(@"initializing via the function", ^{
		it(@"returns a FUTimingAction", ^{
			FUTimedAction* subaction = mock([FUTimedAction class]);
			expect(FUTiming(subaction, FUTimingEaseIn)).to.beKindOf([FUTimingAction class]);
		});
	});
	
	context(@"initializing with an action and a function", ^{
		__block FUTimingAction* action;
		__block FUTimedAction* subaction;
		
		beforeEach(^{
			subaction = mock([FUTimedAction class]);
			[given([subaction duration]) willReturnDouble:2.0];
			
			action = [[FUTimingAction alloc] initWithAction:subaction function:FUTimingEaseIn];
			[action setNormalizedTime:0.215f];
		});
		
		it(@"has the same duration as it's subaction", ^{
			expect([action duration]).to.equal(2.0);
		});
		
		context(@"setting a negative normalized time", ^{
			it(@"sets the subaction with a normalized time of 0.0f", ^{
				[action setNormalizedTime:-0.5f];
				[verify(subaction) setNormalizedTime:0.0f];
			});
		});
		
		context(@"setting a normalized time of 0.0f", ^{
			it(@"sets the subaction with a normalized time of 0.0f", ^{
				[action setNormalizedTime:0.0f];
				[verify(subaction) setNormalizedTime:0.0f];
			});
		});
		
		context(@"setting a normalized time of 0.5f", ^{
			it(@"sets the subaction with a normalized time of 0.5f on the ease in curve", ^{
				[action setNormalizedTime:0.5f];
				[verify(subaction) setNormalizedTime:FUTimingEaseIn(0.5f)];
			});
		});
		
		context(@"setting a normalized time of 1.0f", ^{
			it(@"sets the subaction with a normalized time of 1.0f", ^{
				[action setNormalizedTime:1.0f];
				[verify(subaction) setNormalizedTime:FUTimingEaseIn(1.0f)];
			});
		});
		
		context(@"setting a normalized time greater than 1.0f", ^{
			it(@"sets the subaction with a normalized time of 1.0f", ^{
				[action setNormalizedTime:1.5f];
				[verify(subaction) setNormalizedTime:FUTimingEaseIn(1.0f)];
			});
		});
		
		context(@"created a copy of the action", ^{
			__block FUTimingAction* actionCopy;
			__block FUTimedAction* subactionCopy;
			
			beforeEach(^{
				subactionCopy = mock([FUTimedAction class]);
				[[given([subaction copyWithZone:nil]) withMatcher:HC_anything()] willReturn:subactionCopy];
				
				actionCopy = [action copy];
			});
			
			context(@"set the normalized time of the copied action", ^{
				beforeEach(^{
					[actionCopy setNormalizedTime:0.5f];
				});
				
				it(@"does not call update on the original subaction", ^{
					[[verifyCount(subaction, never()) withMatcher:HC_anything()] update];
				});
				
				it(@"sets the normalized time of the copied subaction", ^{
					[verify(subactionCopy) setNormalizedTime:FUTimingEaseIn(0.5f)];
				});
			});
		});
	});
});

SPEC_END
