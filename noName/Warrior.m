//
//  Warrior.m
//  noName
//
//  Created by Guilherme Castro on 29/04/14.
//  Copyright (c) 2014 Marcos Sokolowski. All rights reserved.
//

#import "Warrior.h"

@implementation Warrior

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size{
    self = [super initWithColor:color size:size];
    self.walkFrames = [[NSMutableArray alloc]init];
    self.frames = [[NSMutableArray alloc]init];
    self.attackFrames = [[NSMutableArray alloc]init];
    self.isAlive = YES;
    
    return self;
}

-(BOOL)takeDamage:(int)damage{
    self.hp -= damage;
    if(self.hp <= 0){
        [self die];
        return YES;
    }
    return NO;
}

-(void)die{
    [self removeFromParent];
    self.isAlive = NO;
}

@end
