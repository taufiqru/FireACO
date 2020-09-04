ArrayList<Node> Nodes = new ArrayList<Node>();
ArrayList<Node> tabuList = new ArrayList<Node>();
ArrayList<Integer> entryPoint = new ArrayList<Integer>();

void addNode(Node x){
  if(searchNode(x.x,x.y)==-1){
    Nodes.add(x);
    labelNode++;
  }
  
}

boolean sameNode(Node A, Node B){
  if(A.x == B.x && A.y == B.y){
    return true;
  }
  return false;
}


int searchNode(float x, float y){
  int i = 0;
  for (Node n : Nodes) {
    if(n.x == x && n.y == y ){
      return i;
    }
    i++;
  }
  return -1;
}

int searchNodeTabu(float x,float y){
  int i = 0;
  for (Node n : tabuList) {
    if(n.x == x && n.y == y ){
      return i;
    }
    i++;
  }
  
  return -1;
}

class Node{
  String label;
  float x,y;
  int nodeSize=3;
  String tipe;
  
  Node(String label,float x, float y, String tipe){
    this.label = label;
    this.x = x;
    this.y = y;
    this.tipe = tipe;
  }
  
  void draw(){
      stroke(0);
      if(tipe=="EXIT"){
        fill(0,0,255);
      }else if(tipe == "ENTRY"){
        fill(215,19,229);
      }
      else{
        fill(255,0,0);
      }
      text(label,x-15,y-5);
      ellipseMode(CENTER);
      ellipse(x,y,10,10);
      fill(255,0,0);
  }
  
  
}
