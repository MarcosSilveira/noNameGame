//
//  StoreScene.h
//  noName
//
//  Created by Marcos Sokolowski on 01/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface StoreScene : SKScene
{
    NSInteger money;
    SKLabelNode *moneyLB;
    SKLabelNode *opcao1;
    SKLabelNode *opcao2;
    SKSpriteNode *back;
    SKLabelNode *comprado1;
    SKLabelNode *comprado2;
    SKLabelNode *comprado3;
    SKLabelNode *comprado4;
    
    }
-(BOOL)realizaCompras:(NSInteger)valor;
-(void)verificaCompras;
-(void)atualizaDinheiro;
-(void)inicializaLabels;
@end
