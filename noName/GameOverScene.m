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

-(id)initWithSize:(CGSize)size andScore:(int)score
{
    pontosAux = score;
    if (self = [super initWithSize:size]) {
       
        width = self.scene.size.width;
        height = self.scene.size.height;
        
        background = [SKTexture textureWithImageNamed:@"gameover2.png"];
        SKSpriteNode *fundo2 = [[SKSpriteNode alloc] initWithTexture:background color:nil size:CGSizeMake(self.scene.size.width, self.scene.size.height)];
        fundo2.anchorPoint = CGPointZero;
        
        playAgain = [[SKSpriteNode alloc] initWithImageNamed:@"jogarnovamente.png"];
        playAgain.size = CGSizeMake(self.scene.size.width*0.45, self.scene.size.height*0.04);
        playAgain.position = CGPointMake(CGRectGetMidX(self.frame), self.scene.size.height/4);
        playAgain.name = @"playAgain";
        
        scoreAux = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
        scoreAux.text = [NSString stringWithFormat:@"%d",score];
        scoreAux.fontColor = [UIColor grayColor];
        scoreAux.fontSize = height*0.09;
        scoreAux.position = CGPointMake(width*0.70, height*0.46);
        
        [self verificaRecorde];
        
        LBRecorde = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
        LBRecorde.fontSize = height*0.06;
        LBRecorde.text = [NSString stringWithFormat:@"Recorde :%ld", (long)recorde];
        LBRecorde.fontColor = [UIColor grayColor];
        LBRecorde.position = CGPointMake(width/2, scoreAux.position.y-scoreAux.position.y/4);
        
        back = [[SKSpriteNode alloc]initWithColor:[UIColor blueColor] size:CGSizeMake(100, 50)];
        back.position = CGPointMake(width*0.1, height*0.9);
        back.name = @"back";
        
        
        [self addChild:fundo2];
        [self addChild:playAgain];
        [self addChild:scoreAux];
        [self addChild:LBRecorde];
        [self addChild:back];
    }
    
    return self;
}
-(void)verificaRecorde{
    recordeAux = [[NSUserDefaults standardUserDefaults] integerForKey:@"recorde"];
    if (recordeAux < pontosAux) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:pontosAux forKey:@"recorde"];
        recorde = pontosAux;
    }
    else
        recorde = recordeAux;
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if([node.name isEqualToString:(@"back")]){
        
        SKScene *Menu = [[MyScene alloc] initWithSize:self.size];
        SKTransition *troca = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:Menu transition:troca];
    }
    
    if ([node.name isEqualToString:@"playAgain"]) {
        SKAction *action = [SKAction scaleBy:1.2 duration:0.5];
        [playAgain runAction:action completion:^{

        SKScene *gameAgain= [[GameScene alloc] initWithSize:self.size];
        SKTransition *troca = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:gameAgain transition:troca];
        }];
    }
}

@end
