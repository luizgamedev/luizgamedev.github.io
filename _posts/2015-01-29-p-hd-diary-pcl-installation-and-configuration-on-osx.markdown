---
title: "P.hD Diary - PCL Installation and Configuration on OSX"
modified:
categories: PhD
excerpt: "Compile! Compile! Compile!"
tags: [PCL, Facial Animation, PhD]
comments: true
image:
  feature:
date: 2015-01-29T21:02:44-02:00
---

As a part of my investigatory phase right now I was looking for good libraries that work good with Kinect. My personal computer is an old pacman Macbook Pro that is been very good thru all these years.  In this post I’ll explain how to setup a Mac properly to use PCL libraries ( no nostalgic posts right now ). For more information about the library itself visit <a href="http://pointclouds.org/">http://pointclouds.org/</a>. This tutorial was done in a machine with OSX 10.10 ( Yosemite ), 4GB DDR3 memory and a Core2Duo Processor. Differences for different configurations may happen.

<iframe width="420" height="315" src="https://www.youtube.com/embed/x3SaWQkPsPI" frameborder="0" allowfullscreen></iframe>
PCL Kinect Example

My biggest challenge here was to see which of the (old) tutorials [ <a href="http://pointclouds.org/downloads/macosx.html">1</a>, <a href="http://www.pcl-users.org/file/n4022018/PCL_Development_Build_-_Mac_OS_X.pdf">2</a>, <a href="https://github.com/totakke/homebrew-openni2">3</a>, <a href="http://www.pointclouds.org/documentation/tutorials/installing_homebrew.php">4</a>, <a href="http://digitizor.com/2014/06/29/fix-cowardly-refusing-sudo-error-brew/">5</a>, among others... ] I’ve found was technically right. Before anyone say that solve this in other way, I’d say that this was the simpler one that choose. I do love free libraries and collaborative softwares, but I prefer to get a very good closed and tested package with all the dependencies configured rather then compile all in a hard way. This solution tries to rely as much as possible in brew ( a package manager for OSX ), and cmake. There are other solutions that use macports and/or manual compilation. I found these harder than using brew.

## Assumptions

I assume that everyone here has a Mac with Xcode installed and configured. Also, you must ( If you haven’t already ) have the Command Line Tools installed. If you don’t, download Xcode via App Store, then create a developer account at <a href="http://developer.apple.com">Apple Developer Website</a>, go to the  <a href="https://developer.apple.com/downloads/index.action">download section</a> and get the pkg to install. Its installation is purely straightforward.

## Brew Packages

### Installing Brew

First things first, lets install brew. It pretty simple, just open a terminal window and type:

{% highlight bash lineos %}
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
{% endhighlight %}

This will automatically get and install all the necessary binaries to run the package. After installing, I’ve made a simple config to use sudo with brew because of some permission errors I was having in my machine. This is totally optional, but if you face these problems just type:

{% highlight bash lineos %}
sudo chown root:wheel `which brew`
{% endhighlight %}

### Installing PCL Dependencies

Before installing PCL, there are some dependencies that you must install ( and make sure that they are properly linked ). They are:

* Boost 1.57
* Flann 1.8.4
* Qt 4.8.6
* GLEW 1.11
* VTK 6.1.0
* Openni 1.5.8 and 2

One of the good things of using a package manager is that is easy to find and trigger an installation of all these dependencies. In brew, you must “tap” two repositories and before installing these packages. The commands are:

{% highlight bash lineos %}
sudo brew update
sudo brew tap homebrew/science
sudo brew tap totakke/openni2
{% endhighlight %}

It will download some git repositories with information about those packages. Finally, to install the dependencies just type:

{% highlight bash lineos %}
sudo brew install -vd sip pyqt libusb cmake boost flann qhull glew qt vtk openni openni2 openni2-freenectdriver
{% endhighlight %}

It will take a long time, enjoy a good book in the middle time =)

### PCL Install

Similar to the previous step, now we just have to tell brew to install PCL with the command:

{% highlight bash lineos %}
sudo brew install -vd pcl --HEAD --with-openni --with-examples
{% endhighlight %}

