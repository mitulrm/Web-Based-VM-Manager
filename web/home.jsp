<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.UUID" %>
<%@ page import="org.libvirt.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.sun.jna.*" %>
<%@ page import="com.sun.jna.ptr.*" %>	
<%@ page import="executor.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="Cache-control" content="no-cache">
        <meta http-equiv="Cache-control" content="no-store">
        <meta http-equiv="Cache-control" content="must-revalidate">
        <meta http-equiv="pragma" content="no-cache"> 
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
	<title> Virtual Machine Manager </title>
	<link rel="stylesheet" type="text/css" href="css/menu.css" />
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
	<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />		
    </head>
    <body>        
        <nav class="vmm-menu vmm-menu-left" id="menu">
            <ul class="list-unstyled">          
                <li class="text-right"><a href="#" id="nav-close">X</a></li>
                <li><a href="#">Menu One <span class="icon"></span></a></li>
                <li><a href="#">Menu Two <span class="icon"></span></a></li>
                <li><a href="#">Menu Three <span class="icon"></span></a></li>
                <li><a href="#">Dropdown</a>
                    <ul class="list-unstyled">
                        <li class="sub-nav"><a href="#">Sub Menu One <span class="icon"></span></a></li>
                        <li class="sub-nav"><a href="#">Sub Menu Two <span class="icon"></span></a></li>
                        <li class="sub-nav"><a href="#">Sub Menu Three <span class="icon"></span></a></li>
                        <li class="sub-nav"><a href="#">Sub Menu Four <span class="icon"></span></a></li>
                        <li class="sub-nav"><a href="#">Sub Menu Five <span class="icon"></span></a></li>
                    </ul>
                </li>
                <li><a href="#">Menu Four <span class="icon"></span></a></li>
                <li><a href="#">Menu Five <span class="icon"></span></a></li>
            </ul>
	</nav>
		
	<div>
            <button id="showmenu">Menu</button>            
	</div>        



    
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
            
            String hostName = conn.getHostName();
            int numOfActive,numOfInactive;
            numOfActive=conn.numOfDomains();
            numOfInactive=conn.numOfDefinedDomains();
            int idsOfVM[]=conn.listDomains();
            String [] namesOfInactiveVMs= new String[numOfInactive];		
            namesOfInactiveVMs= conn.listDefinedDomains();
            int i=0;                              
	    
        %>
        
    <!--
       
       
    <a data-toggle="modal" href="storagePool.jsp" data-target="#myModal">Click me !</a>


<div class="modal-lg fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                 <h4 class="modal-title">Modal title</h4>

            </div>
            <div class="modal-body"><div class="te"></div></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
            </div>
        </div>

    </div>

