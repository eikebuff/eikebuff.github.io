void setup()
{
  size(700, 400);
  background(255);
  noStroke();
  fill(0);
}

void draw()
{
  ellipse(width/2, height/2, frameCount/22, frameCount/22);
}
