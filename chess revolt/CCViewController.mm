//
//  CCViewController.m
//  Chess Revolt
//
//  Created by Seth A. Vernon on 11/8/13.
//  Copyright (c) 2013 Chess Revolt by Zoya Apps. All rights reserved.
//
//

#import "CCViewController.h"
#import "EngineController.h"
#import "LastMoveView.h"

#import "PieceImageView.h"
#import "PGN.h"
#import "RemoteEngineController.h"
#import "TargetConditionals.h"
#import "OptionsViewController.h"
#import "GameDetailsTableController.h"
#import "LevelViewController.h"
#import "AboutViewController.h"

#include <sys/stat.h>
#include "bitboard.h"
#include "direction.h"
#include "mersenne.h"
#include "movepick.h"
#include "position.h"
#include "misc.h"
#include "mersenne.h"
#include "movepick.h"
#import "iCA_GeneralMethods.h"

using namespace Chess;

@interface CCViewController ()

@property (nonatomic, strong)Options *ccOptions;
@property (nonatomic, strong)GameDetailsTableController *ccGameDetailsVC;
@property (nonatomic, strong)UIBarButtonItem *gameButton, *optionsButton;
@property (nonatomic, strong)UIActionSheet *gameMenu, *startGameMenu, *moveMenu; /// SAV 3.13.14 changed newGameMenu to start
@property (nonatomic, strong)UIPopoverController *optionsMenu, *saveMenu, *emailMenu, *levelsMenu, *loadMenu;
@property (nonatomic, strong)UIPopoverController *popoverMenu;
@property (nonatomic, strong)RootView *rootView;
@property (nonatomic, strong)OptionsViewController *ccOVC;
@property (nonatomic, strong)UINavigationController *ccNC;
@property (nonatomic, strong)UINavigationController *ccSaveGameNC;
@property (nonatomic, strong)UINavigationController *gameOptions;

@property (nonatomic, strong)ChessClock *clock;
@property (weak, nonatomic) IBOutlet UILabel *whiteClockView;
@property (weak, nonatomic) IBOutlet UILabel *blackClockView;

@property (nonatomic)Square pendingTo, pendingFrom;
@property (nonatomic, readwrite) BOOL engineIsPlaying;
@property (nonatomic, strong)NSMutableArray *pieceViews;
@property (nonatomic, strong)EngineController * engineController;
@property (nonatomic, strong)RemoteEngineController *remoteEngineController;
@property (nonatomic, readonly) BOOL *rotated;

@property (nonatomic, strong)LevelViewController *LevelController;
@property (nonatomic, strong)AboutViewController *aboutController;

@property (weak, nonatomic) IBOutlet UIImageView *darkKnights;
@property (weak, nonatomic) IBOutlet UIImageView *wildSquares;
@property (weak, nonatomic) IBOutlet UIImageView *warOfQueens;

@property (nonatomic, strong) NSTimer *foo;
@property (nonatomic, strong) UIImageView *whatEverIWant;
@property (nonatomic) int imageNumber;

@end

@implementation CCViewController


- (BoardView *)boardView
{
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect iPad = CGRectMake(8, 74, 640, 640);// 8,74,640,640
        if (! _boardView ) _boardView = [[BoardView alloc]initWithFrame:iPad GameName:@"Close Combat"];
        return _boardView ;
    }
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    
        {
            
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
       if (iOSDeviceScreenSize.height == 568)
       {
           
        CGRect iPhone = CGRectMake(0, 146, 320, 320); //146
        if (! _boardView ) _boardView = [[BoardView alloc]initWithFrame:iPhone GameName:@"Close Combat"];
        return _boardView ;
       }
            
     if (iOSDeviceScreenSize.height == 480)
        {
        CGRect iPhone4 = CGRectMake(0, 82, 320, 320); // 320
        if (!_boardView)
                _boardView = [[BoardView alloc]initWithFrame:iPhone4 GameName:@"Close Combat"];
            
        }
        
    }
    return _boardView;
}




- (BoardViewController *)boardViewController
{
    if (! _boardViewController ) _boardViewController = [[BoardViewController   alloc]initWithGameName:@"Close Combat"];
    return _boardViewController ;
}
- (GameController *)gameController
{
    if (!_gameController)
        _gameController = [[GameController alloc] initWithGameName:@"Close Combat"];
    return _gameController;
}
- (Game *)ccGame
{
    if (! _ccGame) _ccGame = [[Game alloc] init];
    return _ccGame;
}
- (PieceImageView *)piv
{
    if (!_piv)
        _piv = [[PieceImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,40 , 40)];
    return _piv ;
}
- (Options *)ccOptions
{
    if (!_ccOptions) _ccOptions = [[Options  alloc]initWithGameName:@"Close Combat"];
    return _ccOptions;
}
- (GameDetailsTableController *)ccGameDetailsVC
{
    if (!_ccGameDetailsVC)
        _ccGameDetailsVC = [[GameDetailsTableController alloc] init];
    return _ccGameDetailsVC;
}

