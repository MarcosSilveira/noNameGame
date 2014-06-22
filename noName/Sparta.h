//
//  Sparta.h
//  noName
//
//  Created by Guilherme Castro on 29/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Warrior.h"

@interface Sparta : Warrior
@property NSMutableArray *attack2Frames;
@property NSMutableArray *defFrames;
@property SKTextureAtlas *atlas;

@property BOOL defendendo;
@property BOOL specialAvailable;
@property int lancas;
@property int killedEnem;
@property int attackCool;

-(void)killedEnemy;

@end
