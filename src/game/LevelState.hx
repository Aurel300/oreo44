package game;

enum LevelState {
  Vertical;
  Horizontal;
  Plane;
  Transition(from:LevelState, to:LevelState);
}