- (OptionsViewController *)ccOVC
{
    if (!_ccOVC)
        _ccOVC = [[OptionsViewController alloc] init];
        return _ccOVC;
}

- (UINavigationController *)ccNC
{
    if (!_ccNC)
        _ccNC = [[UINavigationController alloc] initWithRootViewController:self.ccOVC];
    return _ccNC;
}

- (LevelViewController *)LevelController
{
    if (!_LevelController) {
        _LevelController = [[LevelViewController alloc] init];
    }
    return _LevelController;
}

- (UINavigationController *)gameOptions
{
    if (!_gameOptions)
        _gameOptions = [[UINavigationController alloc] initWithRootViewController:self.LevelController];
    return _gameOptions;
}

- (void)awakeFromNib
{
    [self setup];
    [self updateUI];
}


- (void)setup
{
    NSLog(@"%@", PGN_DIRECTORY);
	
#if defined(TARGET_OS_IPHONE)
    if (!Sandbox)
        mkdir("/var/mobile/Library/abaia", 0755);
#endif
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    [self performSelectorInBackground: @selector(backgroundInit:)
                           withObject: nil];
}
- (void)backgroundInit:(id)anObject {
    
	
    self.gameController =
    
    [[GameController alloc] initWithBoardView: [self boardView]
								 moveListView: [self moveListView]
								 analysisView: [self analysisView]
								bookMovesView: [self bookMovesView]
							   whiteClockView: [self whiteClockView]
							   blackClockView: [self blackClockView]
							  searchStatsView: [self searchStatsView]];
    
    
    [self.view addSubview: self.boardView];
    
	/* Chess init */
    init_mersenne();
	init_direction_table();
	init_bitboards();
	Position::init_zobrist();
	Position::init_piece_square_tables();
	MovePicker::init_phase_table();
    
	// Make random number generation less deterministic, for book moves
	int i = abs(get_system_time() % 10000);
	for (int j = 0; j < i; j++)
		genrand_int32();
    
	[self.gameController loadPieceImages];
	[self performSelectorOnMainThread: @selector(backgroundInitFinished:)
						   withObject: nil
						waitUntilDone: NO];
    
    [self animateIcons];

    
}




- (void)backgroundInitFinished:(id)anObject
{
    [self.gameController showPiecesAnimate: YES];
    [self.boardViewController stopActivityIndicator];
    
    [self setGameController: self.gameController];
    [[self.boardViewController boardView] setGameController: self.gameController];
    [[self.boardViewController moveListView] setGameController: self.gameController];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
    
    NSString *lastGamePGNString = [defaults objectForKey: @"lastGame"];   ///////   sav 2.5.14
    if (lastGamePGNString)
        [self.gameController gameFromPGNString: lastGamePGNString];
    else
    {
        NSString *coreFEN = @"/rnbqqbnr/pppppppp/8/8/PPPPPPPP/RNBQQBNR/";
        NSString *endFEN = @" w KQkq - 0 1";
        NSArray *blackOptions = @[@"k7",@"1k6",@"2k5",@"3k4",@"4k3",@"5k2",@"6k1",@"7k"];
        NSArray *whiteOptions = @[@"K7",@"1K6",@"2K5",@"3K4",@"4K3",@"5K2",@"6K1",@"7K"];
        
        
        int blackPiecesConfigNumber = [iCA_GeneralMethods randomIntegerInRangeMinimum:0 andMaximum:[blackOptions count]-1];
        int whitePiecesConfigNumber = [iCA_GeneralMethods randomIntegerInRangeMinimum:0 andMaximum:[whiteOptions count]-1];
        NSString *ccFEN = [NSString stringWithFormat:@"%@%@%@%@",blackOptions[blackPiecesConfigNumber],coreFEN,whiteOptions[whitePiecesConfigNumber],endFEN];
        
        [self.gameController gameFromFEN: ccFEN];
    }
    int gameLevel = [defaults integerForKey: @"gameLevel"];
    if (gameLevel) {
        gameLevel = 1300;
//        [[Options sharedOptions] setGameLevel: (GameLevel)(gameLevel - 1)];         ///// sv 2.5.14
//        [self.gameController setGameLevel: [[Options sharedOptions] gameLevel]];
    }
    
    int whiteRemainingTime = [defaults integerForKey: @"whiteRemainingTime"];
    int blackRemainingTime = [defaults integerForKey: @"blackRemainingTime"];
    
    self.clock = [[self.gameController game] clock];
    if (whiteRemainingTime)
        [self.clock addTimeForWhite: (whiteRemainingTime - [self.clock whiteRemainingTime])];
    if (blackRemainingTime)
        [self.clock addTimeForBlack: (blackRemainingTime - [self.clock blackRemainingTime])];
    
    int gameMode = [defaults integerForKey: @"gameMode"];
    if (gameMode)
    {
        [self.ccOptions setGameMode: (GameMode)(gameMode - 1)];
        [self.gameController setGameMode: [[Options sharedOptions] gameMode]];
    }
    else                                            /////     mm 2.5.14   
        NSLog(@"%@",self.ccOptions);

    
    
    if ([defaults objectForKey: @"rotateBoard"])
        [self.gameController rotateBoard: [defaults boolForKey: @"rotateBoard"]];
    
    [self.gameController startEngine];
//    [self.gameController showBookMoves]; sav 3.21.14
}







