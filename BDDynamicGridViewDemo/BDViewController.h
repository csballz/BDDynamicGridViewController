//
//  BDViewController.h
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDDynamicGridViewController.h"
@interface BDViewController : BDDynamicGridViewController <BDDynamicGridViewDelegate>

- (void) _demoAsyncDataLoading;
- (void) buildBarButtons;

@end
