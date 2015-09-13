//
//  LazyLoadingImageView.m
//  Cookie
//
//  Created by Kaustubh on 13/09/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

#import "LazyLoadingImageView.h"
#import "HTTPManager.h"

@interface LazyLoadingImageView()

@property (nonatomic, strong )NSString *imageName;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *imageReference;

@end

@implementation LazyLoadingImageView




- (id)initWithImageUrlString:(NSString*)urlString
{
    if(self=[super init]){
        if(urlString.length!=0)
        {
            _imageName = [[urlString pathComponents] lastObject];
            _urlString=urlString;
        }
    }
    return self;
}
-(void)setURLString:(NSString*)urlstr
{
    _urlString=urlstr;
    _imageName = [[urlstr pathComponents] lastObject];
    [self loadImage];
}

- (void)saveImage:(NSData *)imageData
{
    UIImage *image=[UIImage imageWithData:imageData];
    NSString *path=[NSString stringWithFormat:@"Documents/%@", _imageName];
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    self.image=image;
}

- (void)loadImage{
    __weak LazyLoadingImageView *weakSelf=self;
    NSString *imagePath = [self imagePath];
    
    if(imagePath)
    {
        self.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    }
    else
    {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.alpha = 1.0;
        activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        activityIndicator.hidesWhenStopped = YES;
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];
        HTTPManager *sharedManager=[HTTPManager sharedManager];
        if(_imageReference.length>0)
        {
            [sharedManager sendRequestForURL:_urlString Success:^(NSData *data)
             {
                 [weakSelf saveImage:data];
                 [activityIndicator stopAnimating];
             }
                Failure:^(NSError *error)
             {
                 
             }];
        }
        else
        {
            [sharedManager sendRequestForURL:_urlString Success:^(NSData *data)
             {
                 [weakSelf saveImage:data];
                 [activityIndicator stopAnimating];
             }
                Failure:^(NSError *error)
             {
                 
             }];
        }
    }
}

- (NSString *)imagePath
{
    NSString *path=[NSString stringWithFormat:@"Documents/%@", _imageName];
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    
    if (!fileExists) {
        imagePath=nil;
    }
    return imagePath;
}

-(void)setImageReference:(NSString*)reference
{
    _imageReference=reference;
    _imageName=reference;
    [self loadImage];
}


@end
