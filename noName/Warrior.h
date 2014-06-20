//
//  Warrior.h
//  noName
//
//  Created by Guilherme Castro on 29/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Warrior : SKSpriteNode

@property SKSpriteNode *warrior;
@property NSMutableArray *warriorWalkTextures;
@property BOOL esquerda;
@property NSArray *walkFrames;
@property int width;
@property int height;

-(void)takeDamage;
-(void)die;
-(void)walkWithDistance:(float)distance toTheLeft:(bool)direction withxScale:(float)xScale;

@end
