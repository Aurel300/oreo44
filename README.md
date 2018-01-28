# oreo44 #

## Inspiration

Physical puzzles / dedicated controllers add another dimension to captivating gameplay. The original idea was to be able to print (with any black & white printer at home) a template for controllers for various games. The template would then be folded and assembled as per instructions and the product would be an extremely cheap, but unique controller for a given game. There would be tracking tags on the template that a laptop camera could easily pick up. (None of our group is good at origami, so we went with an acryllic build.)

## What it does

Scrolling shoot 'em up game, controlled using a physical controller tracked by a laptop camera. There are two modes of gameplay, vertically scrolling shootout and horizontally scrolling dodging sections. The two modes are controlled with different parts of the controller - a specific face has to be facing the camera. One side controls like an airplane joystick, another like a steering wheel.

## How we built it

The game is programmed in Haxe which transpiles into vanilla Javascript. The compiled script makes use of the tracking.js library for very simple colour tracking in the video feed from the camera.

## Challenges we ran into

Trying to extract spatial object rotation from a live video feed is not trivial due to many factors - interference caused by a constantly changing environment, poor lighting conditions, subpar camera quality, etc. Another problem was very poor performance of Javascript in browsers for picture processing (the tracking.js library uses the CPU to process each pixel individually).

## Accomplishments that we are proud of

Achieved somewhat reliable tracking of physical objects in space while using the gathered information in game. A simple but pretty game to control.

## What I learned

Don't use Javascript for CPU intesive tasks - WebGL is a more complicated setup, but shaders would make this project a much smoother experience.

## What's next for oreo44

The game's original controller design allowed for another analog input in the "side-scrolling" mode, but was cut due to processing problems. There is also a partially implemented third play mode that was meant to be played with the "joystick" facing the camera. This game mode could introduce new options regarding gameplay.