</div>

        
    -->
        <div class="col-lg-9" style="position:fixed; left:260px;">
            <div class="panel panel-default panel-primary" >
		<div class="panel-heading" data-toggle="collapse" data-target="#collapsible" aria-expanded="true" aria-controls="collapsible">
                    <h3 class="panel-title">
			<%= hostName%>
                        <span class="col-lg-offset-10">
			<span data-toggle="tooltip" data-placement="top" title="Create New VM">
                         <!--   <button type="button" class="btn btn-default" aria-label="Create New VM" data-toggle="modal" data-target="#createnewModal">
                                <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                            </button> -->
                         
                        <a role="button" class="btn btn-default" data-toggle="modal" data-target="#createnewModal">
                                <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                            </a>
                         
			</span>
                        </span>
                    </h3>										
		</div>
                        
                        
        <script type="text/javascript">
    		function loadModalBody() {																					
			$('#createnewModalBody').load("/createVM.jsp");			
                    };
       </script>
				
		<div class="modal fade" id="createnewModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-remote="http://www.google.com">
                    <div class="modal-dialog">
			<div class="modal-content">
                            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                            </div>
                            <div class="modal-body" id="createnewModalBody">
                                <script type="text/javascript">
                                    loadModalBody();
                                </script>
                                
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary">Save changes</button>
                            </div>
			</div>
                    </div>
		</div>
	
		<div class="panel-body collapse" id="collapsible">

                    <%
                        out.println("Name of Hypervisor is "+conn.getType());
                        out.println(". Version of Hypervisor is "+conn.getHypervisorVersion(conn.getType())+"<br/><br/>");	    
                        out.println("Number of Active Virtual Machines on this machine is:"+numOfActive+"<br/><br/>");
                        out.println("Number of Inactive Virtual Machines on this machine is:"+numOfInactive+"<br/><br/>");
                        //out.println("<h2 align=\"Center\">List of Active VMs is:<br/><br/></h2>");		
                    %>
                    
                    
                    
                    <table class="table table-hover">
                    <%
                        for(i=0;i<(numOfActive+numOfInactive);i++)
        		{
                            Domain d=null;
                            String name,state;
                            if(i<numOfActive)
                            {
                                d = conn.domainLookupByID(idsOfVM[i]);
                                name = d.getName();
                            }   
                            else
                            {
                                name = namesOfInactiveVMs[i-numOfActive];
                                d = conn.domainLookupByName(name);                                
                            }
                            state= d.getInfo().state.name();
                            state=state.substring(state.lastIndexOf("_") + 1).toLowerCase();
                            char [] tmpState = state.toCharArray();
                            tmpState[0]=Character.toUpperCase(tmpState[0]);
                            state=String.valueOf(tmpState);

                    %>
                    
			<tr>
                            <td> <%=name%> </td>
                            <td align="center"> <%=state%> </td>
                            <td align="right">
                            
                            <%
                                if(state.equals("Paused"))
                                {
                                    out.println("<a href=\"VMOpsServlet?op=resume&name="+name+"\">");
                                }
                                else if(state.equals("Shutoff"))
                                {
                                    out.println("<a href=\"VMOpsServlet?op=start&name="+name+"\">");
                                }
                            %>
                            
                            
                                    <button type="button" class="btn btn-default" aria-label="Start VM" data-toggle="tooltip" data-placement="top" title="Start VM">
                                        <span class="glyphicon glyphicon-play" aria-hidden="true"></span>
                                    </button>
                                </a>
                                <a href="VMOpsServlet?op=pause&name=<%=name%>">
                                    <button type="button" class="btn btn-default" aria-label="Pause VM" data-toggle="tooltip" data-placement="top" title="Pause VM">
                                        <span class="glyphicon glyphicon-pause" aria-hidden="true"></span>
                                    </button>
                                </a>
                                <a href="VMOpsServlet?op=shutoff&name=<%=name%>">
                                    <button type="button" class="btn btn-default" aria-label="Shut Off VM" data-toggle="tooltip" data-placement="top" title="Shut Off VM">
                                        <span class="glyphicon glyphicon-off" aria-hidden="true"></span>
                                    </button>
                                </a>
				<!--Resource Info and Configuration Buttons has tooltips and Modals which requires two data-toggle attributes "modal tooltip". But this doesn't work together, so to fix this button is wrapped by <span> tag for tooltip -->
				<span data-toggle="tooltip" data-placement="top" title="Resourse Info of VM">
                                    <button type="button" class="btn btn-default" aria-label="Get Info" data-toggle="modal" data-target="#infoModal">
					<span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span>
                                    </button>
				</span>
								
				<div class="modal fade" id="infoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                    <div class="modal-dialog">
					<div class="modal-content">
                                            <div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                                            </div>
                                            <div class="modal-body">
						Resource Info
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary">Save changes</button>
                                            </div>
					</div>
                                    </div>
				</div>
								
				<span data-toggle="tooltip" data-placement="top" title="Configure VM">
                                    <button type="button" class="btn btn-default" aria-label="Configuration of VM" data-toggle="modal" data-target="#configModal">
					<span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                                    </button>
                                </span>
								
				<div class="modal fade" id="configModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                                            </div>
                                            <div class="modal-body">
						Config Modal
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary">Save changes</button>
                                            </div>
					</div>
                                    </div>
				</div>	
				
                                <button type="button" class="btn btn-default" aria-label="Delete VM" data-toggle="tooltip" data-placement="top" title="Delete VM">
                                    <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
				</button>
                            </td>
			</tr>
                        
                        <% 
                            }
                        %>
<!-- One Row Completes here -->			

                    </table>
		</div>
            </div>
	</div>
		
        
<!-- Adding Javascripts in the end so that page loads faster -->        

        <script src="js/bootstrap.js"></script>
	<script src="js/npm.js"></script>
	<script src="js/menu.js"></script>
	<script src="js/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script >
	
            //For initializing Tooltips 
            $(document).ready(function(){
		$('[data-toggle="tooltip"]').tooltip();   
            });
		
            //For Menu
            var menu = document.getElementById( 'menu' ),
            showmenu = document.getElementById( 'showmenu' ),
            body = document.body;
            
            showmenu.onclick = function() {
            classie.toggle( this, 'active' );
            classie.toggle( menu, 'vmm-menu-open' );

		/*	document.getElementById("modalStepNum").innerHTML = "Step "+$i+" of 4";
			if($i<4)
			{
				$('#CreateSubmit').hide();
				$('#CreateNext').show();
			}
			else
			{
				$('#CreateNext').hide();
				$('#CreateSubmit').show();
			}
		}
		function nextScreen() {
			($i)++;
			loadModalBody();
		}*/						
    
    };
            
            
	</script>
        
    </body>
</html> 