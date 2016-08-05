//
//  CustomImageView.m
//  CicularImageLoader
//
//  Created by Rohit Yadav on 05/08/16.
//  Copyright © 2016 iAppstreet. All rights reserved.
//

#import "CustomImageView.h"

#import "UIImageView+WebCache.h"
#import "CircularLoaderView.h"

@interface CustomImageView()

@property (nonatomic, strong) CircularLoaderView *progressView;

@end


@implementation CustomImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure{
    
    _progressView = [[CircularLoaderView alloc]initWithFrame:CGRectZero];
    [self addSubview:_progressView];
    
    NSURL *url = [NSURL URLWithString:@"https://www.raywenderlich.com/wp-content/uploads/2015/02/mac-glasses.jpeg"];
    
    
    __weak typeof (self) weakSelf = self;
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        weakSelf.progressView.progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.progressView reveal];
    }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _progressView.frame = self.bounds;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth/UIViewAutoresizingFlexibleHeight;
}

@end
