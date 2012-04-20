//
//  FUGraphicsEngineSpec.m
//  Fuji
//
//  Created by Hart David on 24.02.12.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#include "Prefix.pch"
#import "Fuji.h"
#import "FUComponent-Internal.h"


SPEC_BEGIN(FUGraphicsEngine)

describe(@"The graphics engine", ^{
	it(@"is a subclass of FUEngine", ^{
		expect([FUGraphicsEngine class]).to.beSubclassOf([FUEngine class]);
	});
	
	context(@"initialized a graphics engine", ^{
		__block FUGraphicsEngine* graphicsEngine = nil;
		
		beforeEach(^{
			EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
			[EAGLContext setCurrentContext:context];
			
			graphicsEngine = [FUGraphicsEngine new];
		});
		
		it(@"is not nil", ^{
			expect(graphicsEngine).toNot.beNil();
		});
		
		it(@"enabled GL_CULL_FACE", ^{
			expect(glIsEnabled(GL_CULL_FACE)).to.beTruthy();
		});
		
		it(@"enabled GL_DEPTH_TEST", ^{
			expect(glIsEnabled(GL_DEPTH_TEST)).to.beTruthy();
		});
	});
});

SPEC_END
