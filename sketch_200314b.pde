import peasy.*;

PeasyCam cam;

PVector[][] globe;
int total = 75;

float offset = 0;
  
BufferedReader reader;
String line;

float m = 0;
float ch1 = 0;
float ch2 = 1;
float ch3 = 2;
float ch4 = 3;
float xx1 = 7;
float xx2 = 140;
float xx3 = 100;
float xx4 = 17;
float yy1 = 20;
float yy2 = 20;
float yy3 = 10;
float yy4 = 100;
ArrayList<String> list = new ArrayList<String>();
int totallines;
int next=0;
boolean flag =true;

void setup() {
  size(800, 800, P3D);
  cam = new PeasyCam(this, 500);
  colorMode(HSB);
  globe = new PVector[total+1][total+1];
  reader = createReader("C:\\Users\\milja\\OneDrive\\Desktop\\sketch_200314b\\OpenBCI-RAW-2019-12-03_10-13-26.txt");    
  int cnt=0;
  loop:while(flag){
    try{
      cnt++;
      if(cnt==100)flag=false;
    line = reader.readLine();
    list.add(line);
    }catch(IOException e){
    totallines = list.size();
    flag = false;}
  }
  totallines = list.size();
}

float a = 1;
float b = 1;

float supershape(float theta, float m, float n1, float n2, float n3) {
  float t1 = abs((1/a)*cos(m * theta / 4));
  t1 = pow(t1, n2);
  float t2 = abs((1/b)*sin(m * theta/4));
  t2 = pow(t2, n3);
  float t3 = t1 + t2;
  float r = pow(t3, - 1 / n1);
  return r;
}

void draw() {
  String[] pieces = split(list.get(next), ", ");
  xx1 += int(pieces[1])*0.001;
  xx2 += int(pieces[2])*0.001;
  xx3 -= int(pieces[3])*0.001;
  yy1 += int(pieces[1])*0.001;
  yy2 += int(pieces[2])*0.001;
  yy3 -= int(pieces[3])*0.001;
  offset += int(pieces[4])*0.1;
  //xx4 += 0.1;
  next= (next + 1)%totallines;
  //xx1 = map(sin(ch1), -1, 1, 0, 17);
  //xx2 = map(sin(ch2), -1, 1, 0, 17);
  //xx3 = map(sin(ch3), -1, 1, 0, 17);
  //xx4 = map(sin(ch4), -1, 1, 0, 17);
  ch1 += 0.1;
  ch2 += 0.1;
  ch3 -= 0.1;
  //ch4 += 0.1;
  //xx1 += 0.1;
  //xx2 += 0.1;
  //xx3 += 0.1;
  //xx4 += 0.1;
  background(0);
  noStroke();
  lights();
  float r = 200;
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, yy1, yy2, yy3, yy4);
    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, xx1, xx2, xx3, xx4);
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat);
      float z = r * r2 * sin(lat);
      globe[i][j] = new PVector(x, y, z);
    }
  }

  for (int i = 0; i < total; i++) {
    float hu = map(i, 0, total, 0, 255);
    fill((hu + offset) % 255 , 255,   255);
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total+1; j++) {
      PVector v1 = globe[i][j];
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}
