# oreo44 #

## Inspiration

Nintento Labo.

## What it does

(Side)Scrolling shoot 'em up game, controlled using a physical controllor captured by the camera. 

## How we built it

The game is programmed in Haxe, which transpiles into javascript where we are using trackingjs library for video processing.

## Challenges we ran into

Trying to extract spacial objects rotation from live stream is not trivial due to many factors. For example interference caused constantly changing environment. Another problem was very poor performance of javascript in browsers for picture processing. 

## Accomplishments that we are proud of

Achieved to track objects in space while using the gathered information in game. 

## What I learned

Don't use javascript for CPU intesive tasks.

## What's next for oreo44

The game's original controller design allowed for another analog input in "side-scrolling" mode, but was cut due to processing problems.
There is also partially implemented third play mode that was meant to be played with the "joystick" facing the camera. This game mode could introduce new options regarding gameplay.
