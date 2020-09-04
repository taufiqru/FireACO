//notes//
ArrayList<String> algoStep = new ArrayList<String>(); //step by step kalkulasi
ArrayList<String> stepTracks = new ArrayList<String>(); //step-by step rute semut
ArrayList<String> listOfBestRoute = new ArrayList<String>(); //daftar rute tercepat
ArrayList<String> listOflabel = new ArrayList<String>(); //digunakan ketika preset
ArrayList<String> saveLog = new ArrayList<String>(); //digunakan untuk save to txt
ArrayList<Object[]> shortestEachRoute = new ArrayList<Object[]>(); //penampung jalur terpendek tiap rute

ArrayList<Track> bestRoutes = new ArrayList<Track>(); //untuk visualisasi semua rute terbaik
//Shape currBestRoute;
  
// Float shortestPath = 99999.0;
String bestRoute = "";


void printAlgoStep(){
  for(String x:algoStep){
    println(x);
  }
}

void printLogTracks(){
  for(String x:stepTracks){
    println(x);
  }
}

void resetLog(){
  saveLog.addAll(algoStep);
  saveLog.addAll(stepTracks);
  saveLog.add("\n******************\n");
  stepTracks.clear();
  algoStep.clear();
}

void saveToFile(){
  String[] record = new String[saveLog.size()];
  int i=0;
  
  for(String s:saveLog){
    record[i] = s;
    i++;
  }
  saveStrings("aco_log.txt",record);
  println("Log Simulasi telah disimpan! (aco_log.txt)");
}

void logTracks(Ant x){
  String jalur="";
   stepTracks.add("Jalur yang dilalui Semut-"+(Ants.size())+":");
  for(Track t:x.tabuTracks){
    jalur=jalur+t.label+"->";
  }
  stepTracks.add(jalur+"EXIT");
  stepTracks.add("Total jarak :"+x.totalDistance());
  checkBestRoute(x,jalur);
}

void checkBestRoute(Ant x,String jalur){
  Node start = x.tabuList.get(0);
  for(Object ob[]: shortestEachRoute){
    if(sameNode((Node)ob[0],start)){
      float shortestPath = (Float)ob[1];
      if(x.totalDistance()<=shortestPath){
          if(x.totalDistance()==shortestPath){
             shortestPath = x.totalDistance();
             bestRoute = jalur+"EXIT";
             tambahBestRoute(bestRoute,x.tabuList.get(0).label,x.totalDistance());
             addBestRoute(x.tabuTracks);
             printBestRoute();
             ob[1] = shortestPath;
          }else{
            listOfBestRoute.clear();
            bestRoutes.clear();
            shortestPath = x.totalDistance();
            bestRoute = jalur+"EXIT";
            tambahBestRoute(bestRoute,x.tabuList.get(0).label,x.totalDistance());
            addBestRoute(x.tabuTracks);
            printBestRoute();
            ob[1] = shortestPath;
          }
      }
    }
  }
}


void printBestRoute(){
  String txt = "";
  String saveTxt="";
  for(String s:listOfBestRoute){
    txt = txt +s +"\n";
  }
  saveTxt = "Rute Terpendek : \n"+txt;
  cf.bestTextarea.setText(saveTxt);
}

void addBestRoute(ArrayList<Track> tabuTracks){
  bestRoutes.addAll(new ArrayList<Track>(tabuTracks));
}

int searchForDuplicate(String txt){
  for(String val:listOfBestRoute){
    if(val.equals(txt)){
      return -99;
    }
  }
  return 0;
}

void tambahBestRoute(String txt, String start, float d){
  if(searchForDuplicate(txt)==0){
    listOfBestRoute.add("Dari Node  :"+start);
    listOfBestRoute.add(txt);
    listOfBestRoute.add("Jarak :"+d+"\n");
  }
}

void addShortestEachRoute(Node x){
  Boolean res =false;
  for(Object ob[]: shortestEachRoute){
    if(sameNode((Node)ob[0],x)){
      res=true;
    }
  }
  if(!res){
    Object data[] = {x,9999.0};
    shortestEachRoute.add(data);
  }
}
