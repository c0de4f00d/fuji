//
//  FUViewController.m
//  Fuji
//
//  Created by Hart David on 22.02.12.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#import "FUDirector.h"
#import "FUDirector-Internal.h"
#import "FUScene.h"
#import "FUScene-Internal.h"
#import "FUEngine.h"
#import "FUEngine-Internal.h"
#import "FUSceneObject.h"
#import "FUSceneObject-Internal.h"
#import "FUGraphicsEngine.h"


static NSString* const FUDirectorNilMessage = @"Expected 'director ' to not be nil";
static NSString* const FUSceneAlreadyUsedMessage = @"The 'scene=%@' is already showing in another 'director=%@'";
static NSString* const FUEngineNilMessage = @"Expected 'engine' to not be nil";
static NSString* const FUEngineAlreadyUsedMessage = @"The 'engine=%@' is already used in another 'director=%@'";
static NSString* const FUEngineAlreadyInDirector = @"The 'engine=%@' is already used in this director.'";
static NSString* const FUSceneObjectNilMessage = @"Expected 'sceneObject' to not be nil";
static NSString* const FUSceneObjectInvalidMessage = @"Expected 'sceneObject=%@' to have the same 'director=%@'";


@interface FUDirector ()

@property (nonatomic, strong) NSMutableSet* engines;

@end


@implementation FUDirector

@synthesize scene = _scene;
@synthesize context = _context;
@synthesize engines = _engines;

#pragma mark - Properties

- (EAGLSharegroup*)sharegroup
{
	return [[self context] sharegroup];
}

- (void)setScene:(FUScene*)scene
{
	if (scene != _scene)
	{
		FUAssert([scene director] == nil, FUSceneAlreadyUsedMessage, scene, [scene director]);
		
		[self unregisterAll];
		[_scene setDirector:nil];
		_scene = scene;
		[scene setDirector:self];
		[scene register];
	}
}

- (EAGLContext*)context
{
	if (_context == nil)
	{
		EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		[self setContext:context];
	}
	
	if ([EAGLContext currentContext] != _context)
	{
		[EAGLContext setCurrentContext:_context];
	}
	
	return _context;
}

- (void)setContext:(EAGLContext*)context
{
	if (_context != context)
	{
		if ([EAGLContext currentContext] == _context)
		{
			[EAGLContext setCurrentContext:context];
		}
		
		_context = context;
	}
}

- (NSMutableSet*)engines
{
	if (_engines == nil)
	{
		[self setEngines:[NSMutableSet set]];
	}
	
	return _engines;
}

#pragma mark - Initialization

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self == nil) return nil;

	[self context];
	[self addEngine:[FUGraphicsEngine new]];
	return self;
}

- (id)initAndShareResourcesWithDirector:(FUDirector*)director
{
	FUAssert(director != nil, FUDirectorNilMessage);
	
	EAGLSharegroup* sharegroup = [[director context] sharegroup];
	EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:sharegroup];
	[self setContext:context];
	
	self = [self initWithNibName:nil bundle:nil];
	return self;
}

#pragma mark - Public Methods

- (void)addEngine:(FUEngine*)engine
{
	FUAssert(engine != nil, FUEngineNilMessage);
	FUAssert([engine director] != self, FUEngineAlreadyInDirector, engine);
	FUAssert([engine director] == nil, FUEngineAlreadyUsedMessage, engine, [engine director]);
	
	[[self engines] addObject:engine];
	[engine setDirector:self];
}

- (NSSet*)allEngines
{
	return [NSSet setWithSet:[self engines]];
}

- (void)registerSceneObject:(FUSceneObject*)sceneObject
{
	[self makeEnginesPerformSelectorWithPrefix:@"register" withSceneObject:sceneObject];
}

- (void)unregisterSceneObject:(FUSceneObject*)sceneObject
{
	[self makeEnginesPerformSelectorWithPrefix:@"unregister" withSceneObject:sceneObject];
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	GLKView* view = (GLKView*)[self view];
	[view setDrawableDepthFormat:GLKViewDrawableDepthFormat16];
	[view setContext:[self context]];
}

- (void)viewDidUnload
{
	[self setContext:nil];
	
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	for (FUEngine* engine in [self engines])
	{
		[engine willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
	
	[[self scene] willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	for (FUEngine* engine in [self engines])
	{
		[engine willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
	
	[[self scene] willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	for (FUEngine* engine in [self engines])
	{
		[engine didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	}
	
	[[self scene] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - GLKViewController Methods

- (void)update
{
	for (FUEngine* engine in [self engines])
	{
		[engine update];
	}
}

- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect
{
	for (FUEngine* engine in [self engines])
	{
		[engine draw];
	}
}

#pragma mark - Private Methods

- (void)unregisterAll
{
	for (FUEngine* engine in [self engines])
	{
		[engine unregisterAll];
	}
}

- (void)makeEnginesPerformSelectorWithPrefix:(NSString*)prefix withSceneObject:(FUSceneObject*)sceneObject
{
	FUAssert(sceneObject != nil, FUSceneObjectNilMessage);
	FUAssert([[sceneObject scene] director] == self, FUSceneObjectInvalidMessage, sceneObject, [[sceneObject scene] director]);
	
	for (FUEngine* engine in [self engines])
	{
		Class currentAncestor = [sceneObject class];
	
		while ([currentAncestor isSubclassOfClass:[FUSceneObject class]])
		{
			NSString* selectorString = [NSString stringWithFormat:@"%@%@:", prefix, NSStringFromClass(currentAncestor)];
			SEL selector = NSSelectorFromString(selectorString);
		
			if ([engine respondsToSelector:selector])
			{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
				[engine performSelector:selector withObject:sceneObject];
#pragma clang diagnostic pop
				break;
			}
		
			currentAncestor = [currentAncestor superclass];
		}
	}
}

@end