- (void)updateUI
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        self.foo = [NSTimer scheduledTimerWithTimeInterval:15
                    
                                                    target:self
                                                  selector:@selector(animateIcons)
                                                  userInfo:nil
                                                   repeats:YES];
        /// Toolbar in Code
        
        
        
        UIToolbar *toolbar =
        [[UIToolbar alloc]
         initWithFrame: CGRectMake(0.0f, 20.0f, 320.0f, 44.0f)];
        toolbar.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview: toolbar];
        [toolbar setAutoresizingMask: UIViewAutoresizingFlexibleWidth];
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        UIBarButtonItem *button;
        
        button = [[UIBarButtonItem alloc] initWithTitle: @"Game"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                 action: @selector(toolbarButtonPressed:)];
        [button setWidth: 84.0f];
        [buttons addObject: button];
        self.gameButton = button;
        
        button = [[UIBarButtonItem alloc] initWithTitle: @"Options"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                 action: @selector(toolbarButtonPressed:)];
        [button setWidth: 84.0f];
        [buttons addObject: button];
        self.optionsButton = button;
        
        button = [[UIBarButtonItem alloc] initWithTitle: @"Flip"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                 action: @selector(toolbarButtonPressed:)];
        [buttons addObject: button];
        [button setWidth:64.0f];
        
        button = [[UIBarButtonItem alloc] initWithTitle: @"Move"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                 action: @selector(toolbarButtonPressed:)];
        [button setWidth: 64.0f];
        [buttons addObject: button];
        
        button = [[UIBarButtonItem alloc] initWithTitle: @"Hint"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                 action: @selector(toolbarButtonPressed:)];
        [button setWidth: 64.0f];
        [buttons addObject: button];
        
        [toolbar setItems: buttons animated: YES];
        [toolbar sizeToFit];
        
    }
        
