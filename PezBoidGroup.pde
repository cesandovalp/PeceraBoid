public class PezBoidGroup {

  ArrayList PezBoidL;
  ArrayList pecesImagen;

  PezBoidGroup(int n, int clases)
  {
    pecesImagen = new ArrayList();

    for (int y = 0; y < clases; y++)
      pecesImagen.add(loadImage("/path/to/the/images/of/the_fish/"+y+".png"));

    PezBoidL = new ArrayList();
    for (int x = 0; x < n; x++)
      for (int y = 0; y < clases; y++)
        PezBoidL.add(new PezBoid((PImage) pecesImagen.get(y), y));
  }
  
  PezBoidGroup()
  {
    pecesImagen = new ArrayList();

    PezBoidL = new ArrayList();
  }
  
  void add(int y, int tipo)
  {
    System.out.println("Poblacion: "+PezBoidL.size());
    PezBoidL.add(new PezBoid((PImage) loadImage("/path/to/the/images/of/the_fish/A"+y+".png"), tipo));
  }
  
  void remove(int i, int i2)
  {
    PezBoidL.remove(i);
    System.out.println("Dead: "+i2    );
  }

  void addBoid(PezBoid b)
  {
    PezBoidL.add(b);
  }

  void run()
  {
    for (int i=0;i<PezBoidL.size();i++)
    {
      PezBoid tempBoid = (PezBoid)PezBoidL.get(i);
      if (tempBoid.edad > 4000) remove(i,i); 
      tempBoid.act(PezBoidL);
    }
  }

  void updateRender() {
    for (int i = 0; i < PezBoidL.size(); i++)
    {
      PezBoid tempBoid = (PezBoid) PezBoidL.get(i);
      tempBoid.render();
    }
  }
}

