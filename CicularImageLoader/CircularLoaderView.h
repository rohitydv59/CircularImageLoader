//
//  CircularLoaderView.h
//  CicularImageLoader
//
//  Created by Rohit Yadav on 05/08/16.
//  Copyright © 2016 iAppstreet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularLoaderView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)reveal;

@end
