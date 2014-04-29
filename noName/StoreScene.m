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

-(void)didMoveToView:(SKView *)view{
    NSInteger width;
    NSInteger height;
    width = self.scene.size.width;
    height = self.scene.size.height;
    
    money = [[NSUserDefaults standardUserDefaults] integerForKey:@"recorde"];
    moneyLB = [[SKLabelNode alloc]initWithFontNamed:@"Arial"];
    moneyLB.fontSize = 40;
    moneyLB.text = [NSString stringWithFormat:@"Dinheiro:%ld",(long)money];
    moneyLB.fontColor = [UIColor grayColor];
    moneyLB.position = CGPointMake(width/2,height*0.8);
    
    back = [[SKSpriteNode alloc]initWithColor:[UIColor blueColor] size:CGSizeMake(100, 50)];
    back.position = CGPointMake(width*0.1, height*0.9);
    back.name = @"back";
    
    [self addChild:moneyLB];
    [self addChild:back];
    
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
}

@end
