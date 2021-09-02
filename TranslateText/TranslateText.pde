String filename="C:/Users/maxwi/Documents/GitHub/Optical-Spectroscopy/run2.txt";
BufferedReader reader;
String line;
int lineNumber;

float Ymax=0.1;    //maximum Y-coordinate value
float autoYscale=1.5;
int X1, Y1;        //integer variable for plotting
float startP, stopP;  //scan range

float[] Xdata=new float[30000];
float[] Ydata=new float[30000];
float scanDir=1.0;
boolean newData=true;
int dataN=0;

int[] RGBvalues=new int[4];
float wavelength, R, G, B, T;

void setup(){
  lineNumber=0;
  size(1300,800);  //sets the size of drawing window
  delay(1000);
  reader = createReader(filename);
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  while (line != null) {
    String[] pieces = split(line, TAB); 
    if (lineNumber==0) {
      startP = float(pieces[0]);
      println(startP);
    }
    if (lineNumber < 30000) {
      Xdata[lineNumber] = float(pieces[0]);
      Ydata[lineNumber] = float(pieces[1]);
    }
    lineNumber++;
    dataN++;
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
      }
    }
  stopP = Ydata[Ydata.length -1];
  println(stopP);
  noLoop();
}

void draw() {
  //if (newData==true){
  //  if (Ydata[dataN-1]>Ymax){
  //    Ymax=autoYscale*Ydata[dataN-1];
  //  }
  //  println(dataN-1 + "\t" + Xdata[dataN-1] + "\t" + Ydata[dataN-1]);
  //  newData=false;
  //}
  plot();
}

void plot(){
  background(255);  //white background color
  fill(255);        //fill a close shape with white color
  stroke(0);        //black drawing color
  rect(100,50,1100,650);  //draw the rectangle
  for(int i=1;i<10;i++){  //to draw 9 grid lines horizontally and vertically
    stroke(200);    //choose a grey drawing color
    X1=int(map(startP+(stopP-startP)*i/10, startP, stopP, 0, 1100));
    line(X1+100,700,X1+100,50);
    Y1=int(map(Ymax*i/10,0,Ymax,0,650));
    line(100,Y1+50,1200,Y1+50);
  }
  fill(0);
  textSize(30);
  text(filename,200,35);
  textSize(18);
  text(str(startP),80,730);
  text(str(stopP),1180,730);
  textSize(18);
  text("0.0 V",30,709);
  text(str(Ymax),30,39);
  
  textSize(24);
  text("wavelength (nm)",570,750);
  
  pushMatrix();
  translate(55,420);
  rotate(-HALF_PI);
  text("intensity",0,0);
  popMatrix();
  
  stroke(255,0,0);  //pencil color red
  fill(255);        //fill closed shapes with white
  for (int j=0; j<dataN; j++){
    X1=int(map(Xdata[j], startP, stopP, 0, 1100));  //rescale to pixel numbers
    Y1=int(map(Ydata[j], 0, Ymax, 0, 650)); 
    RGBvalues=getRGB(Xdata[j]);
    R=RGBvalues[0];
    G=RGBvalues[1];
    B=RGBvalues[2];
    T=RGBvalues[3];
    stroke(int(R),int(G),int(B),int(T));  //set the color
    line(100+X1,700,100+X1,700-Y1);      //draw a vertical line
  }
}

int[] getRGB(float wavelength){
  if(wavelength<380) {
    R=1; G=0; B=1;T=wavelength/380;
  } else if((wavelength>=380) && (wavelength<440)) {
    R=-(wavelength-440)/(440-380); G=0; B=1;T=1;
  } else if((wavelength>=440) && (wavelength<490)) {
    R=0; G=(wavelength-440)/(490-440); B=1;T=1;
  } else if((wavelength>=490) && (wavelength<510)) {
    R=0; G=1; B=-(wavelength-510)/(510-490);T=1;
  } else if((wavelength>=510) && (wavelength<580)) {
    R=(wavelength-510)/(580-510); G=1; B=0;T=1;
  } else if((wavelength>=580) && (wavelength<645)) {
    R=1; G=-(wavelength-645)/(645-580); B=0;T=1;
  } else if((wavelength>=645) && (wavelength<781)) {
    R=1; G=0; B=0;T=1;
  } else if((wavelength>=781) && (wavelength<1172)){
    R=1; G=0; B=0;T=1-(wavelength-781)/781;
  } else {
    R=1; G=0; B=0; T=0.5;
  }
  RGBvalues[0]=int(R*255);
  RGBvalues[1]=int(G*255);
  RGBvalues[2]=int(B*255);
  RGBvalues[3]=int(T*255);
  return RGBvalues;
}