//    }  else {
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            
        {
            
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if (iOSDeviceScreenSize.height == 568)
        {

        // Toolbar
        UIToolbar *toolbar =
        [[UIToolbar alloc] 
         initWithFrame: CGRectMake(0, 525, 320, 60)]; // 0.0f, 480.0f-64.0f, 320.0f, 64.0f // 527
        [self.view addSubview: toolbar];
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        UIBarButtonItem *button;
        
        button = [[UIBarButtonItem alloc] initWithTitle: @"Game"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                 action: @selector(toolbarButtonPressed:)];
        [button setWidth: 58.0f];
        [buttons addObject: button];
        button = [[UIBarButtonItem alloc] initWithTitle: @"Options"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                 action: @selector(toolbarButtonPressed:)];
        //[button setWidth: 60.0f];
        [buttons addObject: button];
        button = [[UIBarButtonItem alloc] initWithTitle: @"Flip"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                action: @selector(toolbarButtonPressed:)];
        [button setWidth:34.0f];
        [buttons addObject: button];
        button = [[UIBarButtonItem alloc] initWithTitle: @"Move"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                 action: @selector(toolbarButtonPressed:)];
        [button setWidth: 53.0f];
        [buttons addObject: button];
        button = [[UIBarButtonItem alloc] initWithTitle: @"Hint"
                                                  style: UIBarButtonItemStyleBordered
                                                 target: self
                                                 action: @selector(toolbarButtonPressed:)];
        [button setWidth: 29.0f];
        [buttons addObject: button];
        
        [toolbar setItems: buttons animated: YES];
        [toolbar sizeToFit];
            
        } else if (iOSDeviceScreenSize.height == 480)
            {
                UIToolbar *toolbar =
                [[UIToolbar alloc]
                 initWithFrame: CGRectMake(0, 444, 320, 40)]; // 0.0f, 480.0f-64.0f, 320.0f, 64.0f//0, 449, 320, 40
                [self.view addSubview: toolbar];
                
                NSMutableArray *buttons = [[NSMutableArray alloc] init];
                UIBarButtonItem *button;
                
                button = [[UIBarButtonItem alloc] initWithTitle: @"Game"
                                                          style: UIBarButtonItemStyleBordered
                                                         target: self
                                                         action: @selector(toolbarButtonPressed:)];
                [button setWidth: 58.0f];
                [buttons addObject: button];
                button = [[UIBarButtonItem alloc] initWithTitle: @"Options"
                                                          style: UIBarButtonItemStyleBordered
                                                         target: self
                                                         action: @selector(toolbarButtonPressed:)];
                //[button setWidth: 60.0f];
                [buttons addObject: button];
                button = [[UIBarButtonItem alloc] initWithTitle: @"Flip"
                                                          style: UIBarButtonItemStyleBordered
                                                         target: self
                                                         action: @selector(toolbarButtonPressed:)];
                [button setWidth:34.0f];
                [buttons addObject: button];
                button = [[UIBarButtonItem alloc] initWithTitle: @"Move"
                                                          style: UIBarButtonItemStyleBordered
                                                         target: self
                                                         action: @selector(toolbarButtonPressed:)];
                [button setWidth: 53.0f];
                [buttons addObject: button];
                button = [[UIBarButtonItem alloc] initWithTitle: @"Hint"
                                                          style: UIBarButtonItemStyleBordered
                                                         target: self
                                                         action: @selector(toolbarButtonPressed:)];
                [button setWidth: 29.0f];
                [buttons addObject: button];
                
                [toolbar setItems: buttons animated: YES];
                [toolbar sizeToFit];
                
            }

        }
    

    
    self.gameMenu = [[UIActionSheet alloc] initWithTitle: @"Game"
                                                delegate: self
                                       cancelButtonTitle: @"Cancel"
                                  destructiveButtonTitle: nil
                                       otherButtonTitles:
                     
                     
                     //// Or add an alert view etc ... sav 3.21.14
                     @"New game", @"Game Options", @"About", @"Cancel", nil]; // @"E-mail game", @"Delete", @"Level/Game mode",@"Cancel", nil];
    
    self.startGameMenu = [[UIActionSheet alloc] initWithTitle: nil
                                                     delegate: self
                                            cancelButtonTitle: @"Cancel"
                                       destructiveButtonTitle: nil
                                            otherButtonTitles:
                          @"Play white", @"Play black", nil];
    self.moveMenu = [[UIActionSheet alloc] initWithTitle: nil
                                                delegate: self
                                       cancelButtonTitle: @"Cancel"
                                  destructiveButtonTitle: nil
                                       otherButtonTitles:
                     @"Take back", @"Step forward", @"Take back all", @"Step forward all", @"Move now",@"Cancel", nil];
    
    NSLog(@"ActionSheets loaded");
    

}

