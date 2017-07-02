package capturawebcam;
/**
 *
 * @author Ricardo
 */
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.MulticastSocket;
import java.net.SocketException;

public class MCmensaje                  //MC corresponde a MultiCast
{
    final int mcPort = 4666;
    static DatagramSocket udpSocket = null;
    
    public MCmensaje() throws SocketException
    {
      udpSocket=new DatagramSocket();
    }
    
    public void sendMsg(String mensaje) throws IOException
    {
        byte[] msg = mensaje.getBytes();
        DatagramPacket packet = new DatagramPacket(msg, msg.length);
        packet.setAddress(InetAddress.getByName("220.1.1.2"));
        packet.setPort(mcPort);
        udpSocket.send(packet);
        //System.out.println("Sent a  multicast message."+mensaje);
        //udpSocket.close();
    }
    public void sendMCmove(String id) throws IOException, InterruptedException
    {
            byte[] msg = ((id)+"move").getBytes();
            System.out.println("Sincronizando...");
            DatagramPacket packet = new DatagramPacket(msg, msg.length);
            packet.setAddress(InetAddress.getByName("220.1.1.2"));
            packet.setPort(mcPort);
            udpSocket.send(packet);
    }
    
}
