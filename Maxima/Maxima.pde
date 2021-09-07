String filename="C:/Users/Max/Documents/GitHub/Optical-Spectroscopy/H_10-7_3-5nm_run2.txt";
BufferedReader reader;
String line;
int lineNumber;
int entries;
float[] possible=new float[6000];
float[] maxima=new float[1000];
float total;
float x1,x2,y1,y2,x3,x4,y3,y4;
float m1;
float m2;
float averageV;

void setup() {
  lineNumber=0;
  total=0;
  reader=createReader(filename);
}

void draw() {
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
    println("Done");
  }
  while (line != null) {
    String[] pieces1 = split(line, TAB);
    x1=float(pieces1[0]);
    y1=float(pieces1[1]);
    lineNumber++;
    total+=float(pieces1[1]);
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
      println("Done");
    }
    String[] pieces2 = split(line, TAB);
    x2=float(pieces2[0]);
    y2=float(pieces2[1]);
    lineNumber++;
    total+=float(pieces2[1]);
    m1 = (y2-y1)/(x2-x1);
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
      println("Done");
    }
    String[] pieces3 = split(line, TAB);
    x3=float(pieces3[0]);
    y3=float(pieces3[1]);
    lineNumber++;
    total+=float(pieces3[1]);
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
      println("Done");
    }
    String[] pieces4 = split(line, TAB);
    x4=float(pieces4[0]);
    y4=float(pieces4[1]);
    lineNumber++;
    total+=float(pieces4[1]);
    m2 = (y4-y3)/(x4-x3);
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
      println("Done");
    }
    if ((m1>0) && (m2<0)) {
      possible[entries] = ((x2+x3)/2);
      possible[entries+1] = ((y2+y3)/2);
      println(possible[entries] + "\t" + possible[entries+1]);
      entries++;
    }
  }
  entries=0;
  println("Total: " + total);
  println("# of lines: " + lineNumber);
  averageV=total/lineNumber;
  println("average: " + averageV);
  for (int i=0; i<5999; i++) {
    if (possible[i+1] > averageV) {
      maxima[entries]=possible[i];
      maxima[entries+1]=possible[i+1];
      entries++;
    }
  }
  println("Printing");
  for (int j=0; j<999; j++) {
    if (maxima[j+1]!=0.0) {
      println(maxima[j] + "\t" + maxima[j+1]);
    }
  }
  while (true) {}
}
