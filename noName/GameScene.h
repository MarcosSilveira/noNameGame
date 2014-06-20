//
//  GameScene.h
//  noName
//
//  Created by Guilherme Castro on 31/03/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Enemy.h"

@interface GameScene : SKScene
{
    SKSpriteNode *spartan;
    SKSpriteNode *spartanTexture;
    SKSpriteNode *right;
    SKSpriteNode *left;
    SKSpriteNode *attack;
    SKSpriteNode *attack2;
    SKSpriteNode *projectile;
    SKSpriteNode *especial;
    SKSpriteNode *attackRegion;
    SKSpriteNode *defense;
    SKSpriteNode *platform;
    SKSpriteNode *platform2;
    SKSpriteNode *fundo;
    SKSpriteNode *fundo2;
    SKSpriteNode *special;
    SKSpriteNode *drop;
    SKNode *camera;
    BOOL esquerda;
    BOOL defendendo;
    BOOL FOGAREU;
    int specialAux;
    NSInteger lancas;
    SKLabelNode *lancasCount;
    SKLabelNode *vidaCount;
    SKLabelNode *pontosCount;
    NSString *aux;
    NSString *auxHP;
    NSString *auxPontos;
    SKSpriteNode *vidas;
    SKSpriteNode *block;
    SKSpriteNode *block2;
    Enemy *enemy;
    SKSpriteNode *pause;
    SKSpriteNode *lancasNode;
    SKSpriteNode *boss;
    NSMutableArray *walkFrames;
    SKNode *myWorld;
    SKTextureAtlas *lifeAtlas;
    SKTextureAtlas *atlas;
}

@end
