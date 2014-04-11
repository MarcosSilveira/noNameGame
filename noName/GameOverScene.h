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
    int width;
    int height;
    SKLabelNode *scoreAux;
}

-(id)initWithSize:(CGSize)size andScore:(NSInteger)score;

@end