- (void)animateIcons
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        NSArray *iconArray = @[self.wildSquares, self.darkKnights, self.warOfQueens];
        self.imageNumber ++;
        if (self.imageNumber > [iconArray count]-1) self.imageNumber = 0; //-1
        self.whatEverIWant = [iconArray objectAtIndex:self.imageNumber];
        
        /// Flip Chess Revolt icons
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        
        transform.m34 = 5.0/1000.0;
        [animation setToValue:[NSValue valueWithCATransform3D:transform]];
        [animation setDuration:3]; //5
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //    [animation setFillMode:kCAFillModeBoth];
        [animation setRemovedOnCompletion:YES];
        //    [animation setDelegate:self];
        animation.repeatCount = 5;
        animation.cumulative = NO;
        
        
        [self.whatEverIWant.layer addAnimation:animation
                                        forKey:@"transform"];
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet title];
    
    NSLog(@"Menu: %@ selection: %d", title, buttonIndex);
    if (actionSheet == self.gameMenu || [title isEqualToString: @"Game"]) {
        UIActionSheet *menu;
        switch(buttonIndex) {
            case 0:
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    [self.startGameMenu showFromBarButtonItem: self.gameButton animated: YES];
                
                
                /// sav 3.13.14
                else {
                    menu =
                    [[UIActionSheet alloc] initWithTitle: @"New game"
                                                delegate: self
                                       cancelButtonTitle: @"Cancel"
                                  destructiveButtonTitle: nil
                                       otherButtonTitles:
                     @"Play white", @"Play black", nil];
                    [menu showInView: self.view];
                }
                break;
            case 1:
                [self showLevelsMenu];
                break;
            case 2:
                [self showAboutMenu];
                break;
            case 3:
                [self showEmailGameMenu];
                break;
            case 4:
                [self editPosition];
                break;
            case 5:
                [self showLevelsMenu];
                break;
            case 6:
                break;
            default:
                NSLog(@"Not implemented yet");
        }
    }
    else if (actionSheet == self.moveMenu || [title isEqualToString: @"Move"]) {
        switch(buttonIndex) {
            case 0: // Take back
                if ([[Options sharedOptions] displayMoveGestureTakebackHint])
                    [[[UIAlertView alloc] initWithTitle: @"Hint:"
                                                message: ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?
                                                          @"You can also take back moves by swiping your finger from right to left in the move list window." :
                                                          @"You can also take back moves by swiping your finger from right to left in the move list area below the board.")
                                               delegate: self
                                      cancelButtonTitle: nil
                                      otherButtonTitles: @"OK", nil] show];
                [self.gameController takeBackMove];
                break;
            case 1: // Step forward
                if ([[Options sharedOptions] displayMoveGestureStepForwardHint])
                    [[[UIAlertView alloc] initWithTitle: @"Hint:"
                                                message: ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?
                                                          @"You can also step forward in the game by swiping your finger from left to right in the move list window." :
                                                          @"You can also step forward in the game by swiping your finger from left to right in the move list area below the board.")
                                               delegate: self
                                      cancelButtonTitle: nil
                                      otherButtonTitles: @"OK", nil] show];
                [self.gameController replayMove];
                break;
            case 2: // Take back all
                [self.gameController takeBackAllMoves];
                break;
            case 3: // Step forward all
                [self.gameController replayAllMoves];
                break;
            case 4: // Move now
                if ([self.gameController computersTurnToMove]) {
                    if ([self.gameController engineIsThinking])
                        [self.gameController engineMoveNow];
                    else
                        [self.gameController engineGo];
                }
                else
                    [self.gameController startThinking];
                break;
            case 5:
                break;
            default:
                NSLog(@"Not implemented yet");
        }
    }
    else if (actionSheet == self.startGameMenu || [title isEqualToString: @"New game"]) {  /// changed new to startGame sav 3.13.14
        switch (buttonIndex) {
            case 0:
                NSLog(@"new game with white");
                [[Options sharedOptions] setGameMode:GAME_MODE_COMPUTER_BLACK];

//                [self.ccOptions setGameMode: GAME_MODE_COMPUTER_BLACK];
//                [self.gameController setGameMode: [[Options sharedOptions] gameMode]];
                [self startNewGame];
                
                break;
            case 1:
                NSLog(@"new game with black");
                [[Options sharedOptions] setGameMode: GAME_MODE_COMPUTER_WHITE];
//                [self.gameController setGameMode: GAME_MODE_COMPUTER_WHITE];
                [self startNewGame];
                
                
                break;
//            case 2:
//                NSLog(@"new game (both)");
//                [[Options sharedOptions] setGameMode: GAME_MODE_TWO_PLAYER];
//                [self.gameController setGameMode: GAME_MODE_TWO_PLAYER];
//                [self startNewGame];
//                break;
//            case 3:
//                NSLog(@"new game (analysis)");
//                
//                [[[UIAlertView alloc] initWithTitle: @"Analysis"
//                                            message: @"Has not been implemented yet"
//                                           delegate: self
//                                  cancelButtonTitle: nil
//                                  otherButtonTitles: @"OK", nil] show];
////                [[Options sharedOptions] setGameMode: GAME_MODE_ANALYSE];
////                [self.gameController setGameMode: GAME_MODE_ANALYSE];
////                [self startNewGame];
//                break;
//            default:
//                NSLog(@"not implemented yet");
        }
    }
}

