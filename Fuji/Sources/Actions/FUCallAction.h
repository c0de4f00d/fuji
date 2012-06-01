//
//  FUCallAction.h
//  Fuji
//
//  Created by David Hart.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "FUTimedAction.h"


typedef void (^FUCallBlock)();


@interface FUCallAction : FUTimedAction

- (id)initWithBlock:(FUCallBlock)block;

@end


FUCallAction* FUCall(FUCallBlock block);
FUCallAction* FUToggle(id object, NSString* key);
FUCallAction* FUSwitchOn(id object, NSString* key);
FUCallAction* FUSwitchOff(id object, NSString* key);
FUCallAction* FUToggleEnabled(id object);
FUCallAction* FUEnable(id object);
FUCallAction* FUDisable(id object);
