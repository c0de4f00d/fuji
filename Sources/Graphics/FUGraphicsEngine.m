//
//  FUGraphicsEngine.m
//  Fuji
//
//  Created by Hart David on 30.03.12.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#include "Prefix.pch"
#import "FUDirector.h"
#import "FUScene.h"
#import "FUGraphicsEngine.h"
#import "FUGraphicsSettings.h"


@interface FUGraphicsEngine ()

@property (nonatomic, strong) GLKBaseEffect* effect;
@property (nonatomic, WEAK) FUGraphicsSettings* settings;

@end


@implementation FUGraphicsEngine

@synthesize effect = _effect;
@synthesize settings = _settings;

#pragma mark - Initialization

- (id)init
{
	self = [super init];
	if (self == nil) return nil;
	
	glEnable(GL_CULL_FACE);
	
	return self;
}

#pragma mark - Properties

- (GLKBaseEffect*)effect
{
	if (_effect == nil)
	{
		GLKBaseEffect* effect = [GLKBaseEffect new];
		[self setEffect:effect];
 
		CGSize viewSize = [[[self director] view] bounds].size;
		GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, viewSize.width, viewSize.height, 0, -1, 1);
		[[effect transform] setProjectionMatrix:projectionMatrix];
	}
 
	return _effect;
}

#pragma mark - Drawing

- (void)drawFUScene:(FUScene*)scene
{
	FUGraphicsSettings* settings = [scene graphics];
	[self setSettings:settings];
	
	GLKVector4 backgroundColor = [settings backgroundColor];
	glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
	glClear(GL_COLOR_BUFFER_BIT);
}

@end
