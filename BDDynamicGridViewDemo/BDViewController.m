//
//  BDViewController.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define IsIphone UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define kdefaultBorderWidth 5
#define kNumberOfPhotos 25

#import "BDViewController.h"
//#import "BDViewController+Private.h"
#import "BDRowInfo.h"
#import <QuartzCore/QuartzCore.h>

@interface BDViewController (){
    NSArray * _items;
}
@property (nonatomic,strong) UIView *mainView;

@end

@implementation BDViewController

@synthesize mainView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.delegate = self;
    
    self.onLongPress = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Long press on %@, at %d", view, viewIndex);
    };

    self.onDoubleTap = ^(UIView* view, NSInteger viewIndex){
        NSLog(@"Double tap on %@, at %d", view, viewIndex);
    };
    
    __weak BDViewController *weakSelf = self;
    self.onSingleTapWithRect = ^(UIView* view, NSInteger viewIndex, CGRect rect)
    {
        [weakSelf onSingleTapMethod:view index:viewIndex rect:rect];
        
        
        
    };
    [self _demoAsyncDataLoading];
    [self buildBarButtons];
}

-(void)onSingleTapMethod:(UIView *)view index:(NSInteger)viewIndex rect:(CGRect)rect
{
    if (self.mainView)
       [self.mainView removeFromSuperview];
    //NSLog(@"Single tap on %@, at %d", view, viewIndex);
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,250,250)];
    //NSLog(@"%@", NSStringFromCGRect(rect));
    CGFloat width, height, defaultWidth, defaultHeight;
    //Set default size for iphone and ipad, still need adjust based on image size
    if (IsIphone){
        width = 250.0f;
        height = 250.0f;
        defaultWidth = 250.0f;
        defaultHeight = 250.0f;
    } else {
        width = 300.0f;
        height = 300.0f;
        defaultWidth = 300.0f;
        defaultHeight = 300.0f;
    }

    CGFloat rowY = rect.origin.y;
    CGFloat intelx, intely;

    NSLog(@"origin x = %f, origin y = %f, width = %f, height = %f", view.frame.origin.x, rowY, view.frame.size.width, view.frame.size.height);
    
    //If the image is full width
    if (view.frame.size.width + 2 * kdefaultBorderWidth >= self.view.frame.size.width){
        width = self.view.frame.size.width - kdefaultBorderWidth;
    //If the image width is bigger than the default width
    } else if (view.frame.size.width > defaultWidth){
        width = view.frame.size.width;
    } else {
        width = defaultWidth;
    }
    
    if (view.frame.size.width + 2 * kdefaultBorderWidth >= self.view.frame.size.width) {
        intelx = kdefaultBorderWidth;
    } else if (view.frame.origin.x + width > self.view.frame.size.width && view.frame.origin.x + view.frame.size.width - width > 0){
        NSLog(@"Right");
        intelx = view.frame.origin.x + view.frame.size.width - width - kdefaultBorderWidth;
        width += kdefaultBorderWidth * 2;
    //if the origin x is too left
    } else if (view.frame.origin.x - width < 0 && view.frame.origin.x + width < self.view.frame.size.width){
        NSLog(@"Left");
        intelx = view.frame.origin.x - kdefaultBorderWidth;
        width += kdefaultBorderWidth * 2;
    } else {
        NSLog(@"Center");
        intelx = view.frame.origin.x + view.frame.size.width/2  - width/2 - kdefaultBorderWidth;
        width += kdefaultBorderWidth * 2;
    }
    
