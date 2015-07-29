---
layout: post
title: "Asteroid's Game: Player Input"
modified:
categories: [GameDev, Programming, Unity3D]
excerpt: "Atari says Hi!"
tags: []
image:
  feature:
date: 2015-07-29T19:45:40-03:00
comments: true
---

Hi! After the Unity quick tips, I have decided to invest a little more time sharing some insights and Unity tips in this blog, rather than only share my updates in the P.hD Thesis and other random stuff.

To Start, I choose one of the classics games ever, Asteroids. I remember playing this little game when I was a young man, and like all games, it could teach a lot of small concepts of the engine right away.

This part will cover the input control of the ship. The code is available at <a href="https://github.com/kazenotenshi/MyAsteroids>Github">Github</a> if you like. Let's go!

## Starting the project

Download Unity ( if you didn't already ) at <a href="http://unity3d.com">http://unity3d.com</a> and open it. Start a new project, and set is as a 2D project. For now we don't need any standard asset. Just click on create and wait until Unity do all the necessary preps to initiate the project.

## The Spaceship

I must say, I'm not an artist. But recently I found a great app to make sprite animations and atlases in an easy way than even the worst programmer artist wannabe can use, it is called <a href="http://www.piskelapp.com/">Piskel</a>. I have created a space ship as follows:

<div align="center">
<figure>
     <a href="/images/l0_sprite_1.png"><img src="/images/l0_sprite_1.png" alt="I'm not an artist =)" align="middle" width="200"></a>
 
     <figcaption>My Spaceship</figcaption>
</figure>
</div>

For the purposes of this tutorial, I'll just focus on this particular sprite. I have created some sort of animation, that I'll talk later.



## The input script

The main objective of this script is to get the input of the player and reflect it inside of the game. The input could be either from the keyboard or from a joystick in this case. There are several ways to do it, one is using the input axes. In the Asteroids Game, the vertical axes reflects an up/down translation of the ship. The horizontal applies a rotation to it.

Go to "Create Game Object" and then in the "2D Object -> Sprite" to create a new 2D object from a sprite. Name it "SpaceShip", find the sprite inside the project area and drag it to the Game Object. Make sure that it is inside the camera's view. Add a a Rigidbody2D Component to the game object you just created at Component -> Physics2D -> Rigidbody2D. The result should be something like this:

<div align="center">
<figure>
     <a href="/images/axesSpaceship.png"><img src="/images/axesSpaceship.png" alt="Ship inside Unity" align="middle" width="200"></a>
 
     <figcaption>Spaceship inside the Unity's view</figcaption>
</figure>
</div>



Now let's start the script. In the project tab, do a right click and and choose "Create -> C#" script. Name it "SpaceshipInput", and then click and drag it to the Game Object you just created. Just a quick advise. As the project gets bigger it is nice if you organize the project area into folders. It will help you later to find the assets quickly. Double click in the script in the project area to open the default script editor. If you did not <a href="http://kaze.io/game/development/unity-quick-tips-using-microsoft-visual-studio-code-instead-of-monodevelop/">change it like me</a>, it should be MonoDevelop. 

Unity always creates a standard template where the script inherits from MonoBehaviour and has two functions: Start and Update. Start is a function that is called once, on the frame when a script is enabled, before the first update. Update on the other hand, is called every frame. There are others derived methods from MonoBehaviour that is worth knowing. Refer to the <a href="http://docs.unity3d.com/ScriptReference/MonoBehaviour.html">Official Documentation</a> and look at other functions.

Let's Start creating two public variables called speed and rotationSpeed inside the class, just before the Start function.

{% highlight csharp lineos %}using UnityEngine;
using System.Collections;

public class SpaceshipInput : MonoBehaviour {

	//Speeds
	public Vector2 speed = new Vector2( 0f, 10.0F);
	public float rotationSpeed = 200.0f;

	// Use this for initialization
	void Start(){
    }
	
	// Update is called once per frame
    void Update() {
	}

}
{% endhighlight %}

Notice that the default values were already set. If you go to the inspector at Unity's editor, these two variables will appear there. Go there and set some default values to the Rigidbody2D Component as well. Put a very small Gravity Scale, keep the angular drag and the mass at 1. The result would be something like this:


<div align="center">
<figure>
     <a href="/images/ViewWithScript.png"><img src="/images/ViewWithScript.png" alt="Script is successfully attached" align="middle" width="400"></a>
 
     <figcaption>Spaceship inside the Unity's view</figcaption>
</figure>
</div>

Ok, our variables are set. The idea now is to get the input from the player, and move the Space Ship around. I'd start with the rotation. Input.GetAxis function will give us a value in [-1,1] range from a keyboard or a joystick input. We should say which Axis are we in ( Horizontal, or vertical ). In this case would be the Vertical one. The code should be called every frame to check if the user is still holding the left/right key or toggling the joystick in these directions. After that, we should get a relative time from the last frame and apply the rotation in the Z axis. The code is:

{% highlight csharp lineos %}
	// Update is called once per frame
	void Update() {
		//Deal with rotation first
		float rotation = Input.GetAxis("Horizontal") * rotationSpeed;
		rotation *= Time.deltaTime;
		transform.Rotate(0, 0 , -rotation);
	}
{% endhighlight %}

What it does? Every frame, we will get a value between -1 and 1 from the horizontal axis, multiply that to our rotationSpeed and to the deltaTime which is the time in seconds it took to complete the last frame. After that the code applies the rotation to the Game Object's transform class.

The Translation uses the same concept, but we will not do an affine transformation here, we will use physics instead. Why? Because we're in space, and the movement should reproduce its environment. Also, our ship is an outdated model that does not have reverse, sorry for that =). Continuing our code:

{% highlight csharp lineos %}
	// Update is called once per frame
	void Update() {
		//Deal with rotation first
		float rotation = Input.GetAxis("Horizontal") * rotationSpeed;
		rotation *= Time.deltaTime;
		transform.Rotate(0, 0 , -rotation);

		//Translation is an special case, only occurs if the player wants to go up!
		if( Input.GetAxis("Vertical") > 0 ){
			Vector2 translation = Input.GetAxis("Vertical") * speed;
			translation *= Time.deltaTime;
			GetComponent<Rigidbody2D>().AddRelativeForce(translation, ForceMode2D.Impulse);
		}
	}
{% endhighlight %}

Translation is now a 2D Vector that will get the value from the player input and multiply with our pre specified speed and the deltaTime. Differently from the rotation, we will now apply a relative force to the object. The force type is an impulse case it reflects the engines impulsion in a real spaceship. It is relative because we want it to go up in the ship's perspective, not the world's perspective. So if we do any kind of rotation, the force will be applied relatively to the ship's coordinate system at the time. The final code is:



{% highlight csharp lineos %}
using UnityEngine;
using System.Collections;

public class SpaceshipInput : MonoBehaviour {

	//Speeds
	public Vector2 speed = new Vector2( 0f, 10.0F);
	public float rotationSpeed = 200.0f;

	// Use this for initialization
	void Start(){
	}
	
	// Update is called once per frame
	void Update() {
		//Deal with rotation first
		float rotation = Input.GetAxis("Horizontal") * rotationSpeed;
		rotation *= Time.deltaTime;
		transform.Rotate(0, 0 , -rotation);
        
		//Translation is an special case, only occurs if the player wants to go up!
		if( Input.GetAxis("Vertical") > 0 ){
			Vector2 translation = Input.GetAxis("Vertical") * speed;
			translation *= Time.deltaTime;
			GetComponent<Rigidbody2D>().AddRelativeForce(translation, ForceMode2D.Impulse);
		}
	}
}

{% endhighlight %}

That's enough for now. Next post I'll solve one problem that this code creates. If you have any comment I'll be glad to help. See ya!

