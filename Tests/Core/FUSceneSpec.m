//
//  FUSceneSpec.m
//  Fuji
//
//  Created by Hart David on 24.02.12.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#include "Prefix.pch"
#import "Fuji.h"
#import "FUTestScene.h"
#import "FUTestEngines.h"


SPEC_BEGIN(FUSceneSpec)

describe(@"A scene", ^{
	__block FUScene* scene = nil;
	
	it(@"is a subclass of FUEntity", ^{
		expect([FUScene class]).to.beSubclassOf([FUEntity class]);
	});
	
	context(@"created and initialized", ^{
		beforeEach(^{
			scene = [FUScene scene];
		});
		
		it(@"is not nil", ^{
			expect(scene).toNot.beNil();
		});
		
		it(@"has it's director property be nil", ^{
			expect([scene director]).to.beNil();
		});
		
		it(@"has it's scene property point to itself", ^{
			expect([scene scene]).to.beIdenticalTo(scene);
		});
		
		it(@"contains no entities", ^{
			expect([scene allEntities]).to.beEmpty();
		});
		
		it(@"has a graphics settings component", ^{
			FUGraphicsSettings* graphicsSettings = [scene componentWithClass:[FUGraphicsSettings class]];
			expect(graphicsSettings).toNot.beNil();
			
			NSSet* components = [scene allComponents];
			expect(components).to.haveCountOf(1);
			expect(components).to.contain(graphicsSettings);
		});
		
		it(@"the graphics property returns the graphics engine component", ^{
			FUGraphicsSettings* graphicsSettings = [scene componentWithClass:[FUGraphicsSettings class]];
			expect([scene graphics]).to.beIdenticalTo(graphicsSettings);
		});
		
		context(@"removing the graphics engine component", ^{
			it(@"has the grapics property to nil", ^{
				FUGraphicsSettings* graphicsSettings = [scene componentWithClass:[FUGraphicsSettings class]];
				[scene removeComponent:graphicsSettings];
				expect([scene graphics]).to.beNil();
			});
		});
		
		context(@"removing a nil entity", ^{
			it(@"throws an exception", ^{
				STAssertThrows([scene removeEntity:nil], nil);
			});
		});
		
		context(@"removing an entity that is not in the scene", ^{
			it(@"throws an exception", ^{
				STAssertThrows([scene removeEntity:mock([FUEntity class])], nil);
			});
		});
		
		context(@"created an entity", ^{
			__block FUEntity* entity1 = nil;
			
			beforeEach(^{
				entity1 = [scene createEntity];
			});
			
			it(@"returns a valid entity with the scene property set", ^{
				expect(entity1).toNot.beNil();
				expect(entity1).to.beAnInstanceOf([FUEntity class]);
				expect([entity1 scene]).to.beIdenticalTo(scene);
			});
			
			it(@"contains the entity", ^{
				NSSet* entities = [scene allEntities];
				expect(entities).to.haveCountOf(1);
				expect(entities).to.contain(entity1);
			});
#warning Re-add tests
			/*
			context(@"created a generic engine", ^{
				__block FUGenericEngine* engine = nil;
				
				beforeEach(^{
					engine = mock([FUGenericEngine class]);
				});
				
				context(@"registering the scene with the engine", ^{
					it(@"registers the scene, it's components, and it's entities with the engine", ^{
						[scene registerWithEngine:engine];
						[verify(engine) registerFUSceneObject:scene];
						[verify(engine) registerFUSceneObject:[scene graphics]];
						[verify(engine) registerFUSceneObject:entity1];
					});
				});
				
				context(@"unregistering the scene with the engine", ^{
					it(@"unregisters the scene, it's components, and it's entities from the engine", ^{
						[scene unregisterFromEngine:engine];
						[verify(engine) unregisterFUSceneObject:scene];
						[verify(engine) unregisterFUSceneObject:[scene graphics]];
						[verify(engine) unregisterFUSceneObject:entity1];
					});
				});
			});*/
			
			context(@"added another entity", ^{
				__block FUEntity* entity2 = nil;
				
				beforeEach(^{
					entity2 = [scene createEntity];
				});
				
				it(@"returns a valid entity with the scene property set", ^{
					expect(entity2).toNot.beNil();
					expect(entity2).to.beAnInstanceOf([FUEntity class]);
					expect([entity2 scene]).to.beIdenticalTo(scene);
				});
				
				it(@"contains both entity", ^{
					NSSet* entities = [scene allEntities];
					expect(entities).to.haveCountOf(2);
					expect(entities).to.contain(entity1);
					expect(entities).to.contain(entity2);
				});
			});
			
			context(@"removed the entity", ^{
				beforeEach(^{
					[scene removeEntity:entity1];
				});
				
				it(@"sets the scene property of the entity to nil", ^{
					expect([entity1 scene]).to.beNil();
				});
				
				it(@"contains no entities", ^{
					expect([scene allEntities]).to.beEmpty();
				});
			});
		});
	});
	
	context(@"created and initialized a test scene with a mock entity", ^{
		__block FUTestScene* scene = nil;
		__block FUEntity* entity = nil;
		
		beforeEach(^{
			scene = [FUTestScene scene];
			entity = [scene createEntity];
		});
		
		it(@"are not nil", ^{
			expect(scene).toNot.beNil();
			expect(entity).toNot.beNil();
		});
		
		context(@"calling the rotation methods", ^{
			it(@"called the rotation methods on it's entity", ^{
				[scene willRotateToInterfaceOrientation:UIInterfaceOrientationPortrait duration:1];
				[verify(entity) willRotateToInterfaceOrientation:UIInterfaceOrientationPortrait duration:1];
				
				[scene willAnimateRotationToInterfaceOrientation:UIInterfaceOrientationPortrait duration:1];
				[verify(entity) willAnimateRotationToInterfaceOrientation:UIInterfaceOrientationPortrait duration:1];
				
				[scene didRotateFromInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
				[verify(entity) didRotateFromInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
			});
		});
	});
});

SPEC_END
