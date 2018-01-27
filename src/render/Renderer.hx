package render;

interface Renderer {
  function createSprite(type:String):Sprite;
  function removeSprite(s:Sprite):Void;
  function tick():Void;
}
