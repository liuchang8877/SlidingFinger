//
//  TestViewController.h
//  DroppableViewTest
//
//  Created by liu on 12-11-21.
//  email: liuchang8877@gmail.com
//

#import "JDDroppableView.h"
@class  UserScore;
@class JDGroupedFlipNumberView;
@interface TestViewController : UIViewController <JDDroppableViewDelegate>
{
    UIScrollView* mScrollView;
    UIView* mDropTarget;
    
    CGPoint mLastPosition;
    BOOL   mSmall;
    UserScore *myScore;
    UILabel * scoreLabel;
    UILabel * timeLabel;
    int   newScore;
    int   leftTime;
    BOOL  flagWin;
    
    JDGroupedFlipNumberView *flipViewTime;
    JDGroupedFlipNumberView *flipViewScore;
}

- (void) relayout;
- (void) makeSmall;
- (void) addAllView: (NSNumber *) count;
- (void) scrollToBottomAnimated: (BOOL) animated;
- (void) handleTimer;
- (void) exitAll;
@end

