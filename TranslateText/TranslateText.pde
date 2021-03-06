//Variables essential to reading and printing the txt file
String filename="C:/Users/Max/Documents/GitHub/Optical-Spectroscopy/60WRevealLED_10-6_3-9nm_run2.txt";
BufferedReader reader;
String line;
int lineNumber;

float Ymax=0.1;    //maximum Y-coordinate value, adjusted as data is read
float autoYscale=1.1; // variable for scaling the Y axis
int X1, Y1;        //integer variable for plotting
float startP, stopP;  //scan range

float[] Xdata=new float[30000];
float[] Ydata=new float[30000];
float scanDir=1.0;
boolean newData=true;
int dataN=0;

int[] RGBvalues=new int[4];
float wavelength, R, G, B, T;

//Variables added for the maximum printing
float[] peaks=new float[12000];
int peakN;
float[] troughs=new float[12000];
int troughN;
float[] sortM=new float[12000];
int sortN;

int k;
float[] maxima=new float[1000];

float total;
float averageV;
float cutoff;

float[] unkTable=new float[12000];
boolean unk;
String shortName;

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
    }
    if (lineNumber < 30000) {
      Xdata[lineNumber] = float(pieces[0]);
      Ydata[lineNumber] = float(pieces[1]);
      total+=float(pieces[1]);
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
  String[] pieces2 = split(filename, "_");
  stopP = Float.parseFloat(pieces2[2].substring(2,3))*100;
  noLoop();
}

void draw() {
  Ymax=autoYscale*getMaxY(Ydata);
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
  shortName = filename.substring(51, filename.length()-4) + "_Maximums.txt";
  text(shortName,400,35);
  textSize(18);
  text(str(startP),80,730);
  text(str(stopP),1180,730);
  textSize(18);
  text("0.0 V",30,709);
  text(str(Ymax),30,39);
  
  textSize(24);
  text("Wavelength (nm)",570,750);
  
  pushMatrix();
  translate(55,420);
  rotate(-HALF_PI);
  text("Intensity (V)",0,0);
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
  printMaxima();
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

float getMaxY(float[] Y) {
  float maxY=0.0;
  for(int i=0; i < dataN; i++) {
    if(Y[i] > maxY) {
      maxY = Y[i];
    }
  }
  return maxY;
}

void printMaxima() {
  for(int i=0; i<29996; i++) {
    float x1,x2,y1,y2,x3,x4,y3,y4,m1,m2;
    x1=Xdata[i];
    y1=Ydata[i];
    x2=Xdata[i+1];
    y2=Ydata[i+1];
    x3=Xdata[i+2];
    y3=Ydata[i+2];
    x4=Xdata[i+3];
    y4=Ydata[i+3];
    m1 = (y2-y1)/(x2-x1);
    m2 = (y4-y3)/(x4-x3);
    if ((m1>0) && (m2<0)) {
      peaks[peakN] = ((x2+x3)/2);
      peaks[peakN+1] = ((y2+y3)/2);
      peakN+=2;
    }
    if ((m1<0) && (m2>0)) {
      troughs[troughN] = ((x2+x3)/2);
      troughs[troughN+1] = ((y2+y3)/2);
      troughN+=2;
    }
  }
  peakN=0;
  averageV=total/lineNumber;
  for (int i=0; i<11998; i+=2) {
    if (troughs[i] != 0.0) {
    println(troughs[i], troughs[i+2]);
    float[] max = findRelMax(troughs[i], troughs[i+2]);
    //println(max[0] + "\t" + max[1]);
    unk=true;
      for(int j=0; j<11999; j++) {
        if ((unkTable[j] <= max[0]+20) && (unkTable[j] >= max[0]-20)) {
          unk=false;
        }
      }
      if (unk) {
        unkTable[i] = max[0];
        //println(max[0] + "\t" + max[1]);
      }
      cutoff = 1.5*averageV;
      if ((max[1] > cutoff) && (unk)) {
        maxima[peakN]=max[0];
        maxima[peakN+1]=max[1];
        peakN+=2;
      }
    }
  }
  println("Printing Maxima");
  for (int j=0; j<999; j+=2) {
    float energy = 0.0;
    if (maxima[j+1]!=0.0) {
      X1=int(map(maxima[j], startP, stopP, 0, 1100));  //rescale to pixel numbers
      Y1=int(map(maxima[j+1], 0, Ymax, 0, 650)); 
      RGBvalues=getRGB(maxima[j]);
      R=RGBvalues[0];
      G=RGBvalues[1];
      B=RGBvalues[2];
      T=RGBvalues[3];
      stroke(0x0);  //set the color
      strokeWeight(2);
      line(X1+100,690-Y1,X1+100,670-Y1);      //draw a vertical line
      //println(maxima[j] + "\t" + maxima[j+1]);
      energy=(6.63*pow(10, -34)*3*pow(10, 8))/(maxima[j]*pow(10,-9)*1.6*pow(10,-19));
      //println("Energy: " + energy + "eV");
      fill(0);
      textSize(18);
      text(str(maxima[j])+" nm, "+str(energy)+" eV",X1,660-Y1);
      textSize(16);
      int avgY = (int)(700-(averageV/Ymax)*600);
      text("Average V",20,avgY+5);
      strokeWeight(1);
      for (int i=0; i<32; i++) {
        line(105+(35*i),avgY,115+(35*i),avgY);
      }
      fill(0);
      textSize(18);
      text(str(maxima[j])+" nm, "+str(energy)+" eV",X1,660-Y1);
      textSize(16);
      int cutoffV = (int)(700-(cutoff/Ymax)*600);
      text("Cutoff V",20,cutoffV+5);
      strokeWeight(1);
      for (int i=0; i<32; i++) {
        line(105+(35*i),cutoffV,115+(35*i),cutoffV);
      }
    }
  }
  println("Ymax: "+ Ymax);
  String filenameImage = filename.substring(0, filename.length()-4) + "_Maximums.png";
  println(filenameImage);
  save(filenameImage);
  println("Image saved.");
}

float[] findRelMax(float start, float end) {
  float[] pair={0.0, 0.0};
  for (int i=0; i < 11998; i+=2) {
    if ((peaks[i] > start) && (peaks[i] < end)) {
      sortM[sortN] = peaks[i];
      sortM[sortN+1] = peaks[i+1];
      sortN+=2;
    }
  }
  int current = 0;
  while (current < 11999) {
    if (sortM[current+1] > pair[1]) {
      pair[0] = sortM[current];
      pair[1] = sortM[current+1];
    }
    current+=2;
  }
  sortN = 0;
  return pair;
}
