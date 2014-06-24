//
//  StoreScene.m
//  noName
//
//  Created by Marcos Sokolowski on 01/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "StoreScene.h"
#import "MyScene.h"

@implementation StoreScene
NSInteger width;
NSInteger height;
-(void)didMoveToView:(SKView *)view{

    [self inicializaLabels];
    width = self.scene.size.width;
    height = self.scene.size.height;
    money = [[NSUserDefaults standardUserDefaults] integerForKey:@"recorde"];
    
    moneyLB = [[SKLabelNode alloc]initWithFontNamed:@"Arial"];
    moneyLB.fontSize = width*0.04;
    moneyLB.text = [NSString stringWithFormat:@"Dinheiro:%ld",(long)money];
    moneyLB.fontColor = [UIColor grayColor];
    moneyLB.position = CGPointMake(width/2,height*0.8);
    
    back = [[SKSpriteNode alloc]initWithColor:[UIColor blueColor] size:CGSizeMake(100, 50)];
    back.position = CGPointMake(width*0.1, height*0.9);
    back.name = @"back";
    
    opcao1 = [[SKLabelNode alloc]initWithFontNamed:@"Arial"];
    opcao1.fontSize = width*0.04;
    opcao1.fontColor = [UIColor grayColor];
    opcao1.text = @"500 - 10 Lanças no inicio do jogo";
    opcao1.position = CGPointMake(width*0.3, height/2);
    opcao1.name = @"opcao1";
    
    opcao2 = [[SKLabelNode alloc]initWithFontNamed:@"Arial"];
    opcao2.fontSize = width*0.04;
    opcao2.fontColor = [UIColor grayColor];
    opcao2.text = @"1000 - Especial pronto desde o inicio do jogo";
    opcao2.position = CGPointMake(width*0.4, height*0.3);
    opcao2.name = @"opcao2";
    

    
    [self addChild:opcao2];
    [self addChild:opcao1];
    [self addChild:moneyLB];
    [self addChild:back];
   [self verificaCompras];
    
}

-(void)inicializaLabels{
    comprado1 = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    comprado1.fontSize = 40;
    comprado1.fontColor = [UIColor redColor];
    comprado1.text = @"(Comprado)";
    [comprado1 runAction:[SKAction rotateByAngle:50 duration:0.1]];
    
    comprado2 = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    comprado2.fontSize = 40;
    comprado2.fontColor = [UIColor redColor];
    comprado2.text = @"(Comprado)";
    [comprado2 runAction:[SKAction rotateByAngle:50 duration:0.1]];
    
    comprado3 = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    comprado3.fontSize = 40;
    comprado3.fontColor = [UIColor redColor];
    comprado3.text = @"(Comprado)";
    [comprado3 runAction:[SKAction rotateByAngle:50 duration:0.1]];
    
    comprado4 = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    comprado4.fontSize = 40;
    comprado4.fontColor = [UIColor redColor];
    comprado4.text = @"(Comprado)";
    [comprado4 runAction:[SKAction rotateByAngle:50 duration:0.1]];
}
-(void)atualizaDinheiro{
    
moneyLB.text = [NSString stringWithFormat:@"Dinheiro:%ld",(long)money];

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
    
    if([node.name isEqualToString:@"opcao1"]){
        if( [self realizaCompras:500]){
            comprado1.position = CGPointMake(opcao1.position.x+opcao1.position.x*0.2, opcao1.position.y);
            [self addChild:comprado1];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"10lancas"];
        }
    }
    if([node.name isEqualToString:@"opcao2"]){
        if( [self realizaCompras:1000]){
            comprado2.position = CGPointMake(opcao2.position.x+opcao2.position.x*0.2, opcao2.position.y);
            [self addChild:comprado2];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"especialReady"];
            
            
        }
        
    }

}
-(void)verificaCompras{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"10lancas"]){
        comprado1.position = CGPointMake(opcao1.position.x+opcao1.position.x*0.2, opcao1.position.y);
        [self addChild:comprado1];
    }
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"especialReady"]){
        comprado2.position = CGPointMake(opcao2.position.x+opcao1.position.x*0.2, opcao2.position.y);
        [self addChild:comprado2];
    }
    
    
}
-(BOOL)realizaCompras:(NSInteger )valor{
    if (valor<money) {
        money = money-valor;
        
        return YES;
    }
    else
        return NO;
}
-(void)update:(NSTimeInterval)currentTime{
    [self atualizaDinheiro];
}
@end