Just a little parentheses here. The option "—HEAD” says that it gonna get the HEAD of PCL repository, which is now PCL 1.8. In their website, the downloadable version is 1.6. I had a lot of trouble using the 1.6 under Yosemite, so I do not recommend using it. The “--with-openni” option will assume that you’re gonna use this library with PCL ( which is optional, but mandatory if you’d like to use Kinect Viewer ).

Again, grab a good book and wait for a long compile time.

## Post Configs

If everything went well ( and I hope it did ), there’s some post configs you must do. For OpenNi 2 libs you must export some environments vars using:

{% highlight bash lineos %}
export OPENNI2_INCLUDE=/usr/local/include/ni2
export OPENNI2_REDIST=/usr/local/lib/ni2
{% endhighlight %}

You might want to put these commands on your ~/.bash_profile as well to avoid doing this command again.

## Building and Testing

Following the <a href="http://pointclouds.org/documentation/tutorials/openni_grabber.php#openni-grabber">Kinect Example</a> found in their site, and making some few modifications, lets make a simple test just to show Kinect’s video. Create a file called open_viewer_simple.cpp with the following code:

{% highlight cpp lineos %}
#include <pcl/io/openni_grabber.h>
#include <pcl/visualization/cloud_viewer.h>

 class SimpleOpenNIViewer
 {
   public:
     SimpleOpenNIViewer () : viewer ("PCL OpenNI Viewer") {}

     void cloud_cb_ (const pcl::PointCloud<pcl::PointXYZ>::ConstPtr &cloud)
     {
       if (!viewer.wasStopped())
         viewer.showCloud (cloud);
     }

     void run ()
     {
       pcl::Grabber* interface = new pcl::OpenNIGrabber();

       boost::function<void (const pcl::PointCloud<pcl::PointXYZ>::ConstPtr&)> f =
         boost::bind (&SimpleOpenNIViewer::cloud_cb_, this, _1);

       interface->registerCallback (f);

       interface->start ();

       while (!viewer.wasStopped())
       {
         boost::this_thread::sleep (boost::posix_time::seconds (1));
       }

       interface->stop ();
     }

     pcl::visualization::CloudViewer viewer;
 };

 int main ()
 {
   SimpleOpenNIViewer v;
   v.run ();
   return 0;
 }
{% endhighlight %}

And also, a CMakeLists.txt in the same folder with the following content:

{% highlight bash lineos %}
cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(openni_grabber)

find_package(PCL 1.2 REQUIRED)

include_directories(${PCL_INCLUDE_DIRS})
link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})

IF (APPLE)
    FIND_PATH( GLEW_INCLUDE_DIR glew.h
      /System/Library/Frameworks/GLEW.framework/Versions/A/Headers
      ${OPENGL_LIBRARY_DIR}
    )
    SET(GLEW_GLEW_LIBRARY "-lGLEW" CACHE STRING "GLEW library for OSX")
    SET(GLEW_cocoa_LIBRARY "-framework Cocoa" CACHE STRING "Cocoa framework for OSX")
  ENDIF (APPLE)
add_executable (openni_grabber openni_viewer_simple.cpp)
target_link_libraries (openni_grabber ${PCL_LIBRARIES})
{% endhighlight %}

Another parentheses here. I added the IF(APPLE) section because somehow make was getting a different configuration for GLEW which broke the compilation. This block is to make sure the the flag “-lGLEW” is called instead of “-framework GLEW”. Since we’ve installed everything via brew, this is the right way to call GLEW library

Now let’s build everything. In a terminal type:

{% highlight bash lineos %}
mkdir build
cd build
cmake ..
{% endhighlight %}

In the build folder you may have an executable called “openni_grabber”. Just execute it typing:
{% highlight bash lineos %}
./openni_grabber
{% endhighlight %}

## Conclusions

After a week of building PCL in many different ways, this was the one that worked and was easiest to reproduce. Since this is not clearly found in one tutorial, I thought it was worth of a blog post. I still have some issues related to the library, but I’ll may write it down in a future opportunity.

If you read until here, thanks! Leave a feedback in the comments, and see ya!
