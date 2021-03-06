//
//  FUVisitorSpec.m
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
#import "FUVisitor-Internal.h"
#import "FUSceneObject-Internal.h"


@interface FUParentSceneObject : FUSceneObject @end
@interface FUChildSceneObject : FUParentSceneObject @end

@interface FUParentVisitor : FUVisitor
@property (nonatomic, readonly) NSUInteger parentVisitCount;
- (void)visitFUParentSceneObject:(FUParentSceneObject*)sceneObject;
@end

@interface FUChildVisitor : FUParentVisitor
@property (nonatomic, readonly) NSUInteger childVisitCount;
- (void)visitFUChildSceneObject:(FUChildSceneObject*)sceneObject;
@end

@interface FUEmptyVisitor : FUVisitor @end


SPEC_BEGIN(FUVisitor)

describe(@"A visitor", ^{	
	context(@"created a child scene object", ^{
		__block FUChildSceneObject* sceneObject;
		
		beforeEach(^{
			sceneObject = [[FUChildSceneObject alloc] initWithScene:mock([FUScene class])];
		});
		
		context(@"visiting the scene object with a visitor that handles the parent scene object", ^{
			it(@"calls the parent visit method", ^{
				FUParentVisitor* visitor = [FUParentVisitor new];
				[visitor visitSceneObject:sceneObject];
				expect([visitor parentVisitCount]).to.equal(1);
			});
		});
		
		context(@"visiting the scene object with a visitor that handles the parent and child scene object", ^{
			it(@"calls the child visit method", ^{
				FUChildVisitor* visitor = [FUChildVisitor new];
				[visitor visitSceneObject:sceneObject];
				expect([visitor parentVisitCount]).to.equal(0);
				expect([visitor childVisitCount]).to.equal(1);
			});
		});
		
		context(@"visiting the scene object with the visitor that does not handle any scene obejct", ^{
			it(@"does nothing", ^{
				FUEmptyVisitor* visitor = [FUEmptyVisitor new];
				[visitor visitSceneObject:sceneObject];
			});
		});
	});

});

SPEC_END


@implementation FUParentSceneObject @end
@implementation FUChildSceneObject @end

@implementation FUParentVisitor
- (void)visitFUParentSceneObject:(FUParentSceneObject*)sceneObject { _parentVisitCount++; }
@end

@implementation FUChildVisitor
- (void)visitFUChildSceneObject:(FUChildSceneObject*)sceneObject { _childVisitCount++; }
@end

@implementation FUEmptyVisitor @end
