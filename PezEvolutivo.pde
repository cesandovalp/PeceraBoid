import java.util.Locale;

public class genPez{
  private float arriba;
  private float abajo;
  private float derecha;
  private float izquierda;
  private float derechaC;
  private float izquierdaC; 

  private int colorComponente1;
  private int colorComponente2;
  private int colorComponente3;
  
  private float CA;
  private float CB;
  
  private int iteraciones;
  
  public genPez(){
    this.arriba = (random(-300, 2500))/100;
    this.abajo = (random(-300, 1800))/100;
    this.derecha = (random(-1700, 1200))/100;
    this.izquierda = (random(-4000, 2000))/100;
    this.derechaC = (random(0, 100))/100;
    this.izquierdaC = (random(-1800, 1500))/100; 
  
    this.colorComponente1 = (int)(random(0, 255));
    this.colorComponente2 = (int)(random(0, 255));
    this.colorComponente3 = (int)(random(0, 255));
    
    this.CA = (random(0, 2200))/100;
    this.CB = (random(0, 2200))/100;
    this.iteraciones = (int)(random(800, 2000));
  }
  
  public genPez( float arriba, float abajo, float derecha, float izquierda, float derechaC, float izquierdaC, // Forma
                 int colorComponente1, int colorComponente2, int colorComponente3,                            // Color
                 float CA, float CB, int iteraciones)                                                         // Patron
  {
    this.arriba = arriba;
    this.abajo = abajo;
    this.derecha = derecha;
    this.izquierda = izquierda;
    this.derechaC = derechaC;
    this.izquierdaC = izquierdaC; 
  
    this.colorComponente1 = colorComponente1;
    this.colorComponente2 = colorComponente2;
    this.colorComponente3 = colorComponente3;
    
    this.CA = CA;
    this.CB = CB;
    this.iteraciones = iteraciones;
  }

  private void mutation(){
    if((int)random(0, 2) == 0 && this.arriba <= 25-1)
    this.arriba += (random(0, 10))/10.0;
    if((int)random(0, 2) == 0 && this.abajo <= 18-1)
    this.abajo += (random(0, 10))/10.0;
    if((int)random(0, 2) == 0 && this.derecha <= 12-1)
    this.derecha += (random(0, 10))/10.0;
    if((int)random(0, 2) == 0 && this.izquierda <= 2-2)
    this.izquierda += (random(0, 20))/10.0;
    if((int)random(0, 2) == 0 && this.derechaC <= 1-1)
    this.derechaC += (random(0, 10))/10.0;;
    if((int)random(0, 2) == 0 && this.izquierdaC <= 15-2)
    this.izquierdaC += (random(0, 20))/10.0; 
  
    if((int)random(0, 2) == 0 && this.colorComponente1 <= 255-10)
    this.colorComponente1 += (random(0, 10));
    if((int)random(0, 2) == 0 && this.colorComponente2 <= 255-10)
    this.colorComponente2 += (random(0, 10));
    if((int)random(0, 2) == 0 && this.colorComponente3 <= 255-10)
    this.colorComponente3 += (random(0, 10));
    
    if((int)random(0, 2) == 0 && this.CA < 22-1)
    this.CA += (random(0, 100))/100.0;
    if((int)random(0, 2) == 0 && this.CB < 22-1)
    this.CB += (random(0, 100))/100.0;
    if((int)random(0, 2) == 0 && this.iteraciones <= 3000-200)
    this.iteraciones += (random(80, 160));
    
    //--------------------------------------------------
    if((int)random(0, 2) == 0 && this.arriba >= -3+1)
    this.arriba -= (random(0, 10))/10.0;
    if((int)random(0, 2) == 0 && this.abajo >= -3+1)
    this.abajo -= (random(0, 10))/10.0;
    if((int)random(0, 2) == 0 && this.derecha >= -17+1)
    this.derecha -= (random(0, 10))/10.0;
    if((int)random(0, 2) == 0 && this.izquierda >= -40+2)
    this.izquierda -= (random(0, 20))/10.0;
    if((int)random(0, 2) == 0 && this.derechaC >= 0+1)
    this.derechaC -= (random(0, 10))/10.0;;
    if((int)random(0, 2) == 0 && this.izquierdaC >= -18+2)
    this.izquierdaC -= (random(0, 20))/10.0; 
  
    if((int)random(0, 2) == 0 && this.colorComponente1 >= 0+10)
    this.colorComponente1 -= (random(0, 10));
    if((int)random(0, 2) == 0 && this.colorComponente2 >= 0+10)
    this.colorComponente2 -= (random(0, 10));
    if((int)random(0, 2) == 0 && this.colorComponente3 >= 0+10)
    this.colorComponente3 -= (random(0, 10));
    
    if((int)random(0, 2) == 0 && this.CA >= 0.1+1)
    this.CA -= (random(0, 100))/100.0;
    if((int)random(0, 2) == 0 && this.CB >= 0.1+1)
    this.CB -= (random(0, 100))/100.0;
    if((int)random(0, 2) == 0 && this.iteraciones >= 1200+200)
    this.iteraciones -= (random(80, 160));
  }
  
