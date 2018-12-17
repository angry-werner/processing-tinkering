private final int screenWidth = 640;
private final int screenHeight = 480;

private final Rectangle player = new Rectangle(new Point(0, 0), new Point(10, 50));
private final Rectangle[] obstacles = {
  new Rectangle(new Point(80, 0), new Point(180, 100)), 
  new Rectangle(new Point(240, 60), new Point(300, 65))
};

public void settings() {
  size(screenWidth, screenHeight);
}

public void setup() {
}


public void draw() {
  background(0, 0, 0);
  Command command = Command.NOOP;
  if (keyPressed && key == CODED) {
    switch (keyCode) {
    case UP:
      command = Command.NOOP;
      break;
    case DOWN:
      command = Command.NOOP;
      break;
    case LEFT:
      command = Command.GO_LEFT;
      break;
    case RIGHT:
      command = Command.GO_RIGHT;
      break;
    default: 
      break;
    }
  }
  for (final Rectangle obstacle : obstacles) {
    obstacle.draw();
  }
  player.move(command);
  player.draw();
}

private class Rectangle {
  private Point lowerLeft;
  private Point upperRight;

  private Rectangle(final Point lowerLeft, final Point upperRight) {
    super();
    this.lowerLeft = lowerLeft;
    this.upperRight = upperRight;
  }

  private void draw() {
    fill(255, 255, 255);
    rect(getScreenLocationX(), getScreenLocationY(), getWidth(), getHeight());
  }

  private void move(final Command command) {
    final Vector vector = calculateVector(command);
    lowerLeft = lowerLeft.move(vector);
    upperRight = upperRight.move(vector);
  }

  private Vector calculateVector(final Command command) {
    switch (command) {
    case GO_LEFT  : 
      return collisionInX(Command.GO_LEFT.getNormalVector())? Command.NOOP.getNormalVector(): Command.GO_LEFT.getNormalVector();
    case GO_RIGHT : 
      return collisionInX(Command.GO_RIGHT.getNormalVector())? Command.NOOP.getNormalVector(): Command.GO_RIGHT.getNormalVector();
    default       : 
      return Command.NOOP.getNormalVector();
    }
  }

  private boolean collisionInX(final Vector vector) {
    if (vector.x < 0 && lowerLeft.x == 0) {
      return true;
    } else if (vector.x > 0 && upperRight.x == screenWidth) {
      return true;
    } else if (collisionInXWithObstacle(vector)) {
      return true;
    } else {
      return false;
    }
  }

  private boolean collisionInXWithObstacle(final Vector vector) {
    for (final Rectangle obstacle : obstacles) {
      if (this.upperRight.x == obstacle.lowerLeft.x && vector.equals(Command.GO_RIGHT.getNormalVector())) {
        return true;
      } else if (this.lowerLeft.x == obstacle.upperRight.x && vector.equals(Command.GO_LEFT.getNormalVector())) {
        return true;
      }
    }
    return false;
  }

  private int getScreenLocationX() {
    return lowerLeft.getX();
  }

  private int getScreenLocationY() {
    return screenHeight - lowerLeft.getY() - getHeight();
  }

  private int getWidth() {
    return upperRight.getX() - lowerLeft.getX();
  }

  private int getHeight() {
    return upperRight.getY() - lowerLeft.getY();
  }

  public String toString() {
    return "lower left: " + lowerLeft.toString() + "\nupper right: "+ upperRight.toString();
  }
}

private static class Point {
  private final int x;
  private final int y;

  private Point(final int x, final int y) {
    super();
    this.x = x;
    this.y = y;
  }

  private Point move(final Vector v) {
    return new Point(this.x + v.x, this.y + v.y);
  }

  private int getX() {
    return x;
  }

  private int getY() {
    return y;
  }

  public String toString() {
    return "x: " + getX() + ", y: " + getY();
  }
}

private interface NormalVector {
  Vector getNormalVector();
}

private static enum Command implements NormalVector {
  NOOP(new Vector(0, 0)), GO_LEFT(new Vector(-1, 0)), GO_RIGHT(new Vector(1, 0));

  private final Vector normalVector;

  private Command(final Vector vector) {
    this.normalVector = vector;
  }

  Vector getNormalVector() {
    return normalVector;
  }
}

private static class Vector {
  private final int x;
  private final int y;

  private Vector(final int x, final int y) {
    super();
    this.x = x;
    this.y = y;
  }

  private int getX() {
    return x;
  }

  private int getY() {
    return y;
  }

  public boolean equals(final Object other) {
    if (other instanceof Vector) {
      final Vector cOther = (Vector)other;
      return this.x == cOther.x && this.y == cOther.y;
    }
    return false;
  }
}
