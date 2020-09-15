int playRate, minPlayRate, frameRate, deathTime, sLength, sFill, foodCount;
boolean die, start, eat, fast;
int sMax = 300;
int tile = 20;
Snake[] snakes = new Snake[sMax];
Food[] foods = new Food[sMax]; 
void setup()
{
  frameRate = 100;
  minPlayRate = 8;
  playRate = minPlayRate;
  foodCount = -1;
  deathTime = -1;
  sLength = 4;
  sFill = 250;
  die = false;
  start = false;
  eat = false;
  fast = false;
  size(840,720);
  frameRate(frameRate);
  for(int i = 0; i < sLength; ++i) {
    snakes[i] = new Snake(width/2, height/2-i*tile, i);
  }
}
void draw()
{
  if(deathTime != -1) background(round(1+frameCount-deathTime), 0 , 0);
  else
  {
    background(0);
    grid();
  }
  for(int i = 0; i < sLength; i++)
  {
    snakes[i].update();
  }
  if(foodCount == -1 || (sLength % 6 == 0 && eat))
  { // Create 1 food and 1 every 6th sLength
    ++foodCount;
    foods[foodCount] = new Food();
    eat = false;
  }
  for(int i = 0; i <= foodCount; i++)
  {
    foods[i].update();
  }
}
void grid()
{
  int cols = round(width/tile);
  int rows = round(height/tile);
  stroke(40);
  for(int i = 0; i < rows; ++i)
  {
    line(0, i*tile, width, i*tile);
  }
  for(int i = 0; i < cols; ++i)
  {
    line(i*tile, 0, i*tile, height);
  }
}
class Food
{
  int xPos, yPos, r, g, b;
  Food()
  {
    r = round(random(150,220));
    g = round(random(150,220));
    b = round(random(150,220));  
    xPos = tile+round(random((width-tile*2)/tile))*tile;
    yPos = tile+round(random((height-tile*2)/tile))*tile;
  }
  void update()
  {
    if(snakes[0].xPos == xPos && snakes[0].yPos == yPos)
    {
      eat = true;
      r = round(random(125,255));
      g = round(random(125,255));
      b = round(random(125,255));  
      xPos = tile*2+round(random((width-tile*4)/tile))*tile;
      yPos = tile*2+round(random((height-tile*4)/tile))*tile;
      if(sLength < sMax) {
        sLength++;
        snakes[sLength-1] = new Snake(snakes[sLength-2].xPos, snakes[sLength-2].yPos, sLength-1);
      }
    }
    fill(r,g,b);
    rect(xPos, yPos, tile, tile);
  }
}
class Snake
{
  int xPos, yPos, xPrev, yPrev, xMove, yMove, id;
  Snake(int x,int y,int i)
  {
    rectMode(CORNER);
    xPos = x; yPos = y;
    xMove = 0; yMove = 0;
    id = i;
  }
  void update() 
  {
    if(isDead()) restart();
    else move();
    fill(sFill);
    rect(xPos, yPos, tile, tile);
  }
  void move()
  {
    if(!keyPressed) playRate = minPlayRate + round(minPlayRate/(2+foodCount));
    if(keyPressed && id == 0)
    { // The head of the snake is controlled with the WASD keys. Press Q to push it to the limit - Don't move backwards, just keep your head.
      if((key == 'a' || key == 'd' || key == 's') && !start) start = true; // Start by moving in any direction but up.
      if(key == 'q' && start) playRate = 2;
      if(key == 'a' && xPos != snakes[1].xPos+tile)
      {
        xMove = -tile;
        yMove = 0;
      }
      if(key == 'w' && yPos != snakes[1].yPos+tile)
      {
        xMove = 0;
        yMove = -tile;
      }
      if(key == 'd' && xPos != snakes[1].xPos-tile)
      {
        xMove = tile;
        yMove = 0;
      }
      if(key == 's' && yPos != snakes[1].yPos-tile)
      {
        xMove = 0;
        yMove = tile;
      }
    }
    if(id != 0)
    { // Other Snake object moves into the previous position of the snake object in front of it.
      xMove = 0;
      yMove = 0;
      if(snakes[id-1].xPrev < xPos)
      {
        xMove = -tile;
      }
      else if(snakes[id-1].xPrev > xPos)
      {
        xMove = tile;
      }
      else if(snakes[id-1].yPrev < yPos)
      {
        yMove = -tile;
      }
      else if(snakes[id-1].yPrev > yPos)
      {
        yMove = tile;
      }   
    }
    if(frameCount % playRate == 0 && start && !isDead())
    { // All positions are updated at set rates.
      xPrev = xPos;
      yPrev = yPos;
      xPos += xMove;
      yPos += yMove;
    }
  }
  void restart()
  {
    if(deathTime == -1) deathTime = frameCount;
    if(frameCount > deathTime+frameRate*1.5) setup();
  }
  boolean isDead()
  {
   if(id != 0 && xPos-snakes[0].xPos == 0 && yPos-snakes[0].yPos == 0) return true; // Die if a snake object is in the same space as the snake head.
   else if(xPos < 0 || xPos > width || yPos < 0 || yPos > height) return true; // Die if outside of the map.
   else if(deathTime != -1) return true; // Or just die if a time of death exists. Can a time of death exist before death? The universe doesn't care.
   else return false; // Otherwise continue... Though resistance is futile.
  }
}
