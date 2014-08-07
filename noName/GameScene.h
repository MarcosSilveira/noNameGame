//
//  GameScene.h
//  noName
//
//  Created by Guilherme Castro on 31/03/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Sparta.h"
#import "Enemy.h"
#import "Boss.h"

@interface GameScene : SKScene
{
    //Buttons---
    SKSpriteNode *rightBtn;
    SKSpriteNode *leftBtn;
    SKSpriteNode *attack;
    SKSpriteNode *attack2;
    SKSpriteNode *defense;
    //Attacks----
    SKSpriteNode *projectile;
    SKSpriteNode *especial;
    SKSpriteNode *attackRegion;
    SKSpriteNode *special;
    SKSpriteNode *drop;
    //Scenario----
    SKSpriteNode *platform;
    SKSpriteNode *platform2;
    SKSpriteNode *fundo;
    SKSpriteNode *fundo2;
    SKNode *myWorld;
    SKNode *camera;
    //Status---
    SKLabelNode *lancasCount;
    SKLabelNode *vidaCount;
    SKLabelNode *pontosCount;
    SKSpriteNode *vidas;
    SKSpriteNode *shield;
    SKSpriteNode *block;
    SKSpriteNode *block2;
    SKSpriteNode *pause;
    SKSpriteNode *lancasNode;
    //---
    SKTextureAtlas *atlas;
}

@end
