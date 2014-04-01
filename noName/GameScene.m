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

    heroi = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(100,100)];
    heroi.name = @"Heroi";
    [self touchesEnded:nil withEvent:nil];
    heroi.position= CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:heroi];
    [self createBotoes];
    
    
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //animation
   
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
  
    
    //end of animation
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"WALK_RIGHT"];
    SKTexture *parado = [atlas textureNamed:@"WALK_RIGHT_006_.png"];
    heroi.texture = parado;
    
    [heroi removeAllActions];
    
}

-(void) createBotoes{
    SKSpriteNode *direita = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(50, 50)];
    direita.name = @"BotaoDireita";
    direita.position = CGPointMake(direita.size.width/2, direita.size.height*2);
    [self addChild:direita];
    
}
@end
