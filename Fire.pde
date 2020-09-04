ArrayList<Fire> fire = new ArrayList<Fire>();

void displayFire(){
  for(int i= fire.size()-1; i>=0;i--){
    if(fire.get(i).status){
     fire.get(i).display();
    }else{
      fire.remove(i);
    }
  }
  
  
  for(Fire f: fire){
   
  }
}
class Fire{
  int w = 20;
  int h = 20;
  float x,y;
  boolean status=true;
  Fire(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void display(){
    fill(255,0,0);
    //rectMode(CENTER);
    rect(x,y,w,h);
  }
}
