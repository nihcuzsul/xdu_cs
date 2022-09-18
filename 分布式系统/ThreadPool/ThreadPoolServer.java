//MyRMIServer.java
import java.io.*;
import java.net.*;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;


class MyThread implements Runnable{
 private Socket clientSocket;

 MyThread(Socket client) {
     clientSocket = client;
 }

 public void run()  {
     try {
         InputStream inStream = clientSocket.getInputStream();
         OutputStream outStream = clientSocket.getOutputStream();
         BufferedReader in = new BufferedReader(new InputStreamReader(inStream));
         PrintWriter out = new PrintWriter(outStream);
         String line = null;
         while ((line = in.readLine()) != null) {
             System.out.println("Message from this client:" + line);
             out.println(line);
             out.flush();
         }
     }catch (Exception e) {
         System.out.println("Exception");
         return;
     }
     finally {
         try {
             clientSocket.close();
         }
         catch (Exception e){
             e.printStackTrace();
             return;
         }
     }
 }
}

public class Server {
 public static void main(String[] args) throws Exception  {
     Socket clientSocket = null;
     ServerSocket listenSocket = new ServerSocket(8189);
     ThreadPoolExecutor executor = new ThreadPoolExecutor(6,12,100, TimeUnit.MILLISECONDS,new ArrayBlockingQueue<Runnable>(10));
     System.out.println("Server listening at 8189");
     while(true) {
         clientSocket = listenSocket.accept();
         System.out.println("Accepted connection from client");
         MyThread t = new MyThread(clientSocket);
         executor.execute(t);
     }
 }
}



