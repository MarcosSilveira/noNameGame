//
//  GameOverScene.m
//  noName
//
//  Created by Marcos Sokolowski on 10/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"
#import "MyScene.h"


@implementation GameOverScene{

}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        width = self.scene.size.width;
        height = self.scene.size.height;
        
        background = [SKTexture textureWithImageNamed:@"gameover.png"];
        SKSpriteNode *fundo2 = [[SKSpriteNode alloc] initWithTexture:background color:nil size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
        fundo2.anchorPoint = CGPointZero;
        
        playAgain = [[SKSpriteNode alloc] initWithImageNamed:@"jogarnovamente.png"];
        playAgain.size = CGSizeMake(self.scene.size.width*0.30, self.scene.size.height*0.15);
        playAgain.position = CGPointMake(CGRectGetMidX(self.frame), height*0.7);
        playAgain.name = @"playAgain";
        
        [self addChild:fundo2];
        [self addChild:playAgain];

        
    }
    return self;
}




@end
