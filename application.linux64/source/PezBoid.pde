public class PezBoid{

  PVector posicion,velocidad,aceleracion; 
  float radioVista;
  float maxSpeed = 4; //maximum magnitude for the velocity vector
  float maxSteerForce = .1; //maximum magnitude of the steering vector
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
    t+=.1;
    flap = 10*sin(t);
    
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x,height*1.1,posicion.z),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x,-height*0.1,posicion.z),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(width*1.1,posicion.y,posicion.z),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(-width*0.1,posicion.y,posicion.z),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x,posicion.y,300),true),10));
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x,posicion.y,900*1.1),true),10));
    
    flock(lp);
    move();
    render();
  }
  
  void flock(ArrayList lp)
  {
    //agrupar(lp);
    
    //depredador();
    
    aceleracion.add(PVector.mult(alignment(lp) ,1));
    aceleracion.add(PVector.mult(cohesion(lp)  ,5));
    aceleracion.add(PVector.mult(separation(lp),1.5));
    //aceleracion.add(PVector.mult(tendToPlace(),1));
  }
  
  void agrupar(ArrayList boids){
    
    for(int i=0;i<boids.size();i++)
    {
      PezBoid b = (PezBoid)boids.get(i);
      float d = PVector.dist(posicion,b.posicion);
      if(d>0&&d<=radioVista)
        if(type != b.type)
          aceleracion.add(PVector.mult(avoid(b.posicion,true),3));
    }
  }
  
  void depredador(){
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
        aceleracion.add(PVector.mult(avoid(pz,true),.2));
    }   
  }
  
  PVector tendToPlace(){
    PVector place = PVector.sub(new PVector(mouseX,mouseY,0), posicion);
    place.div(500);
    return place;
  }
  
  void move()
  {
    velocidad.add(aceleracion); //add aceleracioneleration to velocity
    velocidad.limit(maxSpeed); //make sure the velocity vector magnitude does not exceed maxSpeed
    posicion.add(velocidad); //add velocity to position
    aceleracion.mult(0); //reset aceleracioneleration
  }
  
  void render()
  {    
    pushMatrix();
    translate(posicion.x,posicion.y,posicion.z);
    rotateY(atan2(-velocidad.z,velocidad.x));
    rotateZ(asin(velocidad.y/velocidad.mag()));
    image(fishImage, 0, 0, fishSize, fishSize);
    popMatrix();
  }
  
  PVector steer(PVector target,boolean arrival)
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
  PVector avoid(PVector target,boolean weight)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(posicion,target)); //steering vector points away from target
    if(weight)
      steer.mult(1/sq(PVector.dist(posicion,target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
   
  PVector separation(ArrayList boids)
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

  PVector alignment(ArrayList boids)
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
   
  PVector cohesion(ArrayList boids)
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
