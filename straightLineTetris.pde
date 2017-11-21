final int WIDTH = 500;
final int HEIGHT = 500;
final int SIZE = 10;
final int pixelsHIGH = 30;
final int pixelsWIDE = 20;
final int NUM_BOXES = pixelsHIGH * pixelsWIDE;
Box[] boxes = new Box[NUM_BOXES];
Box getBox(Point xy) {
  // only accepts valid points, or points above screen
  if (xy.y < 0 || xy.x < 0 || xy.y > pixelsHIGH-1 || xy.x > pixelsWIDE-1) {
    return new Box();
  }
  
  
 
  int i = ((xy.y * pixelsWIDE) + xy.x);
  return boxes[i];
}


ArrayList<Shape> shapes = new ArrayList<Shape>();

int addShape(Shape s) {
 shapes.add(s);
 int index = shapes.size() - 1;
  return index;
}

enum State {
 EMPTY, ACTIVE, PLACED
}

class Point {
 int x;
 int y;
 public Point(int newX, int newY) {
  this.x = newX;
  this.y = newY;
 }
 public void add(Point p) {
  this.x += p.x;
  this.y += p.y;
 }
 public String toString() {
  return "[" + this.x + ", " + this.y + "]"; 
 }
}

class Shape {
  boolean isRotated = false;
  boolean isFalling = false;
  
   public Shape(Point p) {
    this.xy = p; 
     
   }
   
   public Shape(int x, int y) {
    this.xy = new Point(x, y); 
     
   }
 Point xy;
 Point[] getShape() {
   // returns an array of points
   // relative to xy coordinate, to draw shape
    Point a = new Point(0, -2);
    Point b = new Point(0, -1);
    Point c = new Point(0, 0);
    Point d = new Point(0, 1);
   Point[] squares = {
      a, b, c, d
   };
   return squares;
 }
 void drawShape() {
   // sets pixels for shape
   Point [] vertexes = getShape();
   for (Point v : vertexes) {
     v.add(xy);
     if (isFalling){
       getBox(v).s = State.ACTIVE; 
     }
     else 
       getBox(v).s = State.PLACED;
   } 
 }
 void updateShape() {
     if (isFalling) {
      this.xy.y+=1;
     }
     drawShape();
 }
 void moveShape(boolean isLeft) {
   if (isLeft) {
     this.xy.add(new Point(-1, 0));
   } else {
     this.xy.add(new Point(1, 0));
   }
 }
 void rotate() {
  isRotated = true; 
  updateShape();
 }
}

class Box {
   State s; 
   int x;
   int y;
   int cost;
   boolean isFalling = true;
  
   int i;


  public Box(int x, int y, State s, int i) {
    this.s = s;
    this.x = x;
    this.y = y;
    this.i = i;
    this.cost = 0;
  }

  public Box() {
    this.s = State.EMPTY;
    x = -1;
    y = -1;
    i = -1;
  }



  // something like (makeHazard) or something
  
  void drawSquare() {
    int scale = HEIGHT / pixelsHIGH;
    
    switch(s) {
      case PLACED:
        fill(0, 0, 255);
        break;
      case EMPTY:
         fill(0, 0, 0);
         break;
    default: // ACTIVE 
      fill(255, 0, 255);
      break;
    }
    
    
    rect(this.x*scale, this.y*scale, scale, scale);
  }
}

void blankBoard() {
 for (Box b : boxes) {
  b.s = State.EMPTY; 
 }
  
}

void makeSquares() {
  // for a 10 x 10 grid

  int c = 0;
  for (int i = 0; i<pixelsHIGH; i++) {
   for (int j = 0; j<pixelsWIDE; j++) {
      boxes[c++] = new Box(j, i, State.EMPTY, c);
   }
  }
}

void drawSquares() {
  for (int i = 0; i<NUM_BOXES; i++) {
    boxes[i].drawSquare(); 
  }
} 

void updateShapes() {
 for (Shape s : shapes) {
  s.updateShape(); 
 }
  
}

void setup() {
  print("setup"); 
  size(500, 500);
  makeSquares();
  /*
  int i = 0;
  for (Box b : boxes) {
   i++;
   if (i%SIZE == 0){
    b.s = State.ACTIVE; 
   }
  }
  */
  
  Shape newShape = new Shape(new Point(1, -2));
  newShape.isFalling = true;
  addShape(newShape);
  
}

void draw() {
  updateBoard();
  drawSquares();
  //updateShapes();
  //Point p = new Point(0, 0);
  //getBox(p).s = State.ACTIVE;
}

ArrayList<Box> visited;
ArrayList<Box> frontier;
int timer;

void updateBoard() {
  if (millis() - timer >= 2000) {
      timer = millis();
      blankBoard();
    updateShapes();
    //print("asdf");
     
  }   
}