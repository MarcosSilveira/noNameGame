//
//  Warrior.h
//  noName
//
//  Created by Guilherme Castro on 29/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Warrior : SKSpriteNode

@property SKSpriteNode *warriorTexture;
@property BOOL esquerda;
@property NSMutableArray *walkFrames;
@property NSMutableArray *attackFrames;
@property int width;
@property int height;

-(void)takeDamage;
-(void)die;
-(void)walkWithDistance:(float)distance toTheLeft:(bool)direction withDuration:(float)duration;
-(void)setScreenSize;

@end
