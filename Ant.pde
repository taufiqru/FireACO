 ArrayList<Ant> Ants = new ArrayList<Ant>();


class Ant {
  ArrayList<Node> tabuList = new ArrayList<Node>();
  ArrayList<Track> tabuTracks = new ArrayList<Track>();
  Path track;
  Point pt;
  float u, du, length1D;
  float w = 5;
  boolean finish =false;
  boolean announce = false;
  PImage img;
  
  Ant(Path track,ArrayList<Node> tabuList,ArrayList<Track> tabuTracks) {
    this.track = track;   
    this.u = 0;
    this.du = 1 / track.getLength();
    this.length1D = 25 / track.getLength();
    this.pt = new Point(0, 0);  
    this.tabuList = tabuList;
    this.tabuTracks = tabuTracks;
    img = loadImage("asset/1.png");
  }
  
 
  
  void step() {
    u = Path.remainder(u + du, 1);
    //println(u);
    if(u>=0.99){
      finish=true;
    }
  }
  
  void draw(PGraphics g) {
      float v = u;
      track.trace(pt, v);
     // stroke(0);
      fill(255,0,0);
      //strokeWeight(12);
      //ellipseMode(CENTER);
      pushMatrix();
      translate(pt.x, pt.y);
      //rotate(atan2(0,0));
      //ellipse(0,0,3,3);
      imageMode(CENTER);
      image(img,0,0,img.width/5,img.height/5);
      popMatrix();
   }
  
  float totalDistance(){
    float total=0;
    for(Track t:tabuTracks){
      total = total+t.distance;
    }
    return total;
  }
  
}
