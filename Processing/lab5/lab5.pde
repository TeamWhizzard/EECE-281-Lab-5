float topAngle = 0;
float botAngle = QUARTER_PI;
int window = 600;
int border = 60;
float middle = window / 2;
float boundry = window - border;
float angle;
PImage bgImage;

void setup(){
  size(window, window);
  bgImage = loadImage("radar.jpg");
}

void draw() {
  background(bgImage);
  automaticRadar(true); // toggle for radar by touch/click or rolling radar
  fill(50, 100, 50, 100); // 4th value is alpha channel (transparency)
  strokeWeight(0);
  arc(middle, middle, boundry, boundry, topAngle, botAngle); // radar slice
  fill(0);
  ellipseMode(CENTER);
  ellipse(middle - 1, middle - 1, 50, 50); // middle black circle to chop off radar slice
}

void mousePressed() {
  redraw();
}

void automaticRadar(boolean auto) {
 if (auto) {
   topAngle += 0.01; // move forward every 0.05 every frame
   botAngle += 0.01;
   loop();
 } else {
   angle = atan2(mouseY - height / 2, mouseX - width / 2);
   topAngle = angle - PI / 8;
   botAngle = angle + PI / 8;
   noLoop();
 }
}
