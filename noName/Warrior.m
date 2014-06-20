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

-(void)walkWithDistance:(float)distance toTheLeft:(bool)direction withDuration:(float)duration{
    self.esquerda = direction;
    if(direction) self.warriorTexture.xScale = 1.0;
    else self.warriorTexture.xScale = -1.0;
    SKAction *move = [SKAction moveByX:distance y:0 duration:duration];
    [self runAction:[SKAction repeatActionForever:move]withKey:@"WalkLAction1"];
//    [self.warriorTexture runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkFrames timePerFrame:0.1f]]withKey:@"WalkLAction2"];
}

-(void)takeDamage{
    hp--;
}

-(void)die{
    [self removeFromParent];
}

-(void)setScreenSize{
    self.width = self.scene.size.width;
    self.height = self.scene.size.height;
}

@end
