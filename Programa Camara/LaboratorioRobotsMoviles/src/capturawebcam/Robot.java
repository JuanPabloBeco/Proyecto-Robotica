
package capturawebcam;
import java.net.*;
/**
 *
 * @author Ricardo
 */
public class Robot 
{
    //---------------------------------------------------
    //ATRIBUTOS
    //---------------------------------------------------
    public int id;
    public double L;  //Longitud entre las ruedas del robot en metros
    public double r; //radio de las ruedas de los robots en metros
    public int[] Posicion_actual=new int[4];
    public int[] Posicion_pixel=new int[4];
    public int[] Posicion_pixel_anterior=new int[4];
    public double[] Alpha=new double[2];
    public double th_actual,th_anterior,th_final;
    public double nOfRev_anterior,nOfRev;    //numero de revoluciones sobre su propio eje                                   
    public double wd;                                                           //Velocidad angular Rueda Der
    public double wi;                                                           //Velocidad angular Rueda Izq
    public double Fx;
    public double Fy;

}