<%-- 
    Document   : storagePool
    Created on : Mar 10, 2015, 6:02:26 AM
    Author     : root
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.UUID" %>
<%@ page import="org.libvirt.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.sun.jna.*" %>
<%@ page import="com.sun.jna.ptr.*" %>
<%@ page import="executor.*" %>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="Cache-control" content="no-cache">
        <meta http-equiv="Cache-control" content="no-store">
        <meta http-equiv="Cache-control" content="must-revalidate">
        <meta http-equiv="pragma" content="no-cache"> 
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
	
        <title> Storage Pools </title>
	
        <link rel="stylesheet" type="text/css" href="css/menu.css" />
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
	<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
        
        <script src="js/bootstrap.js"></script>
	<script src="js/npm.js"></script>
	<script src="js/menu.js"></script>
	<script src="js/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <div class="col-lg-7" style="position:fixed; left:260px;">
            
        <%    
		
            Connect conn=null;

	    try
		{
	    	conn = new Connect("qemu:///system", false);
	    } 
		catch (LibvirtException e) 
		{
	            System.out.println("exception caught:"+e);
	            System.out.println(e.getError());
	    }
            
            int numOfActive,numOfInactive;
            numOfActive=conn.numOfStoragePools();
            numOfInactive=conn.numOfDefinedStoragePools();
            String [] namesOfActivePools = new String[numOfActive];
            namesOfActivePools = conn.listStoragePools(); 
            String [] namesOfInactivePools= new String[numOfInactive];
            namesOfInactivePools= conn.listDefinedStoragePools();
        
        
        
            for(int i=0; i<numOfActive+numOfInactive;i++)
            {
                StoragePool pool = null;
                if(i<numOfActive)
                   pool = conn.storagePoolLookupByName(namesOfActivePools[i]);
                else
                   pool = conn.storagePoolLookupByName(namesOfInactivePools[i-numOfActive]);
                   StoragePoolInfo poolInfo = pool.getInfo();
                
                   String poolName = pool.getName();
                   
                    String state = poolInfo.state.toString();
                        state=state.substring(state.lastIndexOf("_") + 1).toLowerCase();
                            char [] tmpState = state.toCharArray();
                            tmpState[0]=Character.toUpperCase(tmpState[0]);
                            state=String.valueOf(tmpState);
           
        %>
 
        <div class="panel panel-default panel-primary" >
 <!--           <div class="panel-heading"> -->
 <div class="panel-heading" data-toggle="collapse" data-target="#collapsible<%= i %>" aria-expanded="true" aria-controls="collapsible<%= i %>">
                <h3 class="panel-title">
                <b>    <%= poolName%> </b> <span class="badge"> <%= state %> </span>
 
                    <span class="col-lg-offset-2">  
                <a href="StoragePoolopsServlet?op=start&poolName=<%=poolName%>">
                    <button type="button" class="btn btn-default" aria-label="Start Pool" data-toggle="tooltip" data-placement="top" title="Start Pool">
                        <span class="glyphicon glyphicon-play" aria-hidden="true"></span>
                    </button>
                </a>

                <a href="StoragePoolopsServlet?op=stop&poolName=<%=poolName%>">
                    <button type="button" class="btn btn-default" aria-label="Stop Pool" data-toggle="tooltip" data-placement="top" title="Stop Pool">
                        <span class="glyphicon glyphicon-off" aria-hidden="true"></span>
                    </button>
                </a>
                    
                <a href="StoragePoolopsServlet?op=delete&poolName=<%=poolName%>">
                    <button type="button" class="btn btn-default" aria-label="Delete Pool" data-toggle="tooltip" data-placement="top" title="Delete Pool">
                        <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                    </button>
                </a>                    
                    </span>
                </h3>                    
                    
            </div>
                
<!--            <div class="panel-body" id="collapsible<%= i %>"> -->
                <div class="panel-body collapse" id="collapsible<%= i %>">
                <%
                    
                    
                    //out.println("<b>State : </b>" + poolInfo.state + "<br />");
                    out.println("<b>Allocation : </b>" + (poolInfo.allocation / (1024*1024)) + " MB <br />");
                    out.println("<b>Available : </b>" + (poolInfo.available / (1024*1024)) + " MB<br />");
                    out.println("<b>Capacity : </b>" + (poolInfo.capacity / (1024*1024)) + " MB<br />");
                
                    
                    if(poolInfo.state == StoragePoolInfo.StoragePoolState.VIR_STORAGE_POOL_RUNNING )
                    {
                        
                            int numOfVols = pool.numOfVolumes();
                            String namesOfVols[] = new String[numOfVols];
                            namesOfVols = pool.listVolumes();

                %>    
                    <table class="table table-hover">
                        <tr>
                            <th> Volume Name </th>
                <!--            <th> Path </th>  -->
                            <th> Type </th>
                            <th> Allocation </th>
                            <th> Capacity </th>
                        </tr>                
                        
                        <div class="btn-group" data-toggle="buttons">
                            </div>
                                
                        
                        
                <%        
                    for(int j = 0;j<numOfVols;j++)
                    {
                        StorageVol vol = pool.storageVolLookupByName(namesOfVols[j]);
                        String volName = vol.getName();
                        String path = vol.getPath();
                        StorageVolInfo volInfo = vol.getInfo();
                        

                        
                %>
                
                        <tr>
                            <td> 
                               
                                <label class="btn btn-default">
                                    <input type="radio" name="volname" value="<%= volName %> " /> <%= volName %> 
                                </label>
                               
                            </td>
                    <!--        <td> <%= path %> </td> -->
                            <td> <%= volInfo.type %> </td>
                            <td> <%= (volInfo.allocation / (1024*1024)) %> MB </td>
                            <td> <%= (volInfo.capacity / (1024*1024)) %> MB </td>
                        </tr>
                    
                        
                <%
                        }
                    }
                %>
                
                    </table>
            </div>
        </div>
                    
           
        <%
           }
        %>
        
    
        
        
            <div class="btn-group" data-toggle="buttons">
                <label class="btn btn-default">
                    <input type="radio" name="gender" value="male" /> Male
                </label>
                <label class="btn btn-default">
                    <input type="radio" name="gender" value="female" /> Female
                </label>
                <label class="btn btn-default">
                    <input type="radio" name="gender" value="other" /> Other
                </label>
            </div>
        
    
        </div>
        
    

    </body>
</html>