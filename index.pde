ArrayList<Snake> snakes = new ArrayList<Snake>();

int metro = 7; // timer value
int content = 700; // content-width of website

void setup()
{
  size(800,600);
  //fullScreen();
  //size(screenWidth, screenHeight);
  frameRate(25);
  rectMode(CENTER);
  ellipseMode(CENTER);

  // add the first snake
  snakes.add(new Snake());

  background(255);
}

void draw()
{
  //background(255);
  fill(255, 100);
  rect(width/2, height/2, width, height);

  // check for dead snakes
  for (int i = 0; i < snakes.size(); i++)
  {
    if (snakes.get(i).dead) snakes.remove(i);
  }

  // update all snakes
  for (int i = 0; i < snakes.size(); i++) snakes.get(i).update();

  // randomly launch new snakes, depending on the random value
  if (frameCount % (metro * 2) == 0)
  {
    int r = int(random(30));
    if (r == 0 && snakes.size() < 3) snakes.add(new Snake());
  }
  
  mouseClicked = function(){
  boolean clicked = true;
  for (Snake s : snakes)
  {
    for (int i = 0; i < s.segments.size() - 1; i++)
    {
      if (abs(s.segments.get(i).x - mouseX) < s.halfSize && abs(s.segments.get(i).y - mouseY) < s.halfSize)
      {
        s.tiles[i] = 9;
        clicked = false;
      }
    }
  }
  if (clicked == true && snakes.size() < 8)
  {
    snakes.add(new Snake());
    int sSize = snakes.get(snakes.size() - 1).halfSize;
    snakes.get(snakes.size() - 1).segments.get(0).x = int(mouseX / sSize) * sSize;
    snakes.get(snakes.size() - 1).segments.get(0).y = int(mouseY / sSize) * sSize;
  }
}
}



//---------------------------------------------------------------------------------------------------//
class Snake
{
  ArrayList<PVector> segments = new ArrayList<PVector>();
  int[] tiles;

  int myID, birth, lifeSpan, segCount, size, halfSize, rOld, del, myMetro;
  PVector dir = new PVector();
  boolean dying, dead = false;

  Snake()
  {
    birth = frameCount; // birth frame of snake
    segCount = int(random(4.5, 25.5));  // total number of the snake's segments

    // each segment referrs to one type of tile
    tiles = new int[segCount];
    for (int i = 0; i < segCount; i++) tiles[i] = int(random(-0.5, 7.5));

    lifeSpan = segCount * metro + 200; // amount of frames, that the snake lives
    del = int(random(-0.5, 2)); // way of dying
    myMetro = int(random(1, 3.5)); // snakes dying metro
    size = 20; //int(random(2, 5)) * 5; //size of the snakes segments
    halfSize = int(size / 2); 
    changeDirection(); // randomise first direction

    // add first segment
    int x = int(random(1, width / size)) * size;
    // take out the center part of website
    while (x > (width / 2) - (content / 3) && x < (width / 2) + (content / 3)) x = int(random(1, width / size)) * size;
    int y = int(random(1, height / size)) * size;

    segments.add(new PVector(x, y));

    // check up
    println(birth, lifeSpan, size, segCount, myMetro, del);
  }






  void update()
  {
    // is the snake dying?
    if (frameCount - birth > lifeSpan && dying != true) dying = true;
    if (dying == true) die();

    // change direction and add segment
    if (frameCount % metro == 0 && segments.size() - 1 < segCount)
    {
      changeDirection();
      addSegment();
    }

    // draw all active segments
    drawSegments();
  }




  // draw all segments according to their tile style from tiles[]
  void drawSegments()
  {
    for (int i = 0; i < segments.size() - 1; i++)
    {
      switch(tiles[i])
      {
      case 0:
        pushStyle();
        fill(0);
        rect(segments.get(i).x, segments.get(i).y, size, size);
        popStyle();
        break;
      case 1:
        pushStyle();
        noFill();
        stroke(0);
        strokeWeight(1);
        rect(segments.get(i).x, segments.get(i).y, size, size);
        popStyle();
        break;
      case 2:
        pushStyle();
        noFill();
        stroke(0);
        strokeWeight(1);
        rect(segments.get(i).x, segments.get(i).y, size, size);
        popStyle();
        break;
      case 3:
        pushStyle();
        fill(0);
        stroke(0);
        strokeWeight(1);
        rect(segments.get(i).x - 2, segments.get(i).y + 2, size, size);
        fill(255);
        stroke(0);
        strokeWeight(1);
        rect(segments.get(i).x, segments.get(i).y, size, size);
        popStyle();
        break;
      case 4:
        pushStyle();
        noFill();
        stroke(0);
        strokeWeight(1);
        line(segments.get(i).x - halfSize, segments.get(i).y - halfSize, segments.get(i).x + halfSize, segments.get(i).y + halfSize);
        popStyle();
        break;
      case 5:
        pushStyle();
        noFill();
        stroke(0);
        strokeWeight(1);
        for (int j = 0; j < 30; j++)
        {
          float x = random(segments.get(i).x - halfSize, segments.get(i).x + halfSize);
          float y = random(segments.get(i).y - halfSize, segments.get(i).y + halfSize);
          point(x, y);
        }
        popStyle();
        break;
      case 6:
        pushStyle();
        noFill();
        stroke(0);
        strokeWeight(1);
        line(segments.get(i).x + halfSize, segments.get(i).y - halfSize, segments.get(i).x - halfSize, segments.get(i).y + halfSize);
        popStyle();
        break;

      case 7:
        pushStyle();
        noFill();
        stroke(255);
        strokeWeight(1);
        for (int j = 0; j < 30; j++)
        {
          float x = random(segments.get(i).x - halfSize, segments.get(i).x + halfSize);
          float y = random(segments.get(i).y - halfSize, segments.get(i).y + halfSize);
          point(x, y);
        }
        popStyle();
        break;
      }
    }
  }

  // set new segments coordinates according to direction
  void addSegment()
  {
    int x = int(segments.get(segments.size() - 1).x + dir.x);
    int y = int(segments.get(segments.size() - 1).y + dir.y);
    segments.add(new PVector(x, y));
  }

  // change the direction of the next segment to put
  void changeDirection()
  {
    int r = int(random(-1, 6));

    while (r == 0 && rOld == 2 | r == 2 && rOld == 0 | r == 1 && rOld == 3 | r == 3 && rOld == 1) r = int(random(-0.5, 3.5));

    switch(r)
    {
    case 0:
      dir = new PVector(size, 0); // go right
      break;
    case 1:
      dir = new PVector(0, size); // go down
      break;
    case 2:
      dir = new PVector(-size, 0); // go left
      break;
    case 3:
      dir = new PVector(0, -size); // go up
      break;
    }

    rOld = r;
  }

  // dying in only one way yet...
  void die()
  {
    if (frameCount % myMetro == 0)
    {
      // choose random tile and die according to del
      int r = int(random(-0.5, tiles.length - 0.5));
      while(del == 1 && tiles[r] == -1) r = int(random(-0.5, tiles.length - 0.5));
      switch(del)
      {
      case 0:
        tiles[r] += 1;
        break;

      case 1:
        tiles[r] -= 1;
        break;
      }
    }

    int sum = 0;
    for (int i : tiles) {
      sum += i;
    }

    if (sum > tiles.length * 10 | sum < -tiles.length + 1)
    {
      dead = true;
    }
  }
}
