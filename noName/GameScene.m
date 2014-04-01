//
//  GameScene.m
//  noName
//
//  Created by Guilherme Castro on 31/03/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
    }


    
  //  [self addChild:heroi];
    
    
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    SKSpriteNode *heroi = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(100,100)];
    heroi.name = @"Heroi";
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_RIGHT"];
    //SKTexture *f1 = [atlas textureNamed:@"WALK_RIGHT_000_.png"];
    SKTexture *f2 = [atlas textureNamed:@"WALK_RIGHT_001_.png"];
    SKTexture *f3 = [atlas textureNamed:@"WALK_RIGHT_002_.png"];
    SKTexture *f4 = [atlas textureNamed:@"WALK_RIGHT_003_.png"];
    SKTexture *f5 = [atlas textureNamed:@"WALK_RIGHT_004_.png"];
    SKTexture *f6 = [atlas textureNamed:@"WALK_RIGHT_005_.png"];
    SKTexture *f7 = [atlas textureNamed:@"WALK_RIGHT_006_.png"];
    NSArray *monsterWalkTextures = @[f2,f3,f4,f5,f6,f7];
    heroi.position= CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [heroi runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:monsterWalkTextures timePerFrame:0.1f]]];
  //  SKSpriteNode *heroi = [self childNodeWithName:@"Heroi"];
    [self addChild:heroi];
    
    
}
@end
