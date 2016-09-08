//
//  CVWrapper.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import "UIImage+OpenCV.h"
#import "dewarp.hpp"

@implementation OpenCVWrapper

+ (UIImage*) processImage: (UIImage*) inputImage
{

    cv::Mat matImage = [inputImage CVMat];


    cv::Mat dewarped = Defish(matImage);
    UIImage *outputImage = [UIImage imageWithCVMat:dewarped];

    CGRect cropRect = CGRectMake(0, 78, outputImage.size.width, outputImage.size.height - 78);
    CGImageRef croppedCG2 = CGImageCreateWithImageInRect([outputImage CGImage], cropRect);
    UIImage *finalImage = [UIImage imageWithCGImage:croppedCG2];

    CGImageRelease(croppedCG2);

    return finalImage;
}

@end
