package vmm;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.File;        
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;

public class Environment {

    public static String IS_MANAGEMENT_ON = "yes";
    public static int MAX_TIMEOUT_FOR_NETWORK = 100;
    public static String LOCATION_OF_NODES_MANAGED_FILE;
    public static String LOCATION_OF_NODE_INFO_FILE;
    public static String LOCATION_OF_NODE_AND_VM_INFO_FILE;
    public static String LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES;
    public static String LOCATION_OF_NODES_CONSIDERED_FOR_SESSION_FILE;
    public static String NETWORK_INTERFACE;
    
    
    public static void main(String[] args) throws IOException {
        
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str;
        System.out.println("Should Management be on? (yes/no): ");
        str = br.readLine();        
        if(str == null)
            IS_MANAGEMENT_ON = IS_MANAGEMENT_ON;
        else
        {
            str = str.toLowerCase();
            IS_MANAGEMENT_ON = str;
        }
        
        System.out.println("Maximum Timeout for Network in Milliseconds: ");
        str = br.readLine();        
        if(str == null)
            MAX_TIMEOUT_FOR_NETWORK = MAX_TIMEOUT_FOR_NETWORK;
        else        
            MAX_TIMEOUT_FOR_NETWORK = Integer.parseInt(str);
        
        System.out.println("Absolute Path of Directory with Config Files: ");
        str = br.readLine();        
        if(str == null)
            LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES = LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES;
        else        
        {
            if(!str.endsWith("/"))            
                str = str + "/";
            
            LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES = str;
            LOCATION_OF_NODES_MANAGED_FILE = str + "NodesManaged.txt";
            LOCATION_OF_NODE_INFO_FILE = str + "NodeInfo.xml";
            LOCATION_OF_NODE_AND_VM_INFO_FILE = str + "NodeAndVMInfo.xml";
            LOCATION_OF_NODES_CONSIDERED_FOR_SESSION_FILE = str + "NodesConsideredForSession.txt";
        }
                
        System.out.println("Network Interface to Use:");
        str = br.readLine();        
        if(str == null)
            MAX_TIMEOUT_FOR_NETWORK = MAX_TIMEOUT_FOR_NETWORK;
        else        
            MAX_TIMEOUT_FOR_NETWORK = Integer.parseInt(str);
        
        updateEnvironment();
    }
    
    public static void initializeEnvironment() throws FileNotFoundException,IOException {
    
        String str=null;
        
        List<String> commandsEnv = new ArrayList<String>();
     
     commandsEnv.add("/bin/sh");	
     commandsEnv.add("-c");     
     //commandsEnv.add("cat ~/.bashrc");     
     commandsEnv.add("echo $KVM_VM_MANAGER_HOME");
     ProcessBuilder pb = new ProcessBuilder(commandsEnv);
     Process p = pb.start();
     BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
     String strtmp;   
     String temp[];
     while((strtmp=br.readLine())!=null)
     {
         if(strtmp.startsWith("export"))
         {
            System.out.println(strtmp);
            temp[] = strtmp.split("=");
            temp[1]=temp[1].substring(1, (temp[1].length())-1);                        
            System.out.println(temp[1]);
            
         }
         //System.out.println(str);
     }
        
        str=temp[1];
        String tmp;
        FileReader f = new FileReader(str+"Environment.txt");
        BufferedReader br = new BufferedReader(f);
        while((tmp=br.readLine())!=null)
        {
            String tmpArray [] = tmp.split("=");
            tmpArray[0] = tmpArray[0].trim();
            tmpArray[1] = tmpArray[1].trim();
            if(tmpArray[0].equals("IS_MANAGEMENT_ON"))
                IS_MANAGEMENT_ON = tmpArray[1];
            else if(tmpArray[0].equals("MAX_TIMEOUT_FOR_NETWORK"))
                MAX_TIMEOUT_FOR_NETWORK = Integer.parseInt(tmpArray[1]);
            else if(tmpArray[0].equals("LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES"))
                LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES = tmpArray[1];
            else if(tmpArray[0].equals("LOCATION_OF_NODES_MANAGED_FILE"))
                LOCATION_OF_NODES_MANAGED_FILE = tmpArray[1];
            else if(tmpArray[0].equals("LOCATION_OF_NODES_CONSIDERED_FOR_SESSION_FILE"))
                LOCATION_OF_NODES_CONSIDERED_FOR_SESSION_FILE = tmpArray[1];
            else if(tmpArray[0].equals("LOCATION_OF_NODE_INFO_FILE"))
                LOCATION_OF_NODE_INFO_FILE = tmpArray[1];
            else if(tmpArray[0].equals("LOCATION_OF_NODE_AND_VM_INFO_FILE"))
                LOCATION_OF_NODE_AND_VM_INFO_FILE = tmpArray[1];
            else if(tmpArray[0].equals("NETWORK_INTERFACE"))
                NETWORK_INTERFACE = tmpArray[1];
            
        }
        br.close();
        f.close();
    
    }
    
    public static void updateEnvironment() throws IOException{

        String str = LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES + "Environment.txt";
        File f = new File(str);
        
        if(f.exists())
        {
            f.delete();            
            f.createNewFile();
        }
        FileWriter fw = new FileWriter(f);
        fw.write("IS_MANAGEMENT_ON=" + IS_MANAGEMENT_ON);
        fw.write("\nMAX_TIMEOUT_FOR_NETWORK=" + MAX_TIMEOUT_FOR_NETWORK);
        fw.write("\nLOCATION_OF_DIRECTORY_WITH_CONFIG_FILES=" + LOCATION_OF_DIRECTORY_WITH_CONFIG_FILES);
        fw.write("\nLOCATION_OF_NODES_MANAGED_FILE=" + LOCATION_OF_NODES_MANAGED_FILE);
        fw.write("\nLOCATION_OF_NODES_CONSIDERED_FOR_SESSION_FILE=" + LOCATION_OF_NODES_CONSIDERED_FOR_SESSION_FILE);
        fw.write("\nLOCATION_OF_NODE_INFO_FILE=" + LOCATION_OF_NODE_INFO_FILE);
        fw.write("\nLOCATION_OF_NODE_AND_VM_INFO_FILE=" + LOCATION_OF_NODE_AND_VM_INFO_FILE);
        fw.write("\nNETWORK_INTERFACE=" + NETWORK_INTERFACE);
        fw.close();       
        
    }        
}