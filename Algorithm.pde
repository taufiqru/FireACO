// Ant Colony Optimization

int algoACO(ArrayList<Integer> possibleTrack){
  /* didalam possible track ada index dari track yang mungkin di lewati semut*/
  ArrayList<Double> prob = new ArrayList<Double>(); //menampung nilai probabilitas tiap track
  
  Track curr;
  double T,n,total,p,roullete ;
  
  //
  String jarak="0";
  String Prob="0";
  String formula="";
  //
  
  total = 0;
  
  algoStep.add("Memulai pemilihan jalur :\n");//debug
  
  /* total distance*/
  for (int t : possibleTrack){
     curr = Tracks.get(t);
     T = (double)curr.pheromone;
     n = 1/curr.distance;
     total = total+Math.pow(T,alpha)*Math.pow(n,beta);
     jarak = jarak+"+("+T+")^"+alpha+" x "+"( 1/"+curr.distance+")^"+beta;
     
  }
  
  /*probabilitas masing" track*/
  for (int t : possibleTrack){
     curr = Tracks.get(t);
     //println(curr.label);
     algoStep.add(curr.label); //debug 
     //
     T = (double)curr.pheromone;
     n = 1/curr.distance;
     p = Math.pow(T,alpha)*Math.pow(n,beta)/total;
   //  p = Math.floor(p);
     prob.add(p);
     //debug
     Prob = "("+T+")^"+alpha+"x("+1+"/"+curr.distance+")^"+beta;
     formula = "("+Prob+")/"+jarak+"="+p;
     //println(formula);
     algoStep.add(formula);
     //
  }
  
 
  
  roullete = RoulleteWheel(prob);
  int count = 0;
  for (double t:prob){
    if(t==roullete){
      algoStep.add("memilih :"+t +", opsi :"+count);
      return count;
    }
    count ++;
  }
  
  return -99;
}

//Roullete wheel
double RoulleteWheel(ArrayList<Double> prob){
  //debug
  String rolet="";
  String val="";
  //
  
  
  
  ArrayList<Double> temp = new ArrayList<Double>(prob); //copy dari prob untuk roulette wheel
  ArrayList<Double> cumSum = new ArrayList<Double>();
  double rand;
  
  algoStep.add("Memulai Roullete Wheel : \n");
  
  //temp = prob; //copy prob ke temp
  Comparator c = Collections.reverseOrder();
  Collections.sort(temp,c); //sorting value prob
  
  for(double f:temp){
    val=val+f+"|";
  }
  algoStep.add(val);//debug
  //println("");
  
  int i=0;
  double cum = 1;
  rolet = rolet+cum+"|";
  
  cumSum.add((double)1);
  
  for(i=0;i<temp.size();i++){
    cum = cum-temp.get(i);
    rolet = rolet+cum+"|";
    cumSum.add(cum);
  }
  
  algoStep.add(rolet); //debug
  //println("");
  
  rand = random(0,1);
  
  algoStep.add("nilai random : "+rand);//debug
  
  for(i=0;i<cumSum.size()-1;i++){
    if(rand<cumSum.get(i) && rand>=cumSum.get(i+1)){
      algoStep.add("berada pada posisi :"+i);
      return temp.get(i);
    }
  }
  
  return -99;
}

//update feromon
void updatePheromone(ArrayList<Track> tabuTracks,double totalDistance){
  Track temp;
  int idx=-99;
  for(Track t:tabuTracks){
   idx = searchTrack(t);
   temp=Tracks.get(idx);
   temp.pheromone = (1-rho)*temp.pheromone + 1/totalDistance + temp.pheromone;
   for(int x: searchTrack(t.label)){
     Tracks.get(x).pheromone = Math.round(temp.pheromone*100)/100.0d; //pembulatan jumlah feromone supaya digit tidak terlalu panjang
   }
   
  }
}
