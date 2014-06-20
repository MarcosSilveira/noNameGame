//
//  Warrior.m
//  noName
//
//  Created by Guilherme Castro on 29/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Warrior.h"

@implementation Warrior{
    //Status
    int hp;
}

-(void)walkWithDistance:(float)distance toTheLeft:(bool)direction withxScale:(float)xScale{
    self.esquerda = direction;
    self.xScale = xScale;
    SKAction *move = [SKAction moveByX:distance y:0 duration:0.1];
    [self.warrior runAction:[SKAction repeatActionForever:move]withKey:@"WalkLAction1"];
    [self.warrior runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.warriorWalkTextures timePerFrame:0.1f]]withKey:@"WalkLAction2"];
    
}

-(void)takeDamage{
    hp--;
}

-(void)die{
    [self removeFromParent];
}

@end
