<%-- 
    Document   : editvm
    Created on : Jan 2, 2015, 5:48:57 AM
    Author     : root
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ page import="org.libvirt.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.sun.jna.*" %>
<%@ page import="com.sun.jna.ptr.*" %>	
<%@ page import="executor.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Virtual Machine</title>

	<link rel="stylesheet" type="text/css" href="css/menu.css" />
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
	<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />		
    
        <script>
            function saveChanges(id)
            { 
                var xreq;
                var str = docuement.getElementById(id).innerHTML;
                if(window.XMLHttpRequest)
                {
                    xreq=new XMLHttpRequest();
                }
                else
                {
                    xreq=new ActiveXObject("Microsoft.XMLHTTP");
                }
        
                xreq.onreadystatechange=function ()
                {
                    if((xreq.readyState ==4) && (xreq.status==200))
                    {
                        document.getElementById("showtext").innerHTML=xreq.responseText;
                    }
                };
                xreq.open("get","/editvm?st="+str+",name="+name,"true");
            
                xreq.send();
            }

        </script>
        
    </head>
    
    
    <body>
	<div id="Overview">
            <h1> Overview </h1>
			
            <table>
		<tr>
                    <th>Basic Details</th>
                    <th></th>
		</tr>
			
		<tr>
                    <td>Name</td>
                    <td>
			<div class="input-group">
                            <input type="text" class="form-control" placeholder="Search for...">
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="button">Go!</button>
                            </span>				
			</div>
                    </td>
		<tr>
                    <td>UUID</td>
                    <td></td>
		</tr>
		<tr>
                    <td>Status</td>
                    <td></td>
		</tr>
		<tr>
                    <td>Description</td>
                    <td>
                        <div class="input-group">
                            <textarea class="form-control" rows="3"></textarea>
                            <span class="input-group-btn">
				<button class="btn btn-default" type="button">Go!</button>
                            </span>				
			</div>			
                    </td>
                </tr>
                
                <tr>
                    <th>Hypervisor Details</th>
                    <th></th>
                </tr>
                
                <tr>
                    <td>Hypervisor</td>
                    <td></td>
                </tr>
                
                <tr>
                    <td>Architecture</td>
                    <td></td>
                </tr>
                
                <tr>
                    <td>Emulator</td>
                    <td></td>
                </tr>
                
                <tr>
                    <th>Operating System</th>
                    <th></th>
                </tr>

                <tr>
                    <td>Host Name</td>
                    <td></td>
                </tr>
                
                <tr>
                    <td>Product Name</td>
                    <td></td>
                </tr>                
            </table>        
	</div>
    </body>
</html>
