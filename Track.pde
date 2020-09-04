ArrayList<Track> Tracks = new ArrayList<Track>();
ArrayList<Track> tabuTracks = new ArrayList<Track>();

int searchTrack(Track x){
  int i = 0;
  for (Track t : Tracks){
    if(t.startX==x.startX && t.startY==x.startY && t.endX==x.endX && t.endY == x.endY){
     return i;
    }
    i++;
  }
  return -1;
}


ArrayList<Integer> searchTrack(String label){
  ArrayList<Integer> listTrack = new ArrayList<Integer>();
  int i = 0;
  for (Track t : Tracks){
    //println(t.label);
    if(t.label==label){
     listTrack.add(i);
    }
    i++;
  }
  return listTrack;
}



ArrayList<Integer> searchTrack(Node x){
  ArrayList<Integer> listTrack = new ArrayList<Integer>();
  int i= 0 ;
  for(Track t:Tracks){
    if(t.startX==x.x && t.startY == x.y){
      //search node (t.endX && t.endY) yang belum ada di tabu list 
      if(searchNodeTabu(t.endX,t.endY)==-1){
        listTrack.add(i);
      }
    }
    i++;
  }
  return listTrack;
}

void addTrack(Track x){
  if(searchTrack(x)==-1){
    if(!(x.startX==x.endX && x.startY==x.endY)){
      Tracks.add(x);
      Track reverseNewTrack = new Track(Character.toString(label),x.endX,x.endY,x.startX,x.startY,x.distance,"reversed");
      Tracks.add(reverseNewTrack);
    }
  }
  label++;
}

class Track{
 float startX,startY,endX,endY,distance;
 double pheromone;
 String label,tipe;
 
 Textlabel myTextlabel;
 
 
 Track(String label,float sX,float sY, float eX, float eY, float distance,String tipe){
   this.tipe = tipe;
   this.label = label;
   this.startX = sX;
   this.startY = sY;
   this.endX = eX;
   this.endY = eY;
   this.distance = distance;
   this.pheromone = 1;
   this.setup();
 }
 
 void setup(){
    String txt="";
    myTextlabel = cp5.addTextlabel(this.label+"-"+this.tipe)
                    .setText(txt)
                    .setPosition(((endX+startX)/2)-5,((endY+startY)/2)-20)
                    .setColorValue(0x000000)
                    .setFont(createFont("Georgia",12))
                    ;
 }
 
 void draw(){
  stroke(0,0,0,50);
  strokeWeight(3);
  line(startX,startY,endX,endY);
 }
 
 void updateString(){
    String txt;
    txt = label +"= "+distance+", ph = "+this.pheromone;
    myTextlabel.setValue(txt);
 }
 
 void drawBestRoute(){
   stroke(0,255,0);
   fill(0,255,0);
   //strokeWeight(12);
  line(startX,startY,endX,endY);
 }
 
 
}
