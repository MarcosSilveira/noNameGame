//
//  Boss.h
//  noName
//
//  Created by Guilherme on 21/06/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Warrior.h"

@interface Boss : Warrior
@property SKTextureAtlas *atlas;

@property int attackCool;

@end