  public String toString(int opcion){
    if (opcion == 1)
      return ("U: "+this.arriba+
              ", D: "+this.abajo+
              ", L: "+this.izquierda+
              ", R: "+this.derecha+
              ", L_c: "+this.izquierdaC+
              ", R_c: "+this.derechaC+
              ", C_1: "+colorComponente1+
              ", C_2: "+colorComponente2+
              ", C_3: "+colorComponente2+
              ", CA: "+CA+
              ", CB: "+CB+
              ", Iteraciones: " + iteraciones);
    if (opcion == 2)
      return ("./Pescera "+this.arriba+
              " "+this.abajo+
              " "+this.derecha+
              " "+this.izquierda+
              " "+this.derechaC+
              " "+this.izquierdaC+
              " "+CA+
              " "+CB+
              " "+colorComponente1+
              " "+colorComponente2+
              " "+colorComponente3+
              " " + iteraciones);
      return (" "+String.format("%f", this.arriba)+
              " "+String.format("%f", this.abajo)+
              " "+String.format("%f", this.derecha)+
              " "+String.format("%f", this.izquierda)+
              " "+String.format("%f", this.derechaC)+
              " "+String.format("%f", this.izquierdaC)+
              " "+String.format("%f", CA)+
              " "+String.format("%f", CB)+
              " "+colorComponente1+
              " "+colorComponente2+
              " "+colorComponente3+
              " " + iteraciones);
  }
  
  public genPez clone(){
    genPez nuevoMutado = new genPez( arriba, abajo, derecha, izquierda, derechaC, izquierdaC, // Forma
                                     colorComponente1, colorComponente2, colorComponente3,    // Color
                                     CA, CB, iteraciones);                                    // Patron
    nuevoMutado.mutation();
    return nuevoMutado;
  }
  
  public genPez crossG(genPez pair){
  
    float arriba = random(0,2) == 1 ? this.arriba: pair.arriba;
    float abajo = random(0,2) == 1 ? this.abajo : pair.abajo;
    float derecha = random(0,2) == 1 ? this.derecha : pair.derecha;
    float izquierda = random(0,2) == 1 ? this.izquierda : pair.izquierda;
    float derechaC = random(0,2) == 1 ? this.derechaC : pair.derechaC;
    float izquierdaC = random(0,2) == 1 ? this.izquierdaC : pair.izquierdaC; 
  
    int colorComponente1 = random(0,2) == 1 ? this.colorComponente1 : pair.colorComponente1;
    int colorComponente2 = random(0,2) == 1 ? this.colorComponente2 : pair.colorComponente2;
    int colorComponente3 = random(0,2) == 1 ? this.colorComponente3 : pair.colorComponente3;
    
    float CA = random(0,2) == 1 ? this.CA : pair.CA;
    float CB = random(0,2) == 1 ? this.CB : pair.CB;
    
    int iteraciones = random(0,2) == 1 ? this.iteraciones : pair.iteraciones;
  
    genPez nuevoMutado = new genPez( arriba, abajo, derecha, izquierda, derechaC, izquierdaC, // Forma
                                     colorComponente1, colorComponente2, colorComponente3,    // Color
                                     CA, CB, iteraciones);                                    // Patron
                                     
    nuevoMutado.mutation();
    return nuevoMutado;
  
  }
}
