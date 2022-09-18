//MyCalcImpl.java
import java.rmi.RemoteException;

public class MyCalcImpl implements MyCalc {

    @Override
    public int add(int a, int b) throws RemoteException {
		System.out.println("Someone is calling me. a=" + a + "   b=" + b);
        return (a + b);
    }
}
