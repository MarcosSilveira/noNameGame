//
//  Enemy.m
//  noName
//
//  Created by Guilherme Castro on 20/06/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

-(instancetype)initCreateEnemyWithTexture:(NSArray *)frames inPosition:(CGPoint)pos{
    self = [super initWithColor:[SKColor brownColor] size:CGSizeMake(self.width*0.08, self.height*0.08)];
    for(int i = 0; i < 6; i++){
        [self.walkFrames addObject:frames[i]];
    }
    self.name = @"enemy";
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];

    self.position = pos;
    self.zPosition = 1;
    SKTexture *enemyLT = frames[6];
    self.warriorTexture = [[SKSpriteNode alloc]initWithTexture:enemyLT color:[SKColor clearColor] size:self.size];
    [self addChild:self.warriorTexture];
    
    return self;
}

@end