- (void)toolbarButtonPressed:(id)sender {
    NSString *title = [sender title];
    
    // Ignore duplicate presses on the "Game" and "Move" buttons:
    if ([self.gameMenu isVisible] && [title isEqualToString: @"Game"])
        return;
    if ([self.moveMenu isVisible] && [title isEqualToString: @"Move"])
        return;
    
    
    // Dismiss action sheet popovers, if visible:
    if ([self.gameMenu isVisible] && ![title isEqualToString: @"Game"])
        [self.gameMenu dismissWithClickedButtonIndex: -1 animated: YES];
    if ([self.startGameMenu isVisible])
        [self.startGameMenu dismissWithClickedButtonIndex: -1 animated: YES];
    if ([self.moveMenu isVisible])
        [self.moveMenu dismissWithClickedButtonIndex: -1 animated: YES];
    if (self.optionsMenu != nil) {
        [self.optionsMenu dismissPopoverAnimated: YES];
        self.optionsMenu = nil;
    }
    if (self.levelsMenu != nil) {
        [self.levelsMenu dismissPopoverAnimated: YES];
        self.levelsMenu = nil;
    }
    if (self.saveMenu != nil) {
        [self.saveMenu dismissPopoverAnimated: YES];
        self.saveMenu = nil;
    }
    if (self.emailMenu != nil) {
        [self.emailMenu dismissPopoverAnimated: YES];
        self.emailMenu = nil;
    }
    if (self.loadMenu != nil) {
        [self.loadMenu dismissPopoverAnimated: YES];
        self.loadMenu = nil;
    }
    if (self.popoverMenu != nil) {
        [self.popoverMenu dismissPopoverAnimated: YES];
        self.popoverMenu = nil;
    }
    
    if ([title isEqualToString: @"Game"]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.gameMenu showFromBarButtonItem: sender animated: YES];
        }
        else {            //// Need to implement these Game menu options like email game etc.
            
            UIActionSheet *menu =
            [[UIActionSheet alloc]
             initWithTitle: @"Game"
             delegate: self
             cancelButtonTitle: @"Cancel"
             destructiveButtonTitle: nil
             otherButtonTitles:
             @"New Game", @"Game Options", @"About", nil]; /// @"E-mail game", @"Edit position", @"Level/Game mode", nil];
            [menu showInView: self.view];  /// removed content view sav 3.16.14
            //            menu = nil; // Arc repair Seth 12/30/13

            //            menu = nil; // Arc repair Seth 12/30/13
        }
    }
    else if ([title isEqualToString: @"Options"])
        [self showOptionsMenu];
    
    else if ([title isEqualToString: @"Flip"])
        [self.gameController rotateBoard];
    else if ([title isEqualToString: @"Move"]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.moveMenu showFromBarButtonItem: sender animated: YES];
        }
        else {
            UIActionSheet *menu =
            [[UIActionSheet alloc]
             initWithTitle: @"Move"
             delegate: self
             cancelButtonTitle: @"Cancel"
             destructiveButtonTitle: nil
             otherButtonTitles:
             @"Take back", @"Step forward", @"Take back all", @"Step forward all", @"Move now", nil];
            [menu showInView: self.view]; /// 3.14.14
            menu = nil; // Arc repair Seth 1.2.14
        }
    }
    else if ([title isEqualToString: @"Hint"])
        [self.gameController showHint];
    else if ([title isEqualToString: @"New"])
        [self.gameController startNewGame];
    else
        NSLog(@"%@", [sender title]);
}


- (void)startNewGame
{
    NSLog(@"startNewGame");
    
    [self.gameController replayAllMoves];  /// this might have fixed the move engine problem thing sav 3.21.14
    
    [self.boardView hideLastMove];
    [self.boardView stopHighlighting];
    self.ccGame = nil;  /// ** removed [game release] from stockfish ver /// seth 12.30.13
    
    //    self.boardView = nil;
    
    for (PieceImageView *piv in self.pieceViews)
        [piv removeFromSuperview];
    self.piv = nil; /// ** removed [pieceViews release] *** for ARC added nil. /// seth 12.30.13
    
    //// *** something needs to stop here and remove the pieceViews sav 3.20.14
    self.pieceViews = nil;
    [self.gameController takeBackAllMoves];
    /////// ****
    
    
    //    self.qwGame = [[Game alloc] initWithGameController: self];
    self.gameController.gameLevel = [[Options sharedOptions] gameLevel];
    self.gameController.gameMode = [[Options sharedOptions] gameMode];
    if ([[Options sharedOptions] isFixedTimeLevel])
        [self.ccGame setTimeControlWithFixedTime: [[Options sharedOptions] timeIncrement]];
    else
        [self.ccGame setTimeControlWithTime: [[Options sharedOptions] baseTime]
                                  increment: [[Options sharedOptions] timeIncrement]];
    
    [self.ccGame setWhitePlayer:
     ((self.gameController.gameMode == GAME_MODE_COMPUTER_BLACK)?
      [[[Options sharedOptions] fullUserName] copy] : ENGINE_NAME)];
    [self.ccGame setBlackPlayer:
     ((self.gameController.gameMode == GAME_MODE_COMPUTER_BLACK)?
      ENGINE_NAME : [[[Options sharedOptions] fullUserName] copy])];
    
    
    // NOt sure how to fix this sav 3.21.14
    //    self.pieceViews = [[NSMutableArray alloc] init];  /// lazy instantiate? sav 3.21.14
    
    self.pendingFrom = SQ_NONE;
    self.pendingTo = SQ_NONE;
    
    [self.moveListView setText: @""];
    [self.analysisView setText: @""];
    [self.searchStatsView setText: @""];
    [self.gameController showPiecesAnimate: NO];
    self.engineIsPlaying = NO;
    [self.engineController abortSearch];
    [self.engineController sendCommand: @"ucinewgame"];
    [self.engineController sendCommand:
     [NSString stringWithFormat:
      @"setoption name Play Style value %@",
      [[Options sharedOptions] playStyle]]];
    
    if ([[Options sharedOptions] strength] == 2500) // Max strength
        [self.engineController
         sendCommand: @"setoption name UCI_LimitStrength value false"];
    else
        [self.engineController
         sendCommand: @"setoption name UCI_LimitStrength value true"];
    
    [self.engineController commitCommands];
    
    if ([self.remoteEngineController isConnected])
        [self.remoteEngineController sendToServer: @"n\n"];
    
    [self.gameController showBookMoves];
    
    
    // Move the Friggn King
#warning  fix this
    
    [self.gameController randomKingLocations];
    
    // Rotate board if the engine plays white:
    //    if (! self.rotated && [self.gameController computersTurnToMove])
    //        [self.gameController rotateBoard];
    
    [self.gameController engineGo];
    
    //// I added this
    [self.gameController redrawPieces];
}


