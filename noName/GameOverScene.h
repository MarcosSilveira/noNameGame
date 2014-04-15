//
//  GameOverScene.h
//  noName
//
//  Created by Marcos Sokolowski on 10/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene
{
    SKTexture *background;
    SKSpriteNode *playAgain;
    NSInteger width;
    NSInteger height;
    SKLabelNode *scoreAux;
    NSInteger pontosAux;
    NSInteger recordeAux;
    NSInteger recorde;
    SKLabelNode *LBRecorde;
}

-(id)initWithSize:(CGSize)size andScore:(int)score;

@end
