//
//  Sparta.m
//  noName
//
//  Created by Guilherme Castro on 29/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Sparta.h"

@implementation Sparta

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size{
    self = [super initWithColor:color size:size];
    self.atlas = [SKTextureAtlas atlasNamed:@"GRECULES.atlas"];
    
    for(int i = 1; i <= 6; i++){
        NSString *textureName = [NSString stringWithFormat:@"wl%d", i];
        SKTexture *temp = [self.atlas textureNamed:textureName];
        [self.walkFrames addObject:temp];
    }
    for(int i = 1; i <= 2; i++){
        NSString *textureName = [NSString stringWithFormat:@"at%d", i];
        SKTexture *temp = [self.atlas textureNamed:textureName];
        [self.attackFrames addObject:temp];
    }
    [self.attackFrames addObject:self.walkFrames[5]];
    self.attack2Frames = [[NSMutableArray alloc]initWithObjects:[self.atlas textureNamed:@"ls"], nil];
    self.defFrames = [[NSMutableArray alloc]initWithObjects:[self.atlas textureNamed:@"def"], nil];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:(CGSizeMake(self.size.width/2, self.size.height))];
    
    SKTexture *spartaStpd = self.walkFrames[5];
    self.warriorTexture = [[SKSpriteNode alloc]initWithTexture:spartaStpd color:[SKColor clearColor] size:self.size];
    [self addChild:self.warriorTexture];
    
    self.defendendo = NO;
    self.hp = 5;
    self.lancas = 5;
    self.killedEnem = 0;
    self.attackCool = 15;

    return self;
}

-(void)killedEnemy{
    self.killedEnem++;
    if(self.killedEnem % 10 == 0) self.specialAvailable = YES;
}

@end
