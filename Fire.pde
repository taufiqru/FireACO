ArrayList<Fire> fire = new ArrayList<Fire>();
Float fireImportance = 1.0;

void displayFire(){
  for(int i= fire.size()-1; i>=0;i--){
    if(fire.get(i).status){
     fire.get(i).display();
    }else{
      fire.remove(i);
    }
  }
}
class Fire{
  ArrayList<Track> block = new ArrayList<Track>();
  int w = 20;
  int h = 20;
  float x,y;
  boolean status=true;
  PImage img;
  
  Fire(float x, float y){
    this.x = x;
    this.y = y;
    img = loadImage("asset/fire.png");
  }
  
  void display(){
    noStroke();
    noFill();
    rectMode(CENTER);
    rect(x,y,img.width/3,img.height/3);
    imageMode(CENTER);
    image(img,x,y,img.width/3,img.height/3);
  }
}
