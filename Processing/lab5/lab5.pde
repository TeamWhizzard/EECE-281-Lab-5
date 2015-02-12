float topAngle = 0;
float botAngle = QUARTER_PI;
int window = 600;
int border = 10;
float middle = window / 2;
float boundry = window - border;

PImage bgImage;

void setup(){
  size(window, window);
  //smooth();
  bgImage = loadImage("gandolf.jpg");
}

void draw() {
  background(bgImage);
  float angle = atan2(mouseY-height/2, mouseX-width/2);
  topAngle = angle - PI / 8;
  botAngle = angle + PI / 8;
  // topAngle += 0.01; // move forward every 0.05 every frame
  // bottomAngle += 0.01;
  fill(50, 100, 50, 100);
  arc(middle, middle, boundry, boundry, topAngle, botAngle);
  noLoop();
}

void mousePressed() {
  redraw();
}

