ControlFrame cf;
//boolean finish=false;


class ControlFrame extends PApplet{
  Robot robot;
  Textarea consoleTextarea;
  Textarea bestTextarea;
  Button preset,savelog,help;
  int w,h;
  PApplet parent;
  ControlP5 cp5;
  Println console;
 
  
  public ControlFrame(PApplet _parent, int _w,int _h, String _name){
    super();
    parent = _parent;
    w = _w;
    h = _h;
    PApplet.runSketch(new String[]{this.getClass().getName()},this);
  }
  
  public void settings(){
    size(w,h);
  }
  public void setup(){
  //  try { 
  //  robot = new Robot();
  //} catch (AWTException e) {
  //  e.printStackTrace();
  //  exit();
  //}
   
    surface.setLocation(10,10);
    cp5 = new ControlP5(this);
    
    cp5.addTextlabel("Label_Parameter")
       .setText("Pengaturan Parameter :")
       .setPosition(10,10)
       .setColorValue(0xffffff00)
       .setFont(createFont("Arial Bold", 12));
    
    cp5.addSlider("Vaporization")
       .setRange(0.0,1.0)
       .setValue(1.0)
       .setPosition(15,42)
       .setSize(100,20)
       .setFont(createFont("Arial Bold", 10));
   
    cp5.addSlider("Alpha")
       .setRange(1,100)
       .setValue(1)
       .setPosition(15,72)
       .setSize(100,20)
       .setFont(createFont("Arial Bold", 10));
    
    cp5.addSlider("Beta")
       .setRange(1,100)
       .setValue(1)
       .setPosition(15,102)
       .setSize(100,20)
       .setFont(createFont("Arial Bold", 10));
       
    cp5.addTextlabel("Label_Kontrol")
       .setText("Kontrol :")
       .setPosition(10,142)
       .setColorValue(0xffffff00)
       .setFont(createFont("Arial Bold", 12));
    
   preset= cp5.addButton("Preset")
       .setValue(0)
       .setPosition(10,172)
       .setSize(50,30)
       .setFont(createFont("Arial Bold", 10));
     
     
   savelog = cp5.addButton("Simpan Log")
       .setValue(0)
       .setPosition(70,172)
       .setSize(80,30)
       .setFont(createFont("Arial Bold", 10));
     
   help = cp5.addButton("Bantuan")
       .setValue(0)
       .setPosition(160,172)
       .setSize(80,30)
       .setFont(createFont("Arial Bold", 10));
    
    //cp5.addTextlabel("Label_tambah")
    //   .setText("Tambah")
    //   .setPosition(10,172)
    //   .setColorValue(0xffffffff)
    //   .setFont(createFont("Arial Bold", 10));
       
    //cp5.addSlider("semut",10,500,65,172,100,15).setLabel("semut");
    
    //cp5.addButton("Mulai")
    // .setValue(0)
    // .setPosition(200,172)
    // .setSize(50,15)
    // ;
    
     cp5.addTextlabel("Label_Best")
       .setText("Jalur Terpendek :")
       .setPosition(10,230)
       .setColorValue(0xffffff00)
       .setFont(createFont("Arial Bold", 12));
       
     bestTextarea = cp5.addTextarea("best")
                   .setPosition(10, 260)
                   .setSize(280, 150)
                   .setFont(createFont("Arial", 10))
                   .setLineHeight(14)
                   .setColor(255)
                   .setColorBackground(0)
                   .setColorForeground(color(255, 100));
       
     cp5.addTextlabel("Label_Console")
     .setText("Console Log :")
     .setPosition(10,430)
     .setColorValue(0xffffff00)
     .setFont(createFont("Arial Bold", 12));
       
      consoleTextarea = cp5.addTextarea("console")
                   .setPosition(10, 460)
                   .setSize(280, 200)
                   .setFont(createFont("Arial", 10))
                   .setLineHeight(14)
                   .setColor(255)
                   .setColorBackground(0)
                   .setColorForeground(color(255, 100));
      console = cp5.addConsole(consoleTextarea);//
  }
  
  void draw(){
    background(100);
  }
  
  void Alpha(int val){
   alpha = val;
  }
  
  void Beta(int val){
   beta = val;
  }
  
  void Vaporization(float val){
   rho = val;
  }
  
  
  
  void loadDataPreset(){
    
   // cp5 = new ControlP5(this);
    
    int[][] data = {
      {325,275,625,75,4},
      {325,275,625,375,1},
      {625,375,925,225,3},
      {625,75,925,225,1},
      {625,75,625,375,1},
      {325,275,925,225,7},
    };
    
    for(int i=0;i<data.length;i++){
      Node start = new Node(Integer.toString(labelNode),data[i][0],data[i][1],"");
      addNode(start); //start
      Node end = new Node(Integer.toString(labelNode),data[i][2],data[i][3],"");
      addNode(end); //end
      Track newTrack = new Track(Character.toString(label),start.x,start.y,end.x,end.y,data[i][4],"origin");
      addTrack(newTrack);
    }
    
    Nodes.get(searchNode(925,225)).tipe = "EXIT";
  }
  
 void mousePressed(){
   if(preset.isPressed()){
     listCP5();
     restart();
     removeCP5();
     loadDataPreset();
   }
   if(savelog.isPressed()){
     saveToFile();
   }
   if(help.isPressed()){
     String txt = "->Klik Kanan untuk membuat Node \n->Untuk membuat Rute, Pilih Node menggunakan Klik Kiri Kemudian Klik Kiri kembali pada lokasi lain";
     txt = txt + "\n->Tekan tombol 'X', untuk menentukan titik EXIT (tujuan akhir)";
     txt = txt + "\n->Tekan tombol 'S', untuk menentukan titik MULAI (Titik Mulai)";
     txt = txt + "\n->Untuk menambahkan semut, tekan tombol Spasi\n->Tombol Preset digunakan untuk menampilkan skenario default";
     showMessageDialog(null,txt,"How To Use",PLAIN_MESSAGE);
   }
 }
  
 
}
