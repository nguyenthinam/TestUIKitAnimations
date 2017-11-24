//
//  ViewController.m
//  Test
//
//  Created by Nam Nguyen on 5/25/17.
//  Copyright © 2017 Nam Nguyen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (nullable, nonatomic, strong) NSData *gifData;
@property (nullable, nonatomic, strong) NSArray *houseImages;

@end

@implementation ViewController

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"%s [Line %d] Time: %f", __PRETTY_FUNCTION__, __LINE__, -[startTime timeIntervalSinceNow])

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    CGFloat displayableWidth = 245.0;
    NSInteger originX = floorf((self.view.bounds.size.width - displayableWidth) / 2.0);
   
//    self.gifData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"houses" withExtension:@"gif"]];
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)self.gifData, NULL);
//    size_t count = CGImageSourceGetCount(source);
//
//    UIImage *poster = [self imageAtIndex:0 source:source];
//    CFRelease(source);
    
    self.houseImages = @[@"house-1.tiff", @"house-2.tiff", @"house-3.tiff", @"house-4.tiff", @"house-5.tiff", @"house-6.tiff"];
    UIImage *poster = [UIImage imageNamed:self.houseImages[0]];
    
    // Do any additional setup after loading the view, typically from a nib.
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(originX, 40.0, displayableWidth, 10.0)];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    slider.backgroundColor = [UIColor clearColor];
    slider.minimumValue = 0.0;
    slider.maximumValue = [self.houseImages count] - 1;//count - 1;
    slider.continuous = YES;
    slider.value = 0.0;
    [self.view addSubview:slider];
    
    self.imageView = [[UIImageView alloc] initWithImage:poster];
    self.imageView.frame = CGRectMake(originX, 80.0, displayableWidth, 206.0);
    [self.view addSubview:self.imageView];
}

- (void)sliderAction:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float value = slider.value;
    
//    [self presentImageAtIndex:(int)value];
    
    UIImage *animatedImage = [UIImage imageNamed:self.houseImages[(int)value]];
    [self presentImage:animatedImage animated:YES];
}

#pragma mark - Normal Images

- (void)presentImage:(UIImage *)animatedImage animated:(BOOL)animated {
    if (!animated) {
        self.imageView.image = animatedImage;
    } else {
        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                //Animations
                                self.imageView.image = animatedImage;
                            }
                         completion:^(BOOL finished) {
                             //Completion Block
                         }];
        
        /*
        self.imageView.image = animatedImage;
        
        CGPoint origin = self.imageView.center;
        CGPoint target = CGPointMake(self.imageView.center.x+10, self.imageView.center.y);
        CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
        bounce.duration = 0.5;
        bounce.fromValue = [NSNumber numberWithInt:origin.x];
        bounce.toValue = [NSNumber numberWithInt:target.x];
        bounce.repeatCount = 1;
        bounce.autoreverses = YES;
        [self.imageView.layer addAnimation:bounce forKey:@"position"];
        */
    }
}

#pragma mark - GIF Image

- (void)presentImageAtIndex:(NSInteger)index {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)self.gifData, NULL);
    UIImage *animatedImage = [self imageAtIndex:index source:source];
    CFRelease(source);
    
    self.imageView.image = animatedImage;
}

- (UIImage *)imageAtIndex:(NSInteger)index source:(CGImageSourceRef)source {
    CGImageRef image = CGImageSourceCreateImageAtIndex(source, index, NULL);
    UIImage *animatedImage = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
    CGImageRelease(image);
    
    return animatedImage;
}

@end
