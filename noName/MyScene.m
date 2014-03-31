//
//  MyScene.m
//  noName
//
//  Created by Marcos Sokolowski on 24/03/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        SKTexture *fundo = [SKTexture textureWithImageNamed:@"Grecia.jpg"];
        SKSpriteNode *fundo2 = [[SKSpriteNode alloc] initWithTexture:fundo color:nil size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
        fundo2.anchorPoint = CGPointZero;
        
        SKLabelNode *PlayLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        SKLabelNode *StoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        StoreLabel.text = @"Loja";
        StoreLabel.fontSize = 30;
        StoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 150);
        StoreLabel.name = @"LojaNode";
        PlayLabel.name = @"JogarNode";
        PlayLabel.text = @"Jogar";
        PlayLabel.fontSize = 30;
        PlayLabel.position = CGPointMake(CGRectGetMidX(self.frame), 200);
        
        [self addChild:fundo2];
        [self addChild:PlayLabel];
        [self addChild:StoreLabel];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        SKNode *aux = [self childNodeWithName:@"JogarNode"];

        CGPoint location = [touch locationInNode:self];
        CGPoint location2 = aux.position;
                if(location==location2)
        {
        }
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
