/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vmm;

import java.net.*;
import java.util.*;
/**
 *
 * @author root
 */
public class Startup {

    public Startup() throws SocketException {
    
        Enumeration<NetworkInterface> networkInterface = NetworkInterface.getNetworkInterfaces();
        
        while(networkInterface.hasMoreElements())
        {
            NetworkInterface ni ;
            ni = networkInterface.nextElement();
            System.out.println(ni.getDisplayName());
            
            Enumeration<InetAddress> inetAddresses = ni.getInetAddresses();
            
            while(inetAddresses.hasMoreElements())            
                System.out.println(inetAddresses.nextElement().toString());
            
        }
        
    }
    
    public static void main(String[] args) throws SocketException {
        
        new Startup();
    }
    
}