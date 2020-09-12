int playRate, defaultPlayRate, frameRate, deathTime, sLength, sFill, xtraFood;
boolean die, start, eat, fast;
int sMax = 50;
int tile = 10;
Snake[] snakes = new Snake[sMax];
Food[] foods = new Food[sMax]; 
void setup()
{
  xtraFood = 0;
  playRate = 10;
  defaultPlayRate = playRate;
  frameRate = 100;
  deathTime = -1;
  sLength = 4;
  sFill = 250;
  die = false;
  start = false;
  eat = false;
  fast = false;
  size(840,720);
  frameRate(frameRate);
  for(int i = 0; i < sLength; i++) {
    snakes[i] = new Snake(width/2, height/2-i*tile, i);
  }
  foods[0] = new Food();
}
void draw()
{
  background(0);
  for(int i = 0; i < sLength; i++)
  {
    snakes[i].update();
  }
  foods[0].update();
  if(sLength % 6 == 0 && eat)
  {
    ++xtraFood;
    foods[xtraFood] = new Food();
    eat = false;
  }
  for(int i = 0; i <= xtraFood; i++)
  {
    foods[i].update();
  }
}
class Food
{
  int xpos, ypos, r, g, b;
  Food()
  {
    println("Food Spaaawned.");
    r = round(random(150,220));
    g = round(random(150,220));
    b = round(random(150,220));  
    xpos = tile+round(random((width-tile*2)/tile))*tile;
    ypos = tile+round(random((height-tile*2)/tile))*tile;
  }
  void update()
  {
    if(snakes[0].x == xpos && snakes[0].y == ypos)
    {
      eat = true;
      println("Food Respawn.");
      r = round(random(150,220));
      g = round(random(150,220));
      b = round(random(150,220));  
      xpos = tile+round(random((width-tile*2)/tile))*tile;
      ypos = tile+round(random((height-tile*2)/tile))*tile;
      sLength++;
      snakes[sLength-1] = new Snake(snakes[sLength-2].x, snakes[sLength-2].y, sLength-1);
    }
    fill(r,g,b);
    rect(xpos, ypos, tile, tile);
  }
}
class Snake
{
  int x, y, nx, ny, xs, ys, s, r, id;
  int nx() {return nx;}
  int ny() {return ny;}
  Snake(int bx,int by,int i)
  {
    rectMode(CENTER);
    x = bx; y = by;
    nx = x; ny = y;
    xs = 0; ys = 0;
    s = tile;
    id = i;
    
    println(id + " Snake born.");
  }
  void update() 
  {
    if(isDead()) restart();
    move();
    fill(sFill);
    rect(x, y, tile, tile);
  }
  void move()
  {
    if(!keyPressed) playRate = defaultPlayRate - xtraFood;
    if(keyPressed && id == 0)
    {
      start = true;
      if(key == 'q')
      {
        if(playRate == defaultPlayRate - xtraFood) playRate = 1;
        else playRate = defaultPlayRate - xtraFood;
      }
      if(key == 'a' && x != snakes[1].x+tile)
      {
        xs = -s;
        ys = 0;
      }
      else if(key == 'w' && y != snakes[1].y+tile)
      {
        xs = 0;
        ys = -s;
      }
      else if(key == 'd' && x != snakes[1].x-tile)
      {
        xs = s;
        ys = 0;
      }
      else if(key == 's' && y != snakes[1].y-tile)
      {
        xs = 0;
        ys = s;
      }
    }
    if(id != 0)
    {
      xs = 0;
      ys = 0;
      if(snakes[id-1].nx() < x)
      {
        //println(id + "left");
        xs = -s;
        ys = 0;
      }
      if(snakes[id-1].nx() > x)
      {
        //println(id + "right");
        xs = s;
        ys = 0;
      }
      if(snakes[id-1].ny() < y)
      {
        //println(id + "up");
        ys = -s;
        xs = 0;
      }
      if(snakes[id-1].ny() > y)
      {
        //println(id + "down");
        ys = s;
        xs = 0;
      }
        
    }
    if(frameCount % playRate == 0 && start)
    {
      nx = x;
      ny = y;
      x += xs;
      y += ys;
    }
  }
  void restart()
  {
    println("DEATH");
    sFill = 0;
    if(deathTime == -1) deathTime = frameCount;
    println(frameCount-deathTime);
    if(frameCount > deathTime+frameRate/2) setup();
  }
  boolean isDead()
  {
   if(id != 0 && x-snakes[0].x == 0 && y-snakes[0].y == 0) return true;
   else if(x < 0 || x > width || y < 0 || y > height) return true;
   else if(deathTime != -1) return true;
   else return false;
  }
}
