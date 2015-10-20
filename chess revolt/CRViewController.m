//
//  CRViewController.m
//  Chess Revolt
//
//  Created by Seth A. Vernon on 10/4/13.
//  Copyright (c) 2013 Chess Revolt by Zoya Apps. All rights reserved.
//

#import "CRViewController.h"
#import "Game.h"
// #import "QWViewController.h"
#import "GameController.h"


@interface CRViewController ()

@property (nonatomic, strong) Game *game;
//@property (nonatomic, strong) QWViewController *qwvc;
@property (nonatomic, strong) GameController *gc;

@end

@implementation CRViewController

- (void)awakeFromNib
{
  //  [self.qwvc.gameController takeBackAllMoves];
    
} 

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

    
}

@end
