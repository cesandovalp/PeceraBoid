PezBoidGroup grupo1;
lectura creacionA, creacionB, creacionC;
int initBoidNum = 100;
int clases = 7;
float posZ =-1500;
float posX = 0;
float posY = 0;
float rotX = 0;
float rotY = 0;

boolean pausa = false;
boolean pos_rot = true;

genPez adanA = new genPez();
genPez adanB = new genPez();
genPez adanC = new genPez();

int countA = 0;
int countB = 1;
int countC = 2;

void setup()
{

  creacionA = new lectura(adanA, " A"+countA);
  creacionB = new lectura(adanB, " A"+countB);
  creacionC = new lectura(adanC, " A"+countC);
  
  creacionA.start();
  creacionB.start();
  creacionC.start();

  size(1366, 768, P3D);
  noStroke();

  //grupo1 = new PezBoidGroup(initBoidNum, clases);
  grupo1 = new PezBoidGroup();

  //frameRate(1);
}

void draw()
{
  /*String namaeha = "";
  while(counta <= 200){
    pezTest = pezTest.clone();
    if(counta < 10) namaeha = " A00";
    else if(counta < 100) namaeha = " A0";
    else namaeha = " A";
    
    System.out.println(pezTest.toString(3)+namaeha+ counta++);
  }*/
  //for (int i = 100; i < 201; i++)
  //System.out.println("convert -flatten A"+i+".png B"+i+".png");
  
  //exit();
  
  if(!creacionA.isAlive()){
    grupo1.add(countA, 1);
    countA += 3;
    adanA = adanA.clone();
    creacionA = new lectura(adanA, " A"+countA);
    creacionA.start();
  }
  if(!creacionB.isAlive()){
    grupo1.add(countB, 2);
    countB += 3;
    adanB = adanB.clone();
    creacionB = new lectura(adanB, " A"+countB);
    creacionB.start();
  }
  if(!creacionC.isAlive()){
    grupo1.add(countC, 3);
    countC += 3;
    adanC = adanC.clone();
    creacionC = new lectura(adanC, " A"+countC);
    creacionC.start();
  }

  beginCamera();
  camera();
  rotateX(map(rotY, 0, height, 0, TWO_PI));
  rotateY(map(rotX, width, 0, 0, TWO_PI));
  translate(posX, posY, posZ);
  endCamera();

  noFill();
  stroke(0);

  if (!pausa)
  {
    background(206, 223, 239);

    paintCube();

    hint(DISABLE_DEPTH_TEST);
    hint(ENABLE_DEPTH_SORT);
    grupo1.run();
    hint(DISABLE_DEPTH_SORT);
    hint(ENABLE_DEPTH_TEST);
  }
  else {

    background(206, 223, 239);

    paintCube();

    hint(DISABLE_DEPTH_TEST);
    hint(ENABLE_DEPTH_SORT);
    grupo1.updateRender();
    hint(DISABLE_DEPTH_SORT);
    hint(ENABLE_DEPTH_TEST);
  }
}

void paintCube()
{

  int xi = -180;
  int xf = width+200;
  int yi = -110;
  int yf = height+180;
  int zi = 200;
  int zf = 1100;

  line(xi, yi, zi, xi, yf, zi);
  line(xi, yi, zf, xi, yf, zf);
  line(xi, yi, zi, xf, yi, zi);
  line(xi, yi, zf, xf, yi, zf);

  line(xf, yi, zi, xf, yf, zi);
  line(xf, yi, zf, xf, yf, zf);
  line(xi, yf, zi, xf, yf, zi);
  line(xi, yf, zf, xf, yf, zf);

  line(xi, yi, zi, xi, yi, zf);
  line(xi, yf, zi, xi, yf, zf);
  line(xf, yi, zi, xf, yi, zf);
  line(xf, yf, zi, xf, yf, zf);
} 

void setView(float rx, float ry, float px, float py, float pz)
{
  rotX = rx;
  rotY = ry;
  posX = px;
  posY = py;
  posZ = pz;
}
void keyPressed()
{
  switch (keyCode)
  {
  case UP: 
    posZ-=10; 
    break;
  case DOWN: 
    posZ+=10; 
    break;
  }
  switch (key)
  {
  case 'p':
    {
      pausa = pausa ? false : true;
      break;
    }
  case '1':
    {
      setView(0, -192, -10, 290, -280);
      break;
    }
  case '2':
    {
      setView(-342, 5, 480, -80, 50);
      break;
    }
  case '3':
    {
      setView( 0, 0, 0, 0, -1800);
      break;
    }
  case 'm':
    {
      pos_rot = pos_rot ? false : true;
      break;
    }
  case 'h':
    {
      System.out.println("rotX: " + rotX + ", rotY: " + rotY + ", posX: " + posX + ", posY: " + posY + ", posZ: " + posZ);
      break;
    }
  case 'i':
    {
      if (pos_rot) posY += 10;
      else rotY++;
      break;
    }
  case 'j':
    {
      if (pos_rot)posX += 10;
      else rotX++;
      break;
    }
  case 'k':
    {
      if (pos_rot)posY -= 10;
      else rotY--;
      break;
    }
  case 'l':
    {
      if (pos_rot)posX -= 10;
      else rotX--;
      break;
    }
  }
}

class lectura extends Thread
{
  genPez pezCreado;
  String nombre;
  lectura (genPez pezTest, String nombre) {
    this.pezCreado = pezTest;
    this.nombre = nombre;
  }
  lectura (String name) {
    super (name);
  }
  public void run ()
  {
    try
    {
      Runtime r = Runtime.getRuntime();
      Process p_2 = r.exec("/Path/With/To/The_Executable_File/Pescera.bin"+pezCreado.toString(4)+nombre);
      p_2.waitFor();
    }
    catch(Exception i) {
    }
  }
}