//    NSLog(@"%f" ,rowY);
//    NSLog(@"phone frame size: %f", self.view.frame.size.height);
    if (rowY + height > self.view.frame.size.height && rowY + view.frame.size.height - height > 0){
        NSLog(@"Bottom");
        intely = rowY + view.frame.size.height - height + kdefaultBorderWidth;
        
        //if the origin x is too left
    } else if (rowY - height < 0 && rowY + height < self.view.frame.size.height){
        NSLog(@"Top");
        intely = rowY - kdefaultBorderWidth;
    } else {
        NSLog(@"Middle");
        intely = rowY + view.frame.size.height/2  - height/2 - kdefaultBorderWidth;
    }
    NSLog(@"intelx: %f, intely: %f, width: %f, height: %f", intelx, intely, width, height);
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(intelx, intely, width, height)];
    
    //Add the image view
    self.mainView.layer.borderColor=[UIColor blackColor].CGColor;
    self.mainView.layer.borderWidth=5.0f;
    UIImageView * imageview = (UIImageView *)view;
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:imageview.image];
    backImageView.frame = self.mainView.bounds;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.clipsToBounds=YES;
    [self.mainView addSubview:backImageView];
    
    
    //Add the text view
    UIView * textview = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainView.frame.size.height - 80, self.mainView.frame.size.width, 62)];
    textview.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.6];
    UILabel * placeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, mainView.frame.size.width-10, 24)];
    UILabel * placeAddress = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, mainView.frame.size.width-10, 34)];
    placeAddress.textAlignment=UITextAlignmentRight;
    placeTitle.textAlignment=UITextAlignmentRight;
    placeTitle.backgroundColor = [UIColor clearColor];
    placeAddress.backgroundColor = [UIColor clearColor];
    placeTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0f];
    placeAddress.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    placeTitle.textColor = [UIColor whiteColor];
    placeAddress.textColor = [UIColor whiteColor];
    placeTitle.text = @"The ICON";
    placeAddress.text = @"The Placety HQ";
    [textview addSubview:placeTitle];
    [textview addSubview:placeAddress];
    [self.mainView addSubview:textview];
    
    //Always put button at the bottom to avoid layer conflict
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=self.mainView.bounds;
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(singleTapOnMainView) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:button];
    
    CGAffineTransform trans = CGAffineTransformScale(self.mainView.transform, 0.01, 0.01);
    self.mainView.alpha = 0.0;
    self.mainView.transform = trans;	// do it instantly, no animation
    [self.view addSubview:self.mainView];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.mainView.alpha = 1.0;
                         self.mainView.transform = CGAffineTransformScale(self.mainView.transform, 100.0, 100.0);
                     }
                     completion:nil];

}
- (void)singleTapOnMainView
{
	[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mainView.transform = CGAffineTransformScale(self.mainView.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finished) {
                         [self.mainView removeFromSuperview];
                     }];
}

- (void)animateReload
{
    _items = [NSArray new];
    [self _demoAsyncDataLoading];
}

- (NSUInteger)numberOfViews
{
    return _items.count;
}

-(NSUInteger)maximumViewsPerCell
{
    return 5;
}

- (UIView *)viewAtIndex:(NSUInteger)index rowInfo:(BDRowInfo *)rowInfo
{
    UIImageView * imageView = [_items objectAtIndex:index];
    return imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //Call super when overriding this method, in order to benefit from auto layout.
    [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    return YES;
}

- (CGFloat)rowHeightForRowInfo:(BDRowInfo *)rowInfo
{
//    if (rowInfo.viewsPerCell == 1) {
//        return 125  + (arc4random() % 55);
//    }else {
//        return 100;
//    }
    return 55 + (arc4random() % 125);
}

-(void)buildBarButtons
{
    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"Lay it!"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(animateReload)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: reloadButton, nil];
    
}

-(NSArray*)_imagesFromBundle
{
    NSArray *images = [NSArray array];
    NSBundle *bundle = [NSBundle mainBundle];
    for (int i=0; i< kNumberOfPhotos; i++) {
        NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%d", i + 1] ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            images = [images arrayByAddingObject:image];
        }
    }
    return images;
}


- (void)_demoAsyncDataLoading
{
    _items = [NSArray array];
    //load the placeholder image
    for (int i=0; i < kNumberOfPhotos; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
        imageView.frame = CGRectMake(0, 0, 44, 44);
        imageView.clipsToBounds = YES;
        _items = [_items arrayByAddingObject:imageView];
    }
    [self reloadData];
    NSArray *images = [self _imagesFromBundle];
    for (int i = 0; i < images.count; i++) {
        UIImageView *imageView = [_items objectAtIndex:i];
        UIImage *image = [images objectAtIndex:i];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        [self performSelector:@selector(animateUpdate:)
                   withObject:[NSArray arrayWithObjects:imageView, image, nil]
                   afterDelay:0.2 + (arc4random()%3) + (arc4random() %10 * 0.1)];
    }
}

- (void) animateUpdate:(NSArray*)objects
{
    UIImageView *imageView = [objects objectAtIndex:0];
    UIImage* image = [objects objectAtIndex:1];
    [UIView animateWithDuration:0.5
                     animations:^{
                         imageView.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         imageView.image = image;
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              imageView.alpha = 1;
                                          } completion:^(BOOL finished) {
                                              NSArray *visibleRowInfos =  [self visibleRowInfos];
                                              for (BDRowInfo *rowInfo in visibleRowInfos) {
                                                  [self updateLayoutWithRow:rowInfo animiated:YES];
                                              }
                                          }];
                     }];
}

@end
