//
//  UIDevice+HDAdditions.h
//  Mocha2D
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDevice (MOAdditions)

@property (nonatomic, copy, readonly) NSString* platformSuffix;

+ (NSSet*)platformSuffixes;

@end
