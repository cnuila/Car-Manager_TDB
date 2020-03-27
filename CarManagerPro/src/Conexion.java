
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Carlos Nuila
 */
public class Conexion {
    
    private static Connection conn = null;
    private static String login = "admin";
    private static String clave = "Eagle1008";
    private static String url = "jdbc:oracle:thin:@proyectotdb.cf2eishw8pnc.us-east-1.rds.amazonaws.com:1521:ORCL";  
    
    public Connection getConnection(){
        try{
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(url,login,clave);
            conn.setAutoCommit(false);
            if (conn != null){
                System.out.println("Conexion Exitosa");
            } else {
                System.out.println("Conexion Erronea");
            }
        } catch (ClassNotFoundException | SQLException e){
            System.out.println("Conexion erronea " + e.getMessage());
        }
        return conn;
    }
    
    public void desconexion(){
        try{
            conn.close();
        } catch (Exception e){
            
        }
    }
}
//Jenifer estrada kambar