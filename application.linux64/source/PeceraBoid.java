import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PeceraBoid extends PApplet {

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

public void setup(){
  
  creacion = new lectura();
  creacion.start();
  
  size(1366,768,P3D);
  noStroke();
  
  flock1 = new PezBoidGroup(initBoidNum, 1);
  
  frameRate(40);
}

public void draw(){
  
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

public void paintCube(){
  
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
public void keyPressed()
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
     System.out.println("\u3053\u308c");
   }
}
public class PezBoid{

  PVector posicion,velocidad,aceleracion; 
  float radioVista;
  float maxSpeed = 4; //maximum magnitude for the velocity vector
  float maxSteerForce = .1f; //maximum magnitude of the steering vector
  float flap = 0;
  float t=0;
  
  private int fishSize;        //Size of the fish
  private PImage fishImage;    //Image of the fish
  private int type;
  
  public PezBoid(PImage image, int type)
  {
    posicion = new PVector();
    posicion.set((float) random (120, 1200), (float) random (60, 600), (float) random (300, 900));
    velocidad = new PVector(random(-1,1),random(-1,1),random(1,-1));
    aceleracion = new PVector(0,0,0);
    radioVista = 500;
    fishSize = 100;//(int) random (90, 100);
    fishImage = image;
    this.type = type;
  }

  public void act(ArrayList lp)
  {
    t+=.1f;
    flap = 10*sin(t);
    
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x,height*1.1f,posicion.z),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x,-height*0.1f,posicion.z),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(width*1.1f,posicion.y,posicion.z),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(-width*0.1f,posicion.y,posicion.z),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x,posicion.y,300),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x,posicion.y,900*1.1f),true),10));
    
    flock(lp);
    move();
    render();
  }
  
  public void flock(ArrayList lp)
  {
    //agrupar(lp);
    
    //depredador();
    
    aceleracion.add(PVector.mult(alignment(lp) ,1));
    aceleracion.add(PVector.mult(cohesion(lp)  ,5));
    aceleracion.add(PVector.mult(separation(lp),1.5f));
    //aceleracion.add(PVector.mult(tendToPlace(),1));
  }
  
  public void agrupar(ArrayList boids){
    
    for(int i=0;i<boids.size();i++)
    {
      PezBoid b = (PezBoid)boids.get(i);
      float d = PVector.dist(posicion,b.posicion);
      if(d>0&&d<=radioVista)
        if(type != b.type)
          aceleracion.add(PVector.mult(avoid(b.posicion,true),3));
    }
  }
  
  public void depredador(){
    ArrayList posZ = new ArrayList();
    
    for(int i = 200; i <= 1100; i++){
      PVector posicionD = new PVector();
      posicionD.set(mouseX, mouseY, i);
      posZ.add(posicionD);
    }
    for(int i=0;i<posZ.size();i++){
      PVector pz = (PVector) posZ.get(i); 
      float d = PVector.dist(posicion,pz);
      if(d>0&&d<=radioVista)
        aceleracion.add(PVector.mult(avoid(pz,true),.2f));
    }   
  }
  
  public PVector tendToPlace(){
    PVector place = PVector.sub(new PVector(mouseX,mouseY,0), posicion);
    place.div(500);
    return place;
  }
  
  public void move()
  {
    velocidad.add(aceleracion); //add aceleracioneleration to velocity
    velocidad.limit(maxSpeed); //make sure the velocity vector magnitude does not exceed maxSpeed
    posicion.add(velocidad); //add velocity to position
    aceleracion.mult(0); //reset aceleracioneleration
  }
  
  public void render()
  {    
    pushMatrix();
    translate(posicion.x,posicion.y,posicion.z);
    rotateY(atan2(-velocidad.z,velocidad.x));
    rotateZ(asin(velocidad.y/velocidad.mag()));
    image(fishImage, 0, 0, fishSize, fishSize);
    popMatrix();
  }
  
  public PVector steer(PVector target,boolean arrival)
  {
    PVector steer = new PVector(); //creates vector for steering
    if(!arrival)
    {
      steer.set(PVector.sub(target,posicion)); //steering vector points towards target (switch target and pos for avoiding)
      steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    }
    else
    {
      PVector targetOffset = PVector.sub(target,posicion);
      float distance=targetOffset.mag();
      float rampedSpeed = maxSpeed*(distance/100);
      float clippedSpeed = min(rampedSpeed,maxSpeed);
      PVector desiredVelocity = PVector.mult(targetOffset,(clippedSpeed/distance));
      steer.set(PVector.sub(desiredVelocity,velocidad));
    }
    return steer;
  }
  
  //avoid. If weight == true avoidance vector is larger the closer the boid is to the target
  public PVector avoid(PVector target,boolean weight)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(posicion,target)); //steering vector points away from target
    if(weight)
      steer.mult(1/sq(PVector.dist(posicion,target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
   
  public PVector separation(ArrayList boids)
  {
    PVector posSum = new PVector(0,0,0);
    PVector repulse;
    for(int i=0;i<boids.size();i++)
    {
      PezBoid b = (PezBoid)boids.get(i);
      float d = PVector.dist(posicion,b.posicion);
      if(d>0&&d<=radioVista)
      {
        if(type == b.type){
          repulse = PVector.sub(posicion,b.posicion);
          repulse.normalize();
          repulse.div(d);
          posSum.add(repulse);
        }
      }
    }
    return posSum;
  }

  public PVector alignment(ArrayList boids)
  {
    PVector velSum = new PVector(0,0,0);
    int count = 0;
    for(int i=0;i<boids.size();i++)
    {
      PezBoid b = (PezBoid)boids.get(i);
      float d = PVector.dist(posicion,b.posicion);
      if(d>0&&d<=radioVista)
      {
        if(type == b.type){
          velSum.add(b.velocidad);
          count++;
        }
      }
    }
    if(count>0)
    {
      velSum.div((float)count);
      velSum.limit(maxSteerForce);
    }
    return velSum;
  }
   
  public PVector cohesion(ArrayList boids)
  {
    PVector posSum = new PVector(0,0,0);
    PVector steer = new PVector(0,0,0);
    int count = 0;
    for(int i=0;i<boids.size();i++)
    {
      PezBoid b = (PezBoid)boids.get(i);
      float d = dist(posicion.x,posicion.y,b.posicion.x,b.posicion.y);
      if(d>0&&d<=radioVista)
      {
        if(type == b.type){
          posSum.add(b.posicion);
          count++;
        }
      }
    }
    if(count>0)
    {
      posSum.div((float)count);
    }
    steer = PVector.sub(posSum,posicion);
    steer.limit(maxSteerForce);
    return steer;
  }
}
public class PezBoidGroup {
  
  ArrayList PezBoidL; //will hold the boids in this BoidList
  ArrayList pecesImagen;
   
  PezBoidGroup(int n, int clases)
  {
    pecesImagen = new ArrayList();
    
    for (int y = 0; y < clases; y++)
      pecesImagen.add(loadImage("/home/bps_csp/Documentos/UNAL/ALife/Pescera/"+y+".png"));
    
    PezBoidL = new ArrayList();
    for (int x = 0; x < n; x++)
      for (int y = 0; y < clases; y++)
        PezBoidL.add(new PezBoid((PImage) pecesImagen.get(y), y));
  }
   
  public void add()
  {
    int sele = (int)random(1,10);
    PezBoidL.add(new PezBoid((PImage) pecesImagen.get(sele), sele));
  }
   
  public void addBoid(PezBoid b)
  {
    PezBoidL.add(b);
  }
   
  public void run()
  {
    for(int i=0;i<PezBoidL.size();i++) //iterate through the list of boids
    {
      PezBoid tempBoid = (PezBoid)PezBoidL.get(i); //create a temporary boid to process and make it the current boid in the list
      tempBoid.act(PezBoidL); //tell the temporary boid to execute its run method
    }
  }
  
  public void updateRender(){
    for(int i=0;i<PezBoidL.size();i++) //iterate through the list of boids
    {
      PezBoid tempBoid = (PezBoid)PezBoidL.get(i); //create a temporary boid to process and make it the current boid in the list
      tempBoid.render();
    }
  }
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "PeceraBoid" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