- (void)showSaveGameMenu
{
    
    //// My code sav 3.20.14
   /* if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.saveMenu = [[UIPopoverController alloc] initWithContentViewController: self.ccSaveGameNC];
        [self.saveMenu presentPopoverFromBarButtonItem: self.gameButton
                              permittedArrowDirections: UIPopoverArrowDirectionAny
                                              animated: YES];
        
        
    } else {
        CGRect r = [[self.ccSaveGameNC view] frame];
        //        // Why do I suddenly have to use -20.0f for the Y coordinate below?
        //        // 0.0f seems right, and used to work in SDK 2.x.
        r.origin = CGPointMake(0.0f, 20.0f);
        [[self.ccSaveGameNC view] setFrame: r];
        [self.view insertSubview: [self.ccSaveGameNC view] atIndex: 0];
        [self.view bringSubviewToFront:self.ccSaveGameNC.view];
        [self flipSubviewsLeft];
    }*/
}

/// *** Button Actions *** /////

- (void)showLoadGameMenu
{
    //    LoadFileListController *lflc =
    //    [[LoadFileListController alloc] initWithBoardViewController: self];
    //    navigationController =
    //    [[UINavigationController alloc] initWithRootViewController: lflc];
    //    //  [lflc ];
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        loadMenu = [[UIPopoverController alloc]
    //                    initWithContentViewController: navigationController];
    //        [loadMenu presentPopoverFromBarButtonItem: gameButton
    //                         permittedArrowDirections: UIPopoverArrowDirectionAny
    //                                         animated: YES];
    //    }
    //    else {
    //        CGRect r = [[navigationController view] frame];
    //        // Why do I suddenly have to use -20.0f for the Y coordinate below?
    //        // 0.0f seems right, and used to work in SDK 2.x.
    //        r.origin = CGPointMake(0.0f, -20.0f);
    //        [[navigationController view] setFrame: r];
    //        [rootView insertSubview: [navigationController view] atIndex: 0];
    //        [rootView flipSubviewsLeft];
    //    }
}

- (void)showEmailGameMenu
{
    //    GameDetailsTableController *gdtc =
    //    [[GameDetailsTableController alloc]
    //     initWithBoardViewController: self
    //     game: [gameController game]
    //     email: YES];
    //    navigationController =
    //    [[UINavigationController alloc] initWithRootViewController: gdtc];
    //    //  [gdtc ];
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        emailMenu = [[UIPopoverController alloc]
    //                     initWithContentViewController: navigationController];
    //        [emailMenu presentPopoverFromBarButtonItem: gameButton
    //                          permittedArrowDirections: UIPopoverArrowDirectionAny
    //                                          animated: YES];
    //    }
    //    else {
    //        CGRect r = [[navigationController view] frame];
    //        // Why do I suddenly have to use -20.0f for the Y coordinate below?
    //        // 0.0f seems right, and used to work in SDK 2.x.
    //        r.origin = CGPointMake(0.0f, -20.0f);
    //        [[navigationController view] setFrame: r];
    //        [rootView insertSubview: [navigationController view] atIndex: 0];
    //        [rootView flipSubviewsLeft];
    //    }
}

- (void)editPosition
{
    //    SetupViewController *svc =
    //    [[SetupViewController alloc]
    //     initWithBoardViewController: self
    //     fen: [[gameController game] currentFEN]];
    //    navigationController =
    //    [[UINavigationController alloc] initWithRootViewController: svc];
    //    svc = nil;  // ARC repair Seth 1.2.14
    //
    //
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        popoverMenu = [[UIPopoverController alloc]
    //                       initWithContentViewController: navigationController];
    //        //[popoverMenu setPopoverContentSize: CGSizeMake(320.0f, 460.0f)];
    //        [popoverMenu presentPopoverFromBarButtonItem: gameButton
    //                            permittedArrowDirections: UIPopoverArrowDirectionAny
    //                                            animated: NO];
    //    }
    //    else {
    //        CGRect r = [[navigationController view] frame];
    //        // Why do I suddenly have to use -20.0f for the Y coordinate below?
    //        // 0.0f seems right, and used to work in SDK 2.x.
    //        r.origin = CGPointMake(0.0f, -20.0f);
    //        [[navigationController view] setFrame: r];
    //        [rootView insertSubview: [navigationController view] atIndex: 0];
    //        [rootView flipSubviewsLeft];
    //    }
}

- (void)showLevelsMenu
{
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {  /// sav 4.9.14
        self.levelsMenu = [[UIPopoverController alloc]
                           initWithContentViewController: self.gameOptions];
        [self.levelsMenu presentPopoverFromBarButtonItem: self.gameButton
                                permittedArrowDirections: UIPopoverArrowDirectionAny
                                                animated: YES];
    } else {
        CGRect rect = [[self.gameOptions view] frame];
        rect.origin = CGPointMake(0.0f, 20.0f);
        [[self.gameOptions view] setFrame: rect];
        [self.view insertSubview: [self.gameOptions view] atIndex: 0];
        [self flipSubviewsRight];
        [self.view bringSubviewToFront:self.gameOptions.view];
    }
}

- (void)levelsMenuDonePressed {
    NSLog(@"options menu done");
    
    if ([[Options sharedOptions] gameLevelWasChanged])
        [self.gameController setGameLevel: [[Options sharedOptions] gameLevel]];
    if ([[Options sharedOptions] gameModeWasChanged])
        [self.gameController setGameMode: [[Options sharedOptions] gameMode]];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.levelsMenu dismissPopoverAnimated: YES];
        //    [levelsMenu ];
        self.levelsMenu = nil;
    }
    else {
        [self flipSubviewsRight];
        [[self.gameOptions view] removeFromSuperview];
        [[self.gameOptions view] removeFromSuperview];
    }
    self.gameOptions = nil; // ARC repair Seth 1.2.14
    self.LevelController = nil;
    
}


- (void)showAboutMenu
{
    self.aboutController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
    self.aboutController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:self.aboutController animated:YES completion:nil];
}

- (void)showOptionsMenu
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.optionsMenu = [[UIPopoverController alloc] initWithContentViewController:self.ccNC];
        [self.optionsMenu presentPopoverFromBarButtonItem:self.optionsButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        
        CGRect rect = [[self.ccNC view] frame];
        rect.origin = CGPointMake(0.0f, 20.0f);
        [[self.ccNC view] setFrame:rect];
        [self.view insertSubview:[self.ccNC view] atIndex:0];
        [self flipSubviewsLeft];
        [self.view bringSubviewToFront:self.ccNC.view];

    }
}
- (void)optionsMenuDonePressed
{
        NSLog(@"options menu done");
        if ([[Options sharedOptions] bookVarietyWasChanged])
            [self.gameController showBookMoves];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.optionsMenu dismissPopoverAnimated: YES];
            //  [optionsMenu ];
            self.optionsMenu = nil;
        }
        else {
            [self flipSubviewsRight];
            [[self.ccNC view] removeFromSuperview];
        }
        //        navigationController = nil; // ARC repair Seth 1.2.14
}


//    self.ccNC =
//    [[UINavigationController alloc]
//     initWithRootViewController: self.ccOVC];
//    // [ovc ];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        self.optionsMenu = [[UIPopoverController alloc]
//                            initWithContentViewController: self.navigationController];
//        [self.optionsMenu presentPopoverFromBarButtonItem: self.optionsButton
//                                 permittedArrowDirections: UIPopoverArrowDirectionAny
//                                                 animated: YES];
//    }
//    else {
//        CGRect r = [[self.navigationController view] frame];
//        // Why do I suddenly have to use -20.0f for the Y coordinate below?
//        // 0.0f seems right, and used to work in SDK 2.x.
//        r.origin = CGPointMake(0.0f, -20.0f);
//        [[self.navigationController view] setFrame: r];
//        [self.view insertSubview: [self.ccOVC view] atIndex: 0];
//        [self.rootView flipSubviewsLeft];


- (void)flipSubviewsLeft {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations: nil context: context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft
                           forView: self.view cache: YES];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 1.0];
    [self.view exchangeSubviewAtIndex: 0 withSubviewAtIndex: 1];
    [UIView commitAnimations];
}

- (void)flipSubviewsRight {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations: nil context: context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight
                           forView: self.view cache: YES];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 1.0];
    [self.view exchangeSubviewAtIndex: 0 withSubviewAtIndex: 1];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
