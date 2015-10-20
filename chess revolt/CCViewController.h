//
//  CCViewController.h
//  Chess Revolt
//
//  Created by Seth A. Vernon on 11/8/13.
//  Copyright (c) 2013 Chess Revolt by Zoya Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "GameController.h"
#import "BoardView.h"
#import "Game.h"
#import "Options.h"
#import "BoardViewController.h"
#import "ContentView.h"
#import "MoveListView.h"


@interface CCViewController : UIViewController <UIActionSheetDelegate>


@property (nonatomic, strong)BoardView *boardView;
@property (nonatomic, strong)GameController *gameController;
@property (nonatomic, strong)Game *ccGame;
@property (nonatomic, strong)PieceImageView *piv;
@property (nonatomic, strong)BoardViewController *boardViewController;
@property (nonatomic, strong)ContentView *contentView;
@property (nonatomic, strong)MoveListView *moveListView;
@property (nonatomic, strong)UILabel *analysisView;
@property (nonatomic, strong)UILabel *bookMovesView;
//@property (nonatomic, strong)UILabel *whiteClockView;
//@property (nonatomic, strong)UILabel *blackClockView;
@property (nonatomic, strong)UILabel *searchStatsView;

- (void)backgroundInit:(id)anObject;
- (void)backgroundInitFinished:(id)anObject;

@end
