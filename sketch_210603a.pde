import processing.sound.*;
Amplitude amp;
FFT fft;
SoundFile sample;


int bands = 64;
float[] spectrum = new float[bands];//stores spectrum
float rotation = (2*PI)/bands;//rotation based on the number of bands


//preps background and particle list
ArrayList<Ball> ballList;
PImage image;


public void setup(){//start of setup
  size(1280,720);
  noStroke();//removes the default black stroke on the particles
  //no background needed in setup since image is background
  
  //audio is loaded and looped
  sample = new SoundFile(this, "Lil Nas X - Panini (Official Video).mp3");
  sample.loop();
  
  //inputs the audio to be analyzed
  amp = new Amplitude(this);
  amp.input(sample);
  fft = new FFT(this, bands);
  fft.input(sample);
  
  ballList = new ArrayList<Ball>(); //this creates the list
  image = loadImage("wp4831359.png");//loads the background image
  
  
}//end of setup




void draw(){//start of draw
  
  
  float a = amp.analyze() * 100;
  fft.analyze(spectrum);
  

    if(frameCount % 2 == 0){//only runs every two frames
    for(int i = 0; i <= bands -1; i++){ //this adds rectangles to the list
      float x = width/2;
      float y = height/2;
      float s = 1000*spectrum[i];
      
      int circleWidth = int(width/7+a*2);
      
      s = map(s, 0, 50, 2, 8);
      if (s > 8){
        s = 8;
      }
      //println(s);
      x += circleWidth * cos(rotation * i);
      y += circleWidth * sin(rotation * i);
      
      if(s > 2.5){
        
        for(int j = 0; j < 2; j++){
          ballList.add(new Ball(x, y, random(2, 10), rotation, i , s));
        }
      }
      }
    }
    
    
  float transp = 128;//keeps track of transparency for the image
  
  //the bigger 'a' is the more particles
  if(a > 50){//changes transparency of image based on audio
    transp = 128 + a;
  }
  
  
  background(0);
  image(image, 0, 0); 
  tint(255,transp);//changes transparency of the image (tint)
  
 
  for(int i = 0; i < ballList.size(); i++){
    Ball b = ballList.get(i); //set the ball from the list to the variable b
    b.display();
    b.move();
    
    if(b.removeList() == true){
      ballList.remove(i);
      }
    
    }//end of for

  fill(255, 255, 255, 101);
  textSize(20);
  text("press the left mouse button", 40, 20);

}//end of draw


int c = 1;//counter variable to track backgrouds
void mousePressed() {//changes background when mouse pressed
  println("mousepress");
  if (c == 1){
  image = loadImage("calm-sunset-digital-art-landscape-rz-1280x720.jpg");
  c = 2;
  }
  else if (c == 2){
    image = loadImage("1.jpg");
    c = 3;
  }
  else if (c == 3){
    image = loadImage("2.jpg");
    c = 4;
  }
  else if (c == 4){
    image = loadImage("3.jpg");
    c = 5;
  }
  else if (c == 5){
    image = loadImage("4.jpg");
    c = 6;
  }
  else if (c == 6){
    image = loadImage("wp4831359.png");
    c = 1;
  }
}



//Class for the rectangular objects
class Ball {
  //declaring variables
  float x;//coordinates
  float y;
  float a; //alpha (transparency)
  float w; //width of the ball
  float mx;
  float my;//vertical movement
  float r;
  float g;
  float b;
  float rotation;
  float i;
  float life;
  
  
  Ball(float tempX, float tempY, float tempW, float tempRot, float band, float Templife) {//constructor
    x = tempX;
    y = tempY;
    w = tempW;
    a = 255;
    mx = random(-w, w)/1.5; //set a random direction
    
    rotation = tempRot;//direction for the particle to go
    i = band;
    life = 100 / (10*Templife);//lifetime of the particle
    
    //changes the colour profile based on counter var
    if (c % 2 == 0){
      r = 255;
      g = 182;
      b = 46;
    }
    else{
      r = 50;
      g = 200;
      b = 255;
    }
    
    //changes y-velocity based on the background
    if (c == 1 || c == 2){
    my = -mx;
    
    }
    else if (c == 3 || c == 4){
      my = mx;
      
    }
    else if (c == 5 || c == 6){ 
      my = random(0, w + 18);
    }
    }
  
  
  void move() {
    //moves the particles downwards and decreases transparency
    if (c == 5 || c == 6){
      y += my;
    }
    else{
    x += mx * cos(rotation * i);
    y -= my * sin(rotation * i);
    }
    a-= life*5;
    
    //particle colour changes as they move
    //different colour profile for each background
    if (c == 6){
      g -= my * 2;
    }
    else if (c == 5){
      r = 50 + my*10;
      g = 200 - my*5;
      b = 255 - my*5;
    }
    else if (c % 2 == 0){
    r = 255 - (my*(-40));
    g += (my*(-70));
    }
    else{
      r = 50 + (my*(-70));
      g = 200 - (my*(-40));
      b = 255 - (my*(-40));
      
    }
  }

  
  
  Boolean removeList(){
  
    //if the ball is totally transparent remove from the list
    if(a > 0){
      return false;
      }
    else{
      return true;
      }
    
  }
  
  
  
  void display() {
    // Display the rectangle
    fill(r,g,b,a);
    rect(x,y,w,w+10);
    }
  }
