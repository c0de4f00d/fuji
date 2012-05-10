//
//  FUFiniteAction.h
//  Fuji
//
//  Created by David Hart
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>
#import "FUAction.h"


@interface FUFiniteAction : NSObject <FUAction>

- (id)initWithDuration:(NSTimeInterval)duration;

@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly, getter=isComplete) BOOL complete;

- (void)updateWithDeltaTime:(NSTimeInterval)deltaTime;
- (void)updateWithFactor:(float)factor;

@end