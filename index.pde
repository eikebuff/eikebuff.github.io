ArrayList<Snake> snakes = new ArrayList<Snake>();

int metro = 7; // timer value
int content = 700; // content-width of website

void setup()
{
  //fullScreen();
  size(screenWidth, screenHeight);
  frameRate(25);
  rectMode(CENTER);
  ellipseMode(CENTER);

  snakes.add(new Snake());

  background(255);
}

void draw()
{
  //background(255);
  fill(255, 100);
  rect(width/2, height/2, width, height);

  for (int i = 0; i < snakes.size(); i++)
  {
    if (snakes.get(i).dead) snakes.remove(i);
  }
  for (int i = 0; i < snakes.size(); i++) snakes.get(i).update();

  if (frameCount % (metro * 2) == 0)
  {
    int r = int(random(30));
    if (r == 0 && snakes.size() < 3) snakes.add(new Snake());
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
    birth = frameCount;
    segCount = int(random(4.5, 30.5));
    tiles = new int[segCount];
    for (int i = 0; i < segCount; i++) tiles[i] = int(random(-0.5, 7.5));
    lifeSpan = segCount * metro + 200;
    del = int(random(-0.5, 1.5));
    myMetro = int(random(1, 3.5));
    size = 20; //int(random(2, 5)) * 5;
    halfSize = int(size / 2);
    changeDirection();

    // add first segment
    int x = int(random(1, width / size)) * size;
    while (x > (width / 2) - (content / 3) && x < (width / 2) + (content / 3)) x = int(random(1, width / size)) * size;
    int y = int(random(1, height / size)) * size;
    segments.add(new PVector(x, y));

    // check up
    //println(birth, lifeSpan, size, segCount, myMetro, del);
  }






  void update()
  {
    if (frameCount - birth > lifeSpan && dying != true) dying = true;
    if (dying == true) die();

    if (frameCount % metro == 0 && segments.size() - 1 < segCount)
    {
      changeDirection();
      addSegment();
    }

    drawSegments();
  }





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
      case 4: // line(s)
        pushStyle();
        noFill();
        stroke(0);
        strokeWeight(1);
        for(int l = 0; l <= 5; l++)
        {
          line(segments.get(i).x - halfSize + (l * size/5), segments.get(i).y - halfSize, segments.get(i).x - halfSize + (l * size/5), segments.get(i).y + halfSize);
        }
        //line(segments.get(i).x - halfSize, segments.get(i).y - halfSize, segments.get(i).x + halfSize, segments.get(i).y + halfSize);
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
        for(int k = 0; k <= 5; k++)
        {
          line(segments.get(i).x - halfSize, segments.get(i).y - halfSize + (k * size/5), segments.get(i).x + halfSize, segments.get(i).y - halfSize + (k * size/5));
        }
        //line(segments.get(i).x + halfSize, segments.get(i).y - halfSize, segments.get(i).x - halfSize, segments.get(i).y + halfSize);
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

  void addSegment()
  {
    int x = int(segments.get(segments.size() - 1).x + dir.x);
    int y = int(segments.get(segments.size() - 1).y + dir.y);
    segments.add(new PVector(x, y));
  }

  void changeDirection()
  {
    int r = int(random(-1, 6));

    while (r == 0 && rOld == 2 | r == 2 && rOld == 0 | r == 1 && rOld == 3 | r == 3 && rOld == 1) r = int(random(-0.5, 3.5));

    switch(r)
    {
    case 0:
      dir = new PVector(size, 0);
      break;
    case 1:
      dir = new PVector(0, size);
      break;
    case 2:
      dir = new PVector(-size, 0);
      break;
    case 3:
      dir = new PVector(0, -size);
      break;
    }

    rOld = r;
  }

  void die()
  {
    if (frameCount % myMetro == 0)
    {
      int r = int(random(-0.5, tiles.length - 0.5));
      tiles[r] += 1;
    }

    int sum = 0;
    for (int i : tiles) {
      sum += i;
    }

    if (sum > tiles.length * 10)
    {
      dead = true;
    }
  }
}
