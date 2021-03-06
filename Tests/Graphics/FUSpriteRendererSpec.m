//
//  FUSpriteRendererSpec.m
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
#import "FUComponent-Internal.h"


SPEC_BEGIN(FUSpriteRenderer)

describe(@"A sprite renderer component", ^{
	it(@"is a renderer", ^{
		expect([FUSpriteRenderer class]).to.beSubclassOf([FURenderer class]);
	});
	
	context(@"initiailized", ^{
		__block FUSpriteRenderer* spriteRenderer;
		
		beforeEach(^{
			FUEntity* entity = mock([FUEntity class]);
			[given([entity scene]) willReturn:mock([FUScene class])];
			spriteRenderer = [[FUSpriteRenderer alloc] initWithEntity:entity];
		});
		
		it(@"has a nil texture", ^{
			expect([spriteRenderer texture]).to.beNil();
		});
		
		context(@"setting the texture to Test.png", ^{
			it(@"has it's texture property to Test.png", ^{
				[spriteRenderer setTexture:@"Test.png"];
				expect([spriteRenderer texture]).to.equal(@"Test.png");
			});
		});
	});
});

SPEC_END
