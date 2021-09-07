String filename="C:/Users/labuser/Documents/GitHub/Optical-Spectroscopy/H_10-7_3-5nm_run2.txt";
BufferedReader reader;
String line;
int lineNumber;
int entries;
int k;
float[] Xdata=new float[30000];
float[] Ydata=new float[30000];
float[] possible=new float[6000];
float[] maxima=new float[1000];
float total;
float x1,x2,y1,y2,x3,x4,y3,y4;
float m1;
float m2;
float averageV;
float energy;

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
      possible[entries] = ((x2+x3)/2);
      possible[entries+1] = ((y2+y3)/2);
      //println(possible[entries] + "\t" + possible[entries+1]);
      entries+=2;
    }
  }
  entries=0;
  println("TotalV: " + total);
  println("# of lines: " + lineNumber);
  averageV=total/lineNumber;
  println("average: " + averageV);
  for (int i=0; i<5999; i+=2) {
    if (possible[i+1] > 2*averageV) {
      maxima[entries]=possible[i];
      maxima[entries+1]=possible[i+1];
      entries+=2;
    }
  }
  println("Printing");
  for (int j=0; j<999; j+=2) {
    if (maxima[j+1]!=0.0) {
      println(maxima[j] + "\t" + maxima[j+1]);
      energy=(6.63*pow(10, -34)*3*pow(10, 8))/(maxima[j]*pow(10,-9)*1.6*pow(10,-19));
      println("Energy: " + energy + "eV");
    }
  }
  while (true) {}
}
