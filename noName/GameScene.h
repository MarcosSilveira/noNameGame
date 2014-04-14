//
//  GameScene.h
//  noName
//
//  Created by Guilherme Castro on 31/03/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene
{
    SKSpriteNode *spartan;
    SKSpriteNode *right;
    SKSpriteNode *left;
    SKSpriteNode *attack;
    SKSpriteNode *attack2;
    SKSpriteNode *projectile;
    SKSpriteNode *attackRegion;
    SKSpriteNode *defense;
    SKSpriteNode *platform;
    SKSpriteNode *platform2;
    SKSpriteNode *fundo;
    SKSpriteNode *fundo2;
    SKSpriteNode *drop;
    SKNode *camera;
    BOOL esquerda;
    BOOL defendendo;
    NSInteger lancas;
    SKLabelNode *lancasCount;
    SKLabelNode *vidaCount;
    SKSpriteNode *vidas;
    NSString *aux;
    NSString *auxHP;
    SKSpriteNode *block;
    SKSpriteNode *block2;
    SKSpriteNode *pause;
    SKSpriteNode *lancasNode;
    }

@end
