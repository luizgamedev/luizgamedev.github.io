---
layout: post
title: "Unity Quick Tips: Using Microsoft Visual Studio Code Instead of MonoDevelop"
modified:
categories: Game Development
excerpt: "Sorry Mono for that..."
tags: [Unity3D, Game Development, Programming]
comments: true
image:
  feature:
date: 2015-07-04T21:32:42-03:00
---

Hi everyone, last week I decided to start something new here. I'll be posting some small tips of using Unity3D once in a while. Why? Because I love Game Development. Even though I'm not working with it right now, I always create some stuff in my spare time. Since this is my first talk, I'd like to make a quick introduction on Unity, and then start the main objective of this article, that will be changing Unity's default IDE.

If you like this article, I want that you take a moment and vote into Unity's website and Microsoft's web site to make this integration between Unity and Visual Studio Code be more effective.

On Unity's side: <a href="http://www.garycmartin.com/mouth_shapes.html</a>http://feedback.unity3d.com/suggestions/visual-studio-code-integration?page=1#comments">link</a>

On Microsoft's side: <a href="http://visualstudio.uservoice.com/forums/293070-visual-studio-code/suggestions/7752702-unity-integration">link</a>

Let's start!

## What is Unity3D?

<a href="http://unity3d.com">Unity3D</a> is a very very nice game engine. I've been using it since the version 3 for many different purposes. From research, to serious games and Game development itself. Recently they also did a very good job making it first of all, free, and also with 2D support. It compiles to almost every well known platform ( mobile, desktops, web and consoles ).

If you're interested, the learning curve isn't that hard. The development can be made in C# and/or Javascript. For tutorials please visit their <a href="https://unity3d.com/learn/tutorials/modules">Tutorial Page</a>. Everything is there. And I also recommend that you check <a href="https://unity-game-development.zeef.com/adrian.anta">this page</a>. He was made a very nice indexing of useful websites for Game Development and Assets that you may need.

## What is Visual Studio Code, and why should we use it

The default IDE for Unity is MonoDevelop. Why? It is portable for Windows and OSX, Unity uses the mono project compiler, and so on. Nevertheless, the IDE is not that good. Microsoft's Visual Studio inside Windows is unbeatable. That's why unity offers <a href="http://docs.unity3d.com/Manual/VisualStudioIntegration.html">an integration</a> with it on windows. The are two problems here: 1 - And if I'm using windows and I don't have a VS license?, and 2 - and if I'm an OSX user? Well, I'm on the second list.

Hopefully Microsoft released a product called <a href="https://code.visualstudio.com/">Visual Studio Code</a> which is a lightweight IDE with intellisense for windows, linux and OSX. Did I mentioned that it is also free? And it has a great integration with Git as well. For me, this is a perfect alternative to Mono.

## How to change the default IDE

Three easy steps to start using Visual Studio Code on Unity:

###1. Sync the Project.

Go to Assets -> Sync MonoDevelop project

<div align="center">
<figure>
     <a href="/images/unityVSCode001.png"><img src="/images/unityVSCode001.png" alt="Go to Assets -> Sync MonoDevelop project" align="middle"></a>
</figure>
</div>

###2. Open Visual Studio and select your project's folder

Select the first button on the left, and then press "Open Folder". Select your Unity's project root folder and open it.

<div align="center">
<figure>
     <a href="/images/unityVSCode002.png"><img src="/images/unityVSCode002.png" alt="Open Visual Studio and select your project's folder" align="middle"></a>
</figure>
</div>

###3. Pick a project inside Unity's folder
On the bottom left there's an option called "pick a project", just beside a flame icon. Select it, and then select the project with the "csharp" ending.

<div align="center">
<figure>
     <a href="/images/unityVSCode003.png"><img src="/images/unityVSCode003.png" alt="Pick a project inside Unity's folder" align="middle"></a>
</figure>
</div>

Now you should be able to visualize all the scripts within an Unity project and use the Intellisense. 

<div align="center">
<figure>
     <a href="/images/unityVSCode004.png"><img src="/images/unityVSCode004.png" alt="Intellisense" align="middle"></a>
</figure>
</div>

###4. [Bonus Stage] Making the Visual Code de Default Unity's IDE

Even though I am using Visual Studio Code I just didn't change it inside of Unity. Why? There's still one main feature that is missing in VSCode for Unity: Debugging. Still, I have maintained the Mono as Unity's default IDE just as a quick shortcut do open and debug the code. But, if you want to completely giveaway Mono, here's the step:

Go to Unity -> Preferences. At the external tools tab open the External Script Editor combo and select "browse". Find the VS Code app and select it.

<div align="center">
<figure>
     <a href="/images/unityVSCode005.png"><img src="/images/unityVSCode005.png" alt="Changing the default IDE" align="middle"></a>
</figure>
</div>

## Pros and Cons

Visual Studio Code definitely has a cleaner environment with a very nice auto-complete feature ( that I think is the best one ). It will make you increase productivity without spending a penny on a good IDE. But, there's free lunch( at least from now ). You will not be able to debug unity's code right now. That's why you should vote for this feature as I mentioned before.

Hope that this was helpful for any Unity and Non Unity developer that wants to dig into this world. If you have any problems, and something to add please comment below. See ya.