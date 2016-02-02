---
layout: post
title: "Global Game Jam 2016 - Thoughts, Experiences and a Small Post-Mortem"
modified:
categories: Game Development
excerpt: "Status Report: Lack of sleep, Diabetes, Pizza Saturated fat, Bugs, Engine Crashing, more bugs..."
tags: [Global Game Jam, Game Development, Game Design, Team Work]
comments: true
image:
  feature:
date: 2016-02-02T16:00:01+00:00
---
<iframe width="560" height="315" src="https://www.youtube.com/embed/_31I5EgdLmQ" frameborder="0" allowfullscreen></iframe>

It’s been a while since my last post, sorry about that =)

Last weekend I attended to the Global Game Jam here in Dublin. For the ones who doesn’t know, it is a worldwide event where you meet new people, make friends, don’t sleep good, complain about crashing engines and make a game in 48h. It is a perfect time to learn, try new game design possibilities, do networking, and last but not least: have fun making games. In the end, you will surely made new friends, and had a great time.

Today I’ll express some of the thoughts and experiences I had during the event that are worth sharing. The game I’ve worked is called Uku and can be seen at http://globalgamejam.org/2016/games/uku . I did all the programming, Ukulele songs (YEAH!) and Game Design with all the others.

Id’ like also to thank the team I worked with. Eveliina Durchman, Josephine Wagner and Cian Burke. They are amazing teammates and very talented professionals as well.

The project is also hosted at github: <a href="https://github.com/kazenotenshi/GlobalGameJam2016"> https://github.com/kazenotenshi/GlobalGameJam2016 </a>

## Small Teams

Before the Jam, I had a mindset of be in a group of 3 people. In the end we finished with one more but It added another skillset to our team. I saw some teams of 7 people where it was very hard to manage that. Also smaller teams has a better communication which I’ll talk further.

<div align="center">
<figure>
     <a href="/images/theGGJTeam.jpg"><img src="/images/theGGJTeam.jpg" alt="The team. In the back, from Left to Right: Eveliina, Josephine and Cian. I'm in red with the ukulele." align="middle"></a>
 
     <figcaption>The team. In the back, from Left to Right: Eveliina, Josephine and Cian. I'm in red with the ukulele.</figcaption>
</figure>
</div>

## Managing Scope

The first thought I wanted to share is about project scope. Most of the times at the beginning of jam (Friday night) is reserved for the Brainstorming and Game Design. This year the theme was “Ritual”. In my opinion it gave the gamers a wide variety of ideas. We ourselves brainstormed from personal rituals (habits, OCD and other stuff) till witches and some dark ideas like reviving people.

We decided to do a simple thing: Make a god ( goddess in our case ) happy. We dig up (as quick as we could) into the Hawaiian Mythology and discovered many cool stories and legends! Although we based our game in this legends we decided not to explicit refer it because for design purposes we have changed few things.

After that, came the question “What would our mechanics be”? After another quick brainstorming we decided to create a 2D bottom-up platformer with a pressure element. Again, we put on the table each one’s ability and how everyone can contribute to the group.

Other thing that is important to mention is preparations. Before the game jam we decided which tools to use and I researched a set of assets to use before hand trying to anticipate which kind of game we want to make. The engine used was unity which itself has tons of tools, free assets at asset store and is widely used by all of us.

Some of the assets we used before hand were:

