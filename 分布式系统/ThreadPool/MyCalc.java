//MyCalc.java
// ������Զ�̷����Ľӿڣ��������֡��������͡�����ֵ
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface MyCalc extends Remote{
    int add(int a, int b) throws RemoteException;
}