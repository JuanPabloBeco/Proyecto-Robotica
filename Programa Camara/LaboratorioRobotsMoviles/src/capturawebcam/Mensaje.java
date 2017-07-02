package capturawebcam;
import java.io.*;
import java.net.*;
/**
 *
 * @author Ricardo
 */
public class Mensaje 
{
    protected DatagramSocket SOCK=null;
    byte[] BUFFER = new byte[1024];
    DatagramPacket PACKET = new DatagramPacket(BUFFER, BUFFER.length);
    InetAddress IP_ADDRESS=null;
    int PORT=444;
    public Mensaje() throws IOException
    {
        SOCK = new DatagramSocket(444);
	System.out.println("Esperando cliente...");   
    }
    public void Iniciar_Comunicacion() throws IOException
    {
        SOCK.receive(PACKET);
        IP_ADDRESS = PACKET.getAddress();
	PORT = PACKET.getPort();
	System.out.println("Comunicacion lista");
    }
    public void Enviar_Mensaje(Robot bot) throws IOException
    {
        String str = Integer.toString((int)bot.wd);
        str=str+",";
        str=str+Integer.toString((int)bot.wi);
	BUFFER = str.getBytes();
	PACKET = new DatagramPacket(BUFFER, BUFFER.length,IP_ADDRESS,PORT);
	SOCK.send(PACKET);
    }                               
}
