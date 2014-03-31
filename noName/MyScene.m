//
//  MyScene.m
//  noName
//
//  Created by Marcos Sokolowski on 24/03/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "MyScene.h"
#import "GameScene.h"

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
        StoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), (self.scene.size.height*3)/8);
        StoreLabel.name = @"LojaNode";
        PlayLabel.name = @"JogarNode";
        PlayLabel.text = @"Jogar";
        PlayLabel.fontSize = 30;
        PlayLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.scene.size.height/2);
        
        [self addChild:fundo2];
        [self addChild:PlayLabel];
        [self addChild:StoreLabel];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    SKNode *loja = [self childNodeWithName:@"LojaNode"];
    
    if([node.name isEqualToString:@"LojaNode"]){
        SKAction *action = [SKAction scaleBy:2 duration:3];
        [loja runAction:action];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end