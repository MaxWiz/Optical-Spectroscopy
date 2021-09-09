String filename="C:/Users/Max/Documents/GitHub/Optical-Spectroscopy/H_10-7_3-5nm_run2.txt";
BufferedReader reader;
String line;
int lineNumber;

float[] peaks=new float[6000];
int peakN;
float[] troughs=new float[6000];
int troughN;
float[] sortM=new float[200];
int sortN;


float[] Xdata=new float[30000];
float[] Ydata=new float[30000];
int k;
float[] maxima=new float[1000];

float total;
float averageV;

float[] unkTable=new float[6000];
boolean unk;

void setup() {
  lineNumber=0;
  total=0;
  reader=createReader(filename);
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  while (line != null) {
    String[] pieces1 = split(line, TAB);
    Xdata[k]=float(pieces1[0]);
    Ydata[k]=float(pieces1[1]);
    total+=Ydata[k];
    lineNumber++;
    k++;
    try {
    line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
  }
}

void draw() {
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
  println("TotalV: " + total);
  println("# of lines: " + lineNumber);
  averageV=total/lineNumber;
  println("Average V: " + averageV);
  for (int i=0; i<5999; i+=2) {
    if(troughs[i] != 0) {
      float[] max = findRelMax(troughs[i], troughs[i+2]);
      unk=true;
      for(int j=0; j<5999; j++) {
        if ((unkTable[j] <= max[0]+2) && (unkTable[j] >= max[0]-2)) {
          unk=false;
        }
      }
      unkTable[i] = max[0];
      if ((max[1] > 1.5*averageV) && (unk)) {
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
      println(maxima[j] + "\t" + maxima[j+1]);
      energy=(6.63*pow(10, -34)*3*pow(10, 8))/(maxima[j]*pow(10,-9)*1.6*pow(10,-19));
      println("Energy: " + energy + "eV");
    }
  }
  while (true) {}
}

float[] findRelMax(float start, float end) {
  float[] pair={0.0, 0.0};
  for (int i=0; i < 5999; i+=2) {
    if ((peaks[i] > start-10) && (peaks[i] < end+10)) {
      sortM[sortN] = peaks[i];
      sortM[sortN+1] = peaks[i+1];
      sortN+=2;
    }
  }
  int current = 0;
  while (current < 199) {
    if (sortM[current+1] > pair[1]) {
      pair[0] = sortM[current];
      pair[1] = sortM[current+1];
    }
    current+=2;
  }
  sortN = 0;
  return pair;
}
