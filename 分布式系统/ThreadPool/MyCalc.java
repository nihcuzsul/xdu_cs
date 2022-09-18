//MyCalc.java
// 定义了远程方法的接口：方法名字、参数类型、返回值
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface MyCalc extends Remote{
    int add(int a, int b) throws RemoteException;
}