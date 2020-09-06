import tracer.*;
import controlP5.*;
import tracer.paths.*;
import static javax.swing.JOptionPane.*;
import java.util.*; 

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;


//Variables//
float rho = 1.0;
int alpha=1;
int beta =1;
float cfire = 1.0; 
//


ControlP5 cp5;
//mouse locked to grid
Point quantizedMouse;
//grid
int cellSqrt = 5;

//tracks
Shape currTrack;
ArrayList<Shape> tracks = new ArrayList<Shape>();
Boolean select=false; 
Boolean selectExit = false;
Boolean selectEntry = false;
Boolean selectFire = false;
Boolean deleteFire = false;
Node selected;
char label = 'A';
int labelNode = 1;
Node oldExitNode;
PImage bg;

void settings() {
  size(704, 492); //emergency.png
  //size(1200, 675); //basement.png
  //800x543
  //704x492
  //1200x675
}

void setup() {
  restart();
  cp5 = new ControlP5(this);
  cf = new ControlFrame(this,300,675,"Controls");
  //bg = loadImage("asset/basement_.png");
  bg = loadImage("asset/emergency.png");
  surface.setLocation(320,10);
  noCursor();  
  currTrack = new Shape();
  currTrack.setFill(false);
  quantizedMouse = new Point(quantize(mouseX, 0, cellSqrt), quantize(mouseY, 0, cellSqrt));
}

void draw() {
  background(bg);
  drawGrid(cellSqrt);
  drawDot(5, color(0), mouseX, mouseY);
  drawDot(10, color(0), quantizedMouse.x, quantizedMouse.y);
  
  currTrack.draw(g);
  for (Shape track : tracks) {
    track.draw(g); 
  }
  
  for (Node n : Nodes) {
    n.draw();
  }
  
  for (Track t : Tracks) {
   if(t.tipe=="origin"){
    t.draw();
    t.updateString();
   }
  }
  
  for (Track t : bestRoutes) {
    t.drawBestRoute();
  }
  
  displayFire();
  
  for (Ant t : Ants) {
    if(t.finish){
     if(t.announce==false){
      // println("semut-"+Ants.indexOf(t)+" selesai!");
       t.announce=true;
      }
    }else{
      t.step();
      t.draw(g);
    }
  }
}

void mouseMoved() {
  quantizedMouse.x = quantize(mouseX, 0, cellSqrt);
  quantizedMouse.y = quantize(mouseY, 0, cellSqrt);
}

void mousePressed() {
  if (mouseButton == RIGHT){
    select = false;
    Node x = new Node(Integer.toString(labelNode),quantizedMouse.x,quantizedMouse.y,"");
    addNode(x);
    //println(quantizedMouse.x+","+quantizedMouse.y);
  }
  if(mouseButton == LEFT){
    if(!select){
      int search = searchNode(quantizedMouse.x,quantizedMouse.y);
      if(search==-1 && !selectFire && ! deleteFire){
        println("bukan node!");
      }else if(selectFire){
          Fire f = new Fire(quantizedMouse.x,quantizedMouse.y); 
          fire.add(f);
          println(" Api ditambahkan");
          cekCollision(f);
          selectFire = false;
        } else if(deleteFire){
          hapusApi(quantizedMouse.x,quantizedMouse.y);
          deleteFire = false;
        }
      else{
        if(selectExit){
          if(oldExitNode!=null){
            //oldExitNode.tipe = "";
          }
          Node x = Nodes.get(search); 
          x.tipe = "EXIT";
          oldExitNode = x;
          println("Node-"+x.label);
          selectExit=false;
        }else if(selectEntry){
          entryPoint.add(search);
          Node x = Nodes.get(search);
          x.tipe = "ENTRY";
          println("Node-"+x.label);
          selectEntry = false;
        }
        else{
          Node x = Nodes.get(search); 
          selected = x;
          select = true;
          println("Node-"+search+" dipilih");
        }
      }
    }else{
      Node start = selected;
      Node end = new Node(Integer.toString(labelNode),quantizedMouse.x,quantizedMouse.y,"");
     // println(quantizedMouse.x+","+quantizedMouse.y);
      addNode(end);
      float dist =  inputDistance();
      Track newTrack = new Track(Character.toString(label),start.x,start.y,end.x,end.y,dist,"origin");
      addTrack(newTrack);
      select = false;
    }
   }
}

void keyPressed(){
  if(key == CODED){
    }else{
      if(key == ' '){
        if(entryPoint.size()<=0){
          showMessageDialog(null,"Entry Point Belum Di Inisialisasi!","Perhatian!",ERROR_MESSAGE);
        }else{
          algoStep.add("Step by step Semut-"+(Ants.size()+1)+":");
          int rand = (int)random(0,entryPoint.size());
          chooseTrack(Nodes.get(entryPoint.get(rand)));
          addShortestEachRoute(Nodes.get(entryPoint.get(rand)));
        }
        
      }
      if(key == 'x'){
        print("Pilih Exit Point : ");
        selectExit = true; 
       }
      if(key == 's'){
        print("Pilih Entry Point :");
        selectEntry = true;
      } 
      if(key == 'f'){
        print("Pilih Titik Api :");
        selectFire = true;
      } 
       if(key == 'd'){
        print("Hapus Titik Api :");
        deleteFire = true;
      } 
       if(key == 'p'){
         saveThisPreset();
       }
    }
  
}

void chooseTrack(Node start){
    ArrayList<Integer> result = new ArrayList<Integer>();
    Point vtx = new Point(start.x,start.y); //node
    int i = currTrack.getVertexCount();
    currTrack.addVertex(i, vtx);
    tabuList.add(start);
    
    if(start.tipe != "EXIT"){
      result = searchTrack(start); // hasil -> list daftar track yang dapat dilalui
      if(result.size()>0){
        int choose;
        int val = searchExit(result);
        //int choose = int(random(0,result.size())); // pilih secara random gak pake ACO
        if(val!=-98){
          choose = val;
        }else{
          choose = algoACO(result); ///formula ACO menentukan track yang akan dilalui
        }
        Track x = Tracks.get(result.get(choose)); //track yang dilalui sudah ditentukan
        algoStep.add("memilih jalur :"+x.label); //debug
        tabuTracks.add(x);
        int chooseNode = searchNode(x.endX,x.endY);
        chooseTrack(Nodes.get(chooseNode)); //rekursif sampai ketemu node ujung
      }else{
          if(tabuList.get(tabuList.size()-1).tipe=="EXIT"){
            Ant a = new Ant(currTrack,tabuList,tabuTracks);
            Ants.add(a);
            //debug
            //printAlgoStep();
            logTracks(a);
            printLogTracks();
            resetLog();
            //
            updatePheromone(a.tabuTracks,a.totalDistance());//update feromon
            tracks.add(currTrack);
          }
          currTrack = new Shape();
          currTrack.setFill(false);
          tabuList.clear();
          tabuTracks.clear();
        }
    }else{
      if(tabuList.get(tabuList.size()-1).tipe=="EXIT"){
            Ant a = new Ant(currTrack,tabuList,tabuTracks);
            Ants.add(a);
            //debug
            //printAlgoStep();
            logTracks(a);
            printLogTracks();
            resetLog();
            //
            updatePheromone(a.tabuTracks,a.totalDistance());//update feromon
            tracks.add(currTrack);
      }
      currTrack = new Shape();
      currTrack.setFill(false);
      tabuList.clear();
      tabuTracks.clear();
     
    }
}

void drawDot(float strokeWeight, int c, float x, float y) {
  strokeWeight(strokeWeight);
  stroke(c);
  point(x, y);
}

void drawGrid(int cellSqrt) {
  strokeWeight(1);
  stroke(0, 25);

  int x = 0;
  while (x < width) {
    line(x, 0, x, height);
    x += cellSqrt;
  }

  int y = 0;
  while (y < height) {
    line(0, y, width, y);
    y += cellSqrt;
  }
}

static float quantize(float val, float min, float quantum) {
  val -= min;
  val /= quantum;
  val = round(val);
  return min + val * quantum;
}

float inputDistance(){
  String input;
  String string = "1";
  do {
      input = showInputDialog("Input Distance :");
      if(input!=null){
          if (input.matches("^[0-9]*$")) {
            string = input;
        } else {
           showMessageDialog(null,"Please enter a valid numbers");
        }
      }else{
        input = "1";
        string = input;
      }
      
  } while (!input.matches("^[0-9]*$"));
  return parseInt(string);
}

void restart(){
    removeAnts(Ants);
    removeTracks(Tracks);
    removeNodes(Nodes);
    removeTrack(tracks);
    entryPoint.clear();
    saveLog.clear();
    bestRoutes.clear();
    tabuTracks.clear();
    tabuList.clear();
    label = 'A';
    labelNode = 1;
}

void removeTrack(ArrayList<Shape> arr){
  for(int i=arr.size()-1;i>=0;i--){
    arr.remove(i);
  }
}

void removeAnts(ArrayList<Ant> arr){
  for(int i=arr.size()-1;i>=0;i--){
    arr.remove(i);
  }
}

void removeTracks(ArrayList<Track> arr){
  for(int i=arr.size()-1;i>=0;i--){
    arr.remove(i);
  }
}

void removeNodes(ArrayList<Node> arr){
  for(int i=arr.size()-1;i>=0;i--){
    arr.remove(i);
  }
}

void removeCP5(){
  for(int i=listOflabel.size()-1;i>=0;i--){
    cp5.remove(listOflabel.get(i));
  }
  listOflabel.clear();
}

void listCP5(){
  for(Track t:Tracks){
   listOflabel.add( t.myTextlabel.getLabel());
  }
}
