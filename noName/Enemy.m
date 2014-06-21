//
//  Enemy.m
//  noName
//
//  Created by Guilherme Castro on 20/06/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size{
    self = [super initWithColor:color size:size];
    self.atlas = [SKTextureAtlas atlasNamed:@"ENEMY1.atlas"];
    
    for(int i = 1; i <= 10; i++){
        NSString *textureName = [NSString stringWithFormat:@"en%d", i];
        SKTexture *temp = [self.atlas textureNamed:textureName];
        [self.frames addObject:temp];
    }
    for(int i = 0; i < 6; i++){
        [self.walkFrames addObject:self.frames[i]];
    }
    for(int i = 7; i < 10; i++){
        [self.attackFrames addObject:self.frames[i]];
    }
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    
    SKTexture *enemyLT = self.frames[6];
    self.warriorTexture = [[SKSpriteNode alloc]initWithTexture:enemyLT color:[SKColor clearColor] size:self.size];
    [self addChild:self.warriorTexture];
    
    self.hp = 1;
    
    return self;
}

+(SKTextureAtlas *)createAtlas{
    static SKTextureAtlas *atlas = nil;
    
    if(atlas == nil){
        atlas = [SKTextureAtlas atlasNamed:@"ENEMY1"];
    }
    return atlas;
}


@end
