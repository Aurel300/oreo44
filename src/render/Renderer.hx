package render;

import game.LevelState;

interface Renderer {
  function mode(s:LevelState):Void;
  function createSprite(type:String):Sprite;
  function removeSprite(s:Sprite):Void;
  function tick():Void;
  function health(h:Float):Void;
  function playing(p:Bool, go:Bool):Void;
}
