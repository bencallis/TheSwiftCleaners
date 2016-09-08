//
//  dewarp.cpp
//  DysonWars
//
//  Created by Matthew Holgate on 08/09/2016.
//  Copyright © 2016 Ben Callis. All rights reserved.
//

#include "dewarp.hpp"

/*
 * starter_video.cpp
 *
 *  Created on: Nov 23, 2010
 *      Author: Ethan Rublee
 *
 *  Modified on: April 17, 2013
 *      Author: Kevin Hughes
 *
 * A starter sample for using OpenCV VideoCapture with capture devices, video files or image sequences
 * easy as CV_PI right?
 */

#include <opencv2/imgcodecs.hpp>
#include <opencv2/videoio/videoio.hpp>
#include <opencv2/highgui/highgui.hpp>
#include "opencv2/imgproc/imgproc.hpp"

#include <iostream>
#include <stdio.h>

using namespace cv;
using namespace std;

//hide the local functions in an anon namespace

    // References: git@github.com:kscottz/dewarp.git and git@github.com:panovr/defish.git
static void build_map(int width, int height, Mat & map_x, Mat & map_y) {
    const auto PI = 3.1415926;
    const auto midx = width / 2;
    const auto midy = height / 2;
    const auto maxmag = max(midx, midy);
    const auto circum = 2 * PI * maxmag;

    map_x.create(static_cast<int>(maxmag), static_cast<int>(circum), CV_32FC1);
    map_y.create(static_cast<int>(maxmag), static_cast<int>(circum), CV_32FC1);
    for(int j = 0; j < static_cast<int>(maxmag); j++) {
        for(int i = 0; i < static_cast<int>(circum); i++) {
            const auto r = static_cast<float>(j);
            const auto theta = (static_cast<float>(i) / maxmag);
            const auto xs = midx - r * sin(theta);
            const auto ys = midy - r * cos(theta);
            map_x.at<float>(j, i) = xs;
            map_y.at<float>(j, i) = ys;
            //map_x.at<float>(j, i) = i;
            //map_y.at<float>(j, i) = j;
        }
    }
}

Mat Defish(Mat frame) {
    Mat remappedFrame;
    Mat map_x, map_y;

    build_map(frame.cols, frame.rows, map_x, map_y);

    remap(frame, remappedFrame, map_x, map_y, CV_INTER_LINEAR);

    return remappedFrame;

}


