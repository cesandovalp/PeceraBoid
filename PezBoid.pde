public class PezBoid {

  PVector posicion, velocidad, aceleracion; 
  float radioVista;
  float velocidadMax = 5;
  float magnitudSteerMax = .2;
//  float t=0;
  int edad = 0;

  private int fishSize;
  private PImage fishImage;
  private int type;

  boolean eD = false;
  boolean eT = false;

  public PezBoid(PImage image, int type)
  {
    posicion = new PVector();
    posicion.set((float) random (120, 1200), (float) random (60, 600), (float) random (300, 900));
    velocidad = new PVector(random(-1, 1), random(-1, 1), random(1, -1));
    aceleracion = new PVector(0, 0, 0);
    radioVista = 170;
    fishSize = 100;
    fishImage = image;
    this.type = type;
  }

  public void act(ArrayList lp)
  {
    if(((int)random(0, 10))== 5)edad++;
    //System.out.println("edad: "+edad);
    //t+=random(0, 10)/100.0;
    boidAlgorithm(lp);
    move();
    render();
  }

  void boidAlgorithm(ArrayList lp)
  {
    //agrupar(lp);
    bordes();
    aceleracion.add(PVector.mult(alignment(lp), 6));
    aceleracion.add(PVector.mult(cohesion(lp), 4));
    aceleracion.add(PVector.mult(separation(lp), 8));
    if (eD)depredador();
    if (eT)aceleracion.add(PVector.mult(tendToPlace(), .1));
  }

  void bordes() {
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x, height+80, posicion.z), true), 2));
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x, -80, posicion.z), true), 2));
    aceleracion.add(PVector.mult(avoid(new PVector(width+120, posicion.y, posicion.z), true), 2));
    aceleracion.add(PVector.mult(avoid(new PVector(-130, posicion.y, posicion.z), true), 2));
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x, posicion.y, 280), true), 2));
    aceleracion.add(PVector.mult(avoid(new PVector(posicion.x, posicion.y, 1000), true), 2));
  }

  void agrupar(ArrayList boids) {
    for (int i=0;i<boids.size();i++)
    {
      PezBoid b = (PezBoid)boids.get(i);
      float d = PVector.dist(posicion, b.posicion);
      if (d>0&&d<=radioVista)
        if (type != b.type)
          aceleracion.add(PVector.mult(avoid(b.posicion, true), 10));
    }
  }

  void depredador() {
    ArrayList posZ = new ArrayList();
    for (int i = 200; i <= 1100; i++) {
      PVector posicionD = new PVector();
      posicionD.set(mouseX, mouseY, i);
      posZ.add(posicionD);
    }
    for (int i=0;i<posZ.size();i++) {
      PVector pz = (PVector) posZ.get(i); 
      float d = PVector.dist(posicion, pz);
      if (d>0&&d<=radioVista)
        aceleracion.add(PVector.mult(avoid(pz, true), 10));
    }
  }

  PVector tendToPlace() {
    PVector place = PVector.sub(new PVector(mouseX, mouseY, 500), posicion);
    place.div(200);
    return place;
  }

  void move()
  {
    velocidad.add(aceleracion);
    velocidad.limit(velocidadMax);
    posicion.add(velocidad);
    if (posicion.y >= height+70) posicion.y = height+70;
    else if (posicion.y <= -70) posicion.y = -70;
    if (posicion.x <= -120) posicion.x = -120;
    else if (posicion.x >= width+110) posicion.x = width+110;
    if (posicion.z <= 290) posicion.z = 290;
    else if (posicion.z >= 995) posicion.z = 995;
    aceleracion.mult(0);
  }

  void render()
  {
    pushMatrix();
    translate(posicion.x, posicion.y, posicion.z);
    rotateY(atan2(-velocidad.z, velocidad.x));
    rotateZ(asin(velocidad.y/velocidad.mag()));
    image(fishImage, 0, 0, fishSize, fishSize);
    popMatrix();
  }

  PVector avoid(PVector target, boolean weight)
  {
    PVector steer = new PVector();
    steer.set(PVector.sub(posicion, target));
    if (weight)
      steer.mult(1/sq(PVector.dist(posicion, target)));
    return steer;
  }

  PVector separation(ArrayList boids)
  {
    PVector posSum = new PVector(0, 0, 0);
    PVector repulsion;
    for (int i=0;i<boids.size();i++)
    {
      PezBoid b = (PezBoid)boids.get(i);
      float d = PVector.dist(posicion, b.posicion);
      if (d>=0&&d<=radioVista && !b.equals(this))
      {
        //System.out.println("Sep reach");
        //if (type == b.type) {
          repulsion = PVector.sub(posicion, b.posicion);
          repulsion.normalize();
          repulsion.div(d);
          posSum.add(repulsion);
        //}
      }
    }
    return posSum;
  }

  PVector alignment(ArrayList boids)
  {
    PVector velSum = new PVector(0, 0, 0);
    int count = 0;
    for (int i=0;i<boids.size();i++)
    {
      PezBoid b = (PezBoid)boids.get(i);
      float d = PVector.dist(posicion, b.posicion);
      if (d>0&&d<=radioVista)
      {
        if (type == b.type) {
          velSum.add(b.velocidad);
          count++;
        }
      }
    }
    if (count>0)
    {
      velSum.div((float)count);
      velSum.limit(magnitudSteerMax);
    }
    return velSum;
  }

  PVector cohesion(ArrayList boids)
  {
    PVector posSum = new PVector(0, 0, 0);
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (int i=0;i<boids.size();i++)
    {
      PezBoid b = (PezBoid)boids.get(i);
      float d = dist(posicion.x, posicion.y, b.posicion.x, b.posicion.y);
      if (d>0&&d<=radioVista)
      {
        if (type == b.type) {
          posSum.add(b.posicion);
          count++;
        }
      }
    }
    if (count>0)
    {
      posSum.div((float)count);
    }
    steer = PVector.sub(posSum, posicion);
    steer.limit(magnitudSteerMax);
    return steer;
  }
}

