PezBoidGroup flock1;
lectura creacion;
int initBoidNum = 600; //amount of boids to start the program with
float zoom =-800;
float posX = 0;
float posY = 0;
float rotX = 0;
float rotY = 0;

boolean pausa = false;
boolean pos_rot = true;

void setup(){
  
  creacion = new lectura();
  creacion.start();
  
  size(1366,768,P3D);
  noStroke();
  
  flock1 = new PezBoidGroup(initBoidNum, 1);
  
  frameRate(40);
}

void draw(){
  
  if(!creacion.isAlive()) pausa = true;
  
  beginCamera();
  camera();
  rotateX(map(rotY,0,height,0,TWO_PI));
  rotateY(map(rotX,width,0,0,TWO_PI));
  translate(posX,posY,zoom);
  endCamera();
  
  noFill();
  stroke(0);
   
  if(!pausa)
  {
    background(206, 223, 239);
    
    paintCube();
    
    hint(DISABLE_DEPTH_TEST);
    hint(ENABLE_DEPTH_SORT);
    flock1.run();
    hint(DISABLE_DEPTH_SORT);
    hint(ENABLE_DEPTH_TEST);
  }else{
    
    background(206, 223, 239);
    
    paintCube();
    
    hint(DISABLE_DEPTH_TEST);
    hint(ENABLE_DEPTH_SORT);
    flock1.updateRender();
    hint(DISABLE_DEPTH_SORT);
    hint(ENABLE_DEPTH_TEST);
  }
}

void paintCube(){
  
  int xi = -160;
  int xf = width+190;
  int yi = -110;
  int yf = height+180;
  int zi = 200;
  int zf = 1100;
    
  line(xi,yi,zi,  xi,yf,zi);
  line(xi,yi,zf,  xi,yf,zf);
  line(xi,yi,zi,  xf,yi,zi);
  line(xi,yi,zf,  xf,yi,zf);
   
  line(xf,yi,zi,  xf,yf,zi);
  line(xf,yi,zf,  xf,yf,zf);
  line(xi,yf,zi,  xf,yf,zi);
  line(xi,yf,zf,  xf,yf,zf);
   
  line(xi,yi,zi,  xi,yi,zf);
  line(xi,yf,zi,  xi,yf,zf);
  line(xf,yi,zi,  xf,yi,zf);
  line(xf,yf,zi,  xf,yf,zf);
} 
void keyPressed()
{
  switch (keyCode)
  {
    case UP: zoom-=10; break;
    case DOWN: zoom+=10; break;
  }
  switch (key)
  {
    case 'p': pausa = pausa ? false : true; break;
    case 'm': pos_rot = pos_rot ? false : true; break;
    
    case 'i':{
      if(pos_rot)posY += 10;
      else rotY++;
      break;
    }
    case 'j':{
      if(pos_rot)posX += 10;
      else rotX++;
      break;
    }
    case 'k':{
      if(pos_rot)posY -= 10;
      else rotY--;
      break;
    }
    case 'l':{
      if(pos_rot)posX -= 10;
      else rotX--;
      break;
    }
    case 'r':{
      posX = 0;
      posY = 0;
      rotX = 0;
      rotY = 0;
      zoom = -800;
    }
  }
}

class lectura extends Thread
{
   lectura (){}
   lectura (String name){super (name);}
   public void run ()
   {
     
     try{
       Runtime r = Runtime.getRuntime();
       Process p_2 = r.exec("/home/bps_csp/Documentos/UNAL/ALife/Pescera/Pescera.bin");
       p_2.waitFor();
     }catch(Exception i){}
     System.out.println("これ");
   }
}
