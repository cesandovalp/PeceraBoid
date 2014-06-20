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
   
  void add()
  {
    int sele = (int)random(1,10);
    PezBoidL.add(new PezBoid((PImage) pecesImagen.get(sele), sele));
  }
   
  void addBoid(PezBoid b)
  {
    PezBoidL.add(b);
  }
   
  void run()
  {
    for(int i=0;i<PezBoidL.size();i++) //iterate through the list of boids
    {
      PezBoid tempBoid = (PezBoid)PezBoidL.get(i); //create a temporary boid to process and make it the current boid in the list
      tempBoid.act(PezBoidL); //tell the temporary boid to execute its run method
    }
  }
  
  void updateRender(){
    for(int i=0;i<PezBoidL.size();i++) //iterate through the list of boids
    {
      PezBoid tempBoid = (PezBoid)PezBoidL.get(i); //create a temporary boid to process and make it the current boid in the list
      tempBoid.render();
    }
  }
  
}
