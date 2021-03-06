/*Collision Detection when adding Fire into Simulation */

void cekCollision(Fire f){
  int i=0;
  for(Track t: Tracks){
    if(lineRect(t.startX,t.startY,t.endX,t.endY,f.x,f.y,f.w,f.h))
    {
      println("Api muncul pada rute : "+t.label);
      Tracks.get(i).blockedbyfire = true;
      f.block.add(t);
      resetBestRoute();
    }
    i++;
  }
}

void hapusApi(float x,float y){
  for(Fire f:fire){
    if(pointRect(x,y,f.x,f.y,f.w,f.h)){
      f.status=false;
      for(int i =f.block.size()-1;i>=0;i--){
        for(Track t:Tracks){
          if(t.label==f.block.get(i).label){
            println("Api pada rute-"+t.label +" padam");
            t.blockedbyfire=false;
          }
        }
        f.block.remove(i);
        resetBestRoute();
      }
    }
  }
}


// LINE/RECTANGLE
boolean lineRect(float x1, float y1, float x2, float y2, float rx, float ry, float rw, float rh) {

  // check if the line has hit any of the rectangle's sides
  // uses the Line/Line function below
  boolean left =   lineLine(x1,y1,x2,y2, rx,ry,rx, ry+rh);
  boolean right =  lineLine(x1,y1,x2,y2, rx+rw,ry, rx+rw,ry+rh);
  boolean top =    lineLine(x1,y1,x2,y2, rx,ry, rx+rw,ry);
  boolean bottom = lineLine(x1,y1,x2,y2, rx,ry+rh, rx+rw,ry+rh);

  // if ANY of the above are true, the line
  // has hit the rectangle
  if (left || right || top || bottom) {
    return true;
  }
  return false;
}

// LINE/LINE
boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  // calculate the direction of the lines
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
    return true;
  }
  return false;
}

boolean pointRect(float px, float py, float rx, float ry, float rw, float rh) {

  // is the point inside the rectangle's bounds?
  if (px >= rx &&        // right of the left edge AND
      px <= rx + rw &&   // left of the right edge AND
      py >= ry &&        // below the top AND
      py <= ry + rh) {   // above the bottom
        return true;
  }
  return false;
}