* 2D Dev Sprites (<a href="http://u3d.as/6nk">http://u3d.as/6nk</a>) : Perfect for mock up levels and use it as platforms

* BitStrap (<a href="http://u3d.as/mF1">http://u3d.as/mF1</a>) : I just found this recently and it is a set of libraries and tools for math, animation, inspector and others that saves a lot of time. For instance you can get their singleton class and just made every singleton in the code inherit from it.

* Game Jam Menu Template (<a href="http://u3d.as/hvQ">http://u3d.as/hvQ</a>) : Provided by unity, is is hand because it creates a quick menu for you and configure the audio mixer for music and FX

* Standard Assets (<a href="hhttp://u3d.as/cg6">http://u3d.as/cg6</a>) : Again from Unity, provides a set of basic scripts, animations and other resources. Why make everything again if they provide 2D character movement for free? Off course you need to adapt it for your game, but is a straightforward approach in my opinion.

<div align="center">
<figure>
     <a href="/images/preparations.jpg"><img src="/images/preparations.jpg" alt="Preparing to the jam, food, food and more food =)" align="middle"></a>
 
     <figcaption>Preparing to the jam, food, food and more food =)</figcaption>
</figure>
</div>

## Communication

Like in a workspace, the better way to maintain the communication between the team is having people next to each other and set up roles clearly and a process of work. In our team we had artists, animators/level designer, and me as programmer.

We decide that everyone had freedom to do what they want and if the want some feedback or opinion they call all the teal for a quick meeting. Also, the art team set up an asset list for them to make the work goes as fast as possible and don’t lose track of each feature that has to be made. I decided to organize my work using trello for managing the tasks and github for source code management which saved me a lot of time and saved my project sometimes.

All the assets were uploaded to a shared folder at google drive where every time that I need some asset to put in the project I just need to quick check this folder for it. In between I’d use placeholders to create the logic before the assets were done, and make few fixing when we place the final art.

<div align="center">
<figure>
     <a href="/images/RickRollPlaceholder.png"><img src="/images/RickRollPlaceholder.png" alt="Replacing some assets by Rick Astley made us remember to put some assets" align="middle"></a>
 
     <figcaption>Replacing some assets by Rick Astley made us remember to put some assets</figcaption>
</figure>
</div>

## Respect your and others limits

Although you make a lot of friends and have a lot of fun, there’s something we must track at all times during a jam, your mental health. Sometimes after 5h, 6h in a row working we start to make stupid mistakes and/or feeling bad. It is common to eat not so healthy ( I do not regret any pizza ) and drink a lot of energetic drinks to keep the pacing. I have a very strict opinion about it: Your health is way more important than the jam. The pressure of the 48h sometimes affect people's mind and they forget it easily. It is important for the whole team to support that. If there’s a person feeling not so good, or drinking too much energetic drinks everyone should make clear that he/she has to take a break. Particularly about the programming side it made me avoid stupid mistakes. Every time that I realized that I was make rollbacks in the source code because of my mistakes and/or I was taking too much time to program a simple thing I’d lock the screen and walk around. Most of the tunes of the game were recorded during these breaks as a form of relaxing.

Another limit that shall always be aware for everyone of the team are your skills limits. Although the game jam is an opportunity to learn new things, you’re not going to develop some skills just because of the 48h pressure. If you’re not a senior programmer you’re not gonna make a complex RPG system in 48h. If you’re not a hell of a good animator you’re not gonna make a pixar like cutscene for the game in time. Keep it simple, if it is necessary cut down the design for now and try to make the smallest proof of concept possible. We decided to make only one level because of that. Other teams decided to cut down some interactions or making a visual novel game because they didn’t have a programmer among them. If you’re not an artist make it with blocks and maintain this as an “art style” =). The most important thing is to use your skillset and have a playable product in the end.

## Polishing Time a.k.a Cutting Things

Polishing time can be known as the “stop new features” time. It is important to set a proper time for it regardless how the development is going. If you forget it, odds are that you will try to make in the last 3 or 4 hours and it won’t be polished enough. In our case we decided to stop any new feature after 24h. A meeting was made at the night of the second day to decide what we were going to cut. Hopefully we managed the scope accurately, making us cut just some few animations and features (like a more complex tutorial).

## Final Product

Before release, play it and let other people play it. We discovered so many bugs just my getting the build and showing it to some people. Also, get the project and run in another computer before releasing. Know your requirements and put it explicitly in the description. Tell which version of the engine you used. If you just tested the game for one resolution say that it only works in that resolution, period. The important thing here is, make sure that after you upload your project you’d have the less people having troubles to execute it.

I’m proud of my team of making it viable and have a playable version at the end with few bugs and art mistakes.

<div align="center">
<figure>
     <a href="/images/UkuHeader.png"><img src="/images/UkuHeader.png" alt="Our Game: Uku" align="middle"></a>
 
     <figcaption>Our Game: Uku</figcaption>
</figure>
</div>

##Conclusion

The Global Game Jam is for game developers an amazing opportunity to meet new people, learn new things, have fun, create more portfolio and eating pizza while you listen to ukuleles in our case. Mind your scope and your limits. Respect people’s limits as well, and know that are more things important at stake. Do something you are proud of, and it will be valuable for you personally and professionally. And always have fun.

Thanks for reading =)
