//
//  Boss.m
//  noName
//
//  Created by Guilherme on 21/06/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Boss.h"

@implementation Boss

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size{
    self = [super initWithColor:color size:size];
    self.atlas = [SKTextureAtlas atlasNamed:@"ENEMY2.atlas"];
    
    for(int i = 1; i <= 9; i++){
        NSString *textureName = [NSString stringWithFormat:@"b%d", i];
        SKTexture *temp = [self.atlas textureNamed:textureName];
        [self.frames addObject:temp];
    }
    for(int i = 0; i < 7; i++){
        [self.walkFrames addObject:self.frames[i]];
    }
    for(int i = 7; i < 9; i++){
        [self.attackFrames addObject:self.frames[i]];
    }
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    
    SKTexture *enemyLT = self.frames[0];
    self.warriorTexture = [[SKSpriteNode alloc]initWithTexture:enemyLT color:[SKColor clearColor] size:self.size];
    [self addChild:self.warriorTexture];
    
    self.hp = 5;
    
    return self;
}

@end
