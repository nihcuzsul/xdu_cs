package calculator;


import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class JSQ extends JFrame {


public static void main(String[] args) {
new JSQ();

}


public JSQ() {
setTitle("­pºâ¾¹"); 
setSize(240, 350); 
setLocationRelativeTo(null);
setLayout(new BorderLayout()); 
final JTextField lblxian = new JTextField(); 
lblxian.setPreferredSize(new Dimension(230, 70)); 
JPanel panelxian = new JPanel(); 
panelxian.add(lblxian);
add(panelxian, BorderLayout.NORTH); 
JPanel panelS = new JPanel();
add(panelS, BorderLayout.SOUTH);
panelS.setLayout(new GridLayout(5, 4)); 
JButton btnAC = new JButton("AC"); 
btnAC.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {
lblxian.setText(""); 

}
});
panelS.add(btnAC);
add(panelS);
JButton btnZhengFu = new JButton("+/-");
panelS.add(btnZhengFu);
add(panelS);
JButton btnBai = new JButton("%"); 
btnBai.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {
double num = Double.parseDouble(lblxian.getText());
lblxian.setText("" + (num / 100));

}
});
panelS.add(btnBai);
add(panelS);
JButton btnChu = new JButton("/"); 
btnChu.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {
if (lblxian.getText().indexOf("/") > 0) { 
} else {
lblxian.setText(lblxian.getText() + "/");
}
}
});
btnChu.setBackground(Color.orange);
panelS.add(btnChu);
add(panelS);
JButton btn7 = new JButton("7"); 
btn7.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

lblxian.setText(lblxian.getText() + 7);


}
});
panelS.add(btn7);
add(panelS);
JButton btn8 = new JButton("8");
btn8.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

lblxian.setText(lblxian.getText() + 8);

}
});
panelS.add(btn8);
add(panelS);
JButton btn9 = new JButton("9");
btn9.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

lblxian.setText(lblxian.getText() + 9);

}
});
panelS.add(btn9);
add(panelS);
JButton btnCheng = new JButton("X");
btnCheng.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) { 
if (lblxian.getText().indexOf("*") > 0) {

} else {
lblxian.setText(lblxian.getText() + "*");
}
}
});
btnCheng.setBackground(Color.orange);
panelS.add(btnCheng);
add(panelS);
JButton btn4 = new JButton("4"); 
btn4.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

lblxian.setText(lblxian.getText() + 4);

}
});
panelS.add(btn4);
add(panelS);
JButton btn5 = new JButton("5");
btn5.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

lblxian.setText(lblxian.getText() + 5);

}
});
panelS.add(btn5);
add(panelS);
JButton btn6 = new JButton("6");
btn6.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

lblxian.setText(lblxian.getText() + 6);

}
});
panelS.add(btn6);
add(panelS);
JButton btnJian = new JButton("-");
btnJian.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {
if (lblxian.getText().indexOf("-") > 0) { 

} else {
lblxian.setText(lblxian.getText() + "-");
}
}
});
btnJian.setBackground(Color.orange);
panelS.add(btnJian);
add(panelS);
JButton btn1 = new JButton("1");
btn1.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

lblxian.setText(lblxian.getText() + 1);

}
});
panelS.add(btn1);
add(panelS);
JButton btn2 = new JButton("2");
btn2.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

lblxian.setText(lblxian.getText() + 2);

}
});
panelS.add(btn2);
add(panelS);
JButton btn3 = new JButton("3");
btn3.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

lblxian.setText(lblxian.getText() + 3);

}
});
panelS.add(btn3);
add(panelS);
JButton btnJia = new JButton("+");
btnJia.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {
if (lblxian.getText().indexOf("+") > 0) { 

} else {
lblxian.setText(lblxian.getText() + "+");
}
}
});
btnJia.setBackground(Color.orange);
panelS.add(btnJia);
add(panelS);
JButton btn0 = new JButton("0");
btn0.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {
lblxian.setText(lblxian.getText() + 0);

}
});
panelS.add(btn0);
add(panelS);
JButton btnTui = new JButton("¡ö");
btnTui.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {
String c = lblxian.getText();
String num = c.substring(0, c.length() - 1); 
lblxian.setText(num);

}
});
panelS.add(btnTui);
add(panelS);
JButton btnDian = new JButton(".");
btnDian.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {
lblxian.setText(lblxian.getText() + ".");
}
});
panelS.add(btnDian);
add(panelS);
JButton btnDeng = new JButton("=");
btnDeng.addActionListener(new ActionListener() {

@Override
public void actionPerformed(ActionEvent e) {

String content = lblxian.getText(); 
int i = content.indexOf("+"); 
if (i > 0) {

String num1 = content.substring(0, i); 
String num2 = content.substring(i + 1, content.length());
try {
double fNum = Double.parseDouble(num1);
double sNum = Double.parseDouble(num2);
double sum = fNum + sNum; 
lblxian.setText("" + sum);

} catch (Exception e2) {

}
}


String content1 = lblxian.getText();
int j = content1.indexOf("-"); 
if (j > 0) {

String num1 = content1.substring(0, j); 
String num2 = content1.substring(j + 1, content1.length()); 
try {
double fNum = Double.parseDouble(num1);
double sNum = Double.parseDouble(num2);
double jian = fNum - sNum; 
lblxian.setText("" + jian); 
} catch (Exception e2) {
}
}
String content2 = lblxian.getText();
int k = content2.indexOf("*"); 
if (k > 0) {
String num1 = content2.substring(0, k); 
String num2 = content2.substring(k + 1, content2.length());
try {
double fNum = Double.parseDouble(num1);
double sNum = Double.parseDouble(num2);
double cheng = fNum * sNum;
lblxian.setText("" + cheng); 
} catch (Exception e2) {
}
}
String content3 = lblxian.getText();
int l = content3.indexOf("/"); 
if (l > 0) {
String num1 = content3.substring(0, l);
String num2 = content3.substring(l + 1, content3.length());
try {
double fNum = Double.parseDouble(num1);
double sNum = Double.parseDouble(num2);
double chu = fNum / sNum;
lblxian.setText("" + chu);

} catch (Exception e2) {
}
}
}
});
btnDeng.setBackground(Color.orange);
panelS.add(btnDeng);
add(panelS);
setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); 
setVisible(true);
}
}