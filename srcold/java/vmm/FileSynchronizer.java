/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vmm;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import java.util.*;
/**
 *
 * @author root
 */
public class FileSynchronizer {
    
    public static void broadcastThis(String filename) throws FileNotFoundException,IOException {
    
        BufferedReader br = new BufferedReader(new FileReader(Environment.LOCATION_OF_NODES_CONSIDERED_FOR_SESSION_FILE));
        String str,tmpString=null;
        
        List<String> ipAddressesOfNodes = new ArrayList<String>();
        
        if (filename.equals("NodesManaged"))
            tmpString = "rsync -az "+Environment.LOCATION_OF_NODES_MANAGED_FILE+" ";
        else if (filename.equals("NodeInfo"))
            tmpString = "rsync -az "+Environment.LOCATION_OF_NODE_INFO_FILE+" ";
        else if (filename.equals("NodeAndVMInfo"))
            tmpString = "rsync -az "+Environment.LOCATION_OF_NODE_AND_VM_INFO_FILE+" ";
        
        List<String> commands = new ArrayList<String>();	
        
        while((str = br.readLine())!=null)
            ipAddressesOfNodes.add(str);
        
        Iterator<String> itr = ipAddressesOfNodes.iterator();
        
        while(itr.hasNext())
        {
            String finalString;
            finalString = tmpString + itr.next()+":"+Environment.LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES;
            
            commands.add("/bin/sh");	
            commands.add("-c");
            commands.add(finalString);
            
            ProcessBuilder pb = new ProcessBuilder(commands);
            Process p = pb.start();
            System.out.println(p.getOutputStream());            
        }                
    }

    public static void sendThis(String node,String filename) throws IOException
    {
        String tmpString;
        tmpString = null;
                        
        if (filename.equals("NodesManaged"))
            tmpString = "rsync -az "+Environment.LOCATION_OF_NODES_MANAGED_FILE+" ";
        else if (filename.equals("NodeInfo"))
            tmpString = "rsync -az "+Environment.LOCATION_OF_NODE_INFO_FILE+" ";
        else if (filename.equals("NodeAndVMInfo"))
            tmpString = "rsync -az "+Environment.LOCATION_OF_NODE_AND_VM_INFO_FILE+" ";
        
        List<String> commands = new ArrayList<String>();	                                
                
        String finalString;
        finalString = tmpString + node +":"+Environment.LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES;
        
        commands.add("/bin/sh");
        commands.add("-c");
        commands.add(finalString);

        ProcessBuilder pb = new ProcessBuilder(commands);
        Process p = pb.start();
        System.out.println(p.getOutputStream());        
    }                
}