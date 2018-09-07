<%-- 
    Document   : migrate
    Created on : Apr 7, 2015, 9:32:28 AM
    Author     : root
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.libvirt.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.sun.jna.*" %>
<%@ page import="com.sun.jna.ptr.*" %>	
<%@ page import="java.nio.file.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Migrate</title>
    </head>
    <body>
        <%
            List<String> rechableUserNames;
                List<String> rechableIPAddresses;
                List<String> unRechableUserNames;
                List<String> unRechableIPAddresses;                
                BufferedReader br;                 
            br = new BufferedReader(new FileReader(
				("/root/NetBeansProjects/kvmvmmanager/web/conf/NodesManaged.txt")));
		rechableUserNames = new ArrayList<String>();
                rechableIPAddresses = new ArrayList<String>();
                unRechableUserNames = new ArrayList<String>();
                unRechableIPAddresses = new ArrayList<String>();
                String str;
	
                int i = 0;
          //      int tmpcount=0;
                while ((str = br.readLine())!=null)                 
                {            
                       // str = br.readLine();
                        String[] tmpArray = new String[2];
                        tmpArray = str.split("@");
                        System.out.println("tmparray[0]="+tmpArray[0]);
                        //System.out.println("tmparray[1]="+tmpArray[1] + "length="+tmpArray.length);  
                       
                        if (InetAddress.getByName(tmpArray[1]).isReachable(100)) {

                            rechableUserNames.add(tmpArray[0]);
                            System.out.println("Rechable Uname - "+tmpArray[0]);
                            rechableIPAddresses.add(tmpArray[1]);
                            System.out.println("Rechable IP - "+tmpArray[1]);
                        } else {

                            unRechableUserNames.add(tmpArray[0]);
                            System.out.println("Unrechable Uname - "+tmpArray[0]);
                            unRechableIPAddresses.add(tmpArray[1]);
                            System.out.println("Unrechable IP - "+tmpArray[1]);
                        }
                        
        //                tmpcount++;
                    }
                
                int count = 0;
                int size=rechableUserNames.size();
                System.out.println(size);
                Connect conn;
                String name = request.getParameter("name");
                String srcUser = request.getParameter("user");
                String srcNode = request.getParameter("node");
                while (count<size) 
                {            
                    System.out.println("In While, count = "+count);
                    //String str1 = itr.next();
                    //String str2 = (itr1.next();                                
                    String str1=rechableUserNames.get(count);
                    String str2=rechableIPAddresses.get(count);
                    String desturi = "qemu+ssh://"+str1+"@"+str2+"/system";
                    System.out.println(desturi);
                    out.println("<a href=\"VMOpsServlet?user="+srcUser+"&node="+srcNode+"&op=migrate&name="+name+"&uri="+desturi+"\">"+str2+"</a>");
                    count++;
                }

            
        %>
    </body>
</html>
