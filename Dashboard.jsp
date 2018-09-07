<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.libvirt.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.sun.jna.*" %>
<%@ page import="com.sun.jna.ptr.*" %>	
<%@ page import="java.nio.file.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache-control" content="no-store">
<meta http-equiv="Cache-control" content="must-revalidate">
<meta http-equiv="pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>Virtual Machine Manager - Dashboard</title>
<link rel="stylesheet" type="text/css" href="css/menu.css" />
<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />	
</head>

<body>
<!-- Modal For Create VM 
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
 Modal for Create VM Ends Here-->

	<%      
            
            
                List<String> rechableUserNames;
                List<String> rechableIPAddresses;
                List<String> unRechableUserNames;
                List<String> unRechableIPAddresses;                
                BufferedReader br;                 
                String dir = null,tmp=null;
                //tmp = request.getContextPath();
                //dir = "/root/NetBeansProjects/kvmvmmanager/web/conf/";
                //Environment.initializeEnvironment(dir);
                
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
		
                
                Iterator itr = rechableUserNames.listIterator();
                Iterator itr1 = rechableIPAddresses.listIterator();		
                System.out.println("List Size:"+rechableUserNames.size());
                while(itr.hasNext())
                {
                    System.out.println("List:"+itr.next());
                }
                
                int count = 0;
                int size=rechableUserNames.size();
                Connect conn;
                while (count<size) 
                {            
                    System.out.println("In While, count = "+count);
                    //String str1 = itr.next();
                    //String str2 = (itr1.next();                                
                    String str1=rechableUserNames.get(count);
                    String str2=rechableIPAddresses.get(count);
                    System.out.println("Iterator Reached - Reachable is "+str1+"@"+str2); 
                    conn = null;

			try 
                        {
				//conn = new Connect("qemu+ssh://root@"+str1+"/system", false);
				//conn = new Connect("qemu:///system", false);
				conn = new Connect("qemu+ssh://"+str1+"@"+str2+"/system", false);
                                System.out.println("Connection created!");
			} 
                        
                        catch (LibvirtException e) {
				System.out.println("exception caught:" + e);
				System.out.println(e.getError());
                       
			}			
                        int [] idsOfVM = conn.listDomains();
			String [] namesOfInactiveVMs = conn.listDefinedDomains();
			int numOfActive = idsOfVM.length;
			int numOfInactive = namesOfInactiveVMs.length;
                        String hostName = conn.getHostName();
                
			
	%>		
			<div class="col-lg-8" style="left:260px;">
                        
                            <div class="panel panel-default panel-primary" >  
                                <div class="panel-heading" data-toggle="collapse" data-target="#collapsible<%=count%>" aria-expanded="true" aria-controls="collapsible">                                     
                                    <h3 class="panel-title">
                                        <%= hostName %>
                                        <span class="badge">
                                            <span data-toggle="tooltip" data-placement="bottom" title="Number of Active VMs on this Node">
                                                <%= numOfActive %>
                                            </span>
                                        </span>
                                        <span class="col-lg-offset-9"> 
                                            <span data-toggle="tooltip" data-placement="bottom" title="Create New VM"> 
                                                <a role="button" class="btn btn-default" data-toggle="modal" data-target="createVM.jsp" target="_blank"> 
                                                    <span class="glyphicon glyphicon-plus" aria-hidden="true"></span> 
                                                </a> 
                                            </span>
                                        </span>
                                    </h3>
                                </div>                                                                                                                                                                                                                        
        			<div class="panel-body collapse" id="collapsible<%=count%>">
                        <%
                        out.println("Name of Hypervisor is "+conn.getType()
                    + ". Version of Hypervisor is "+conn.getHypervisorVersion(conn.getType())+".<br/><br/>"	    
                    + "Number of Active Virtual Machines on this machine is:"+numOfActive+"<br/><br/>"
                    + "Number of Inactive Virtual Machines on this machine is:"+numOfInactive+"<br/><br/>");
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
                                    <td>
	<%
				if(state.equals("Running"))
                                {                                    
                                    out.println("<button type=\"button\" class=\"btn btn-default disabled\" aria-label=\"Run VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Run VM\"> <span class=\"glyphicon glyphicon-play\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<a href=\"VMOpsServlet?user="+str1+"&node="+str2+"&op=pause&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Pause VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Pause VM\"> <span class=\"glyphicon glyphicon-pause\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<a href=\"VMOpsServlet?user="+str1+"&node="+str2+"&op=shutoff&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Shutdown VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Shutdown VM\"> <span class=\"glyphicon glyphicon-off\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<a href=\"VMOpsServlet?user="+str1+"&node="+str2+"&op=delete&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Delete VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Delete VM\"> <span class=\"glyphicon glyphicon-trash\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<a href=\"migrate.jsp?user="+str1+"&node="+str2+"&op=migrate&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Migrate VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Migrate VM\"> <span class=\"glyphicon glyphicon-send\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<a href=\"editVM?user="+str1+"&node="+str2+"&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Edit Config\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Edit Config\"> <span class=\"glyphicon glyphicon-cog\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("</td>");
                                    out.println("</tr>");
                                }                                
                                else if(state.equals("Paused"))
        			{
                                    out.println("<a href=\"VMOpsServlet?op=resume&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Resume VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Resume VM\"> <span class=\"glyphicon glyphicon-play\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<button type=\"button\" class=\"btn btn-default disabled\" aria-label=\"Pause VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Pause VM\"> <span class=\"glyphicon glyphicon-pause\" aria-hidden=\"true\"></span></button>");
                                    out.println("<a href=\"VMOpsServlet?op=shutoff&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Shutdown VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Shutdown VM\"> <span class=\"glyphicon glyphicon-off\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<a href=\"VMOpsServlet?user="+str1+"&node="+str2+"&op=delete&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Delete VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Delete VM\"> <span class=\"glyphicon glyphicon-trash\" aria-hidden=\"true\"></span></button> </a>");                                    
                                    out.println("<a href=\"VMOpsServlet?user="+str1+"&node="+str2+"&op=migrate&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Migrate VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Migrate VM\"> <span class=\"glyphicon glyphicon-send\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<a href=\"editVM?user="+str1+"&node="+str2+"&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Edit Config\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Edit Config\"> <span class=\"glyphicon glyphicon-cog\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("</td>");
                                    out.println("</tr>");
        			}
        			else if(state.equals("Shutoff"))
        			{
                                    out.println("<a href=\"VMOpsServlet?user="+str1+"&node="+str2+"&op=start&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Start VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Start VM\"> <span class=\"glyphicon glyphicon-play\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<button type=\"button\" class=\"btn btn-default disabled\" aria-label=\"Pause VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Pause VM\"> <span class=\"glyphicon glyphicon-pause\" aria-hidden=\"true\"></span></button>");
                                    out.println("<button type=\"button\" class=\"btn btn-default disabled\" aria-label=\"Shutdown VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Shutdown VM\"> <span class=\"glyphicon glyphicon-off\" aria-hidden=\"true\"></span></button>");                                    
                                    out.println("<a href=\"VMOpsServlet?user="+str1+"&node="+str2+"&op=delete&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Delete VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Delete VM\"> <span class=\"glyphicon glyphicon-trash\" aria-hidden=\"true\"></span></button> </a>");
                                    out.println("<button type=\"button\" class=\"btn btn-default disabled\" aria-label=\"Migrate VM\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Migrate VM\"> <span class=\"glyphicon glyphicon-send\" aria-hidden=\"true\"></span></button>");
                                    out.println("<a href=\"editVM?user="+str1+"&node="+str2+"&name="+name+"\"><button type=\"button\" class=\"btn btn-default\" aria-label=\"Edit Config\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Edit Config\"> <span class=\"glyphicon glyphicon-cog\" aria-hidden=\"true\"></span></button> </a>");                                    
                                    out.println("</td>");
                                    out.println("</tr>");
        			}	
					
				}
        %>
                		</table>
                                </div>
                            </div>
                        </div>
        <%
                count++;
		}
	%>
<!--<script src="js/bootstrap.js"></script>
 	<script src="js/npm.js"></script>
	<script src="js/menu.js"></script>  -->
	<script src="js/jquery.min.js"></script>
 	<script src="js/bootstrap.min.js"></script> 
	<script >
	
            //For initializing Tooltips 
            $(document).ready(function(){
		$('[data-toggle="tooltip"]').tooltip();   
            });
		
    /*        //For Menu
            var menu = document.getElementById( 'menu' ),
            showmenu = document.getElementById( 'showmenu' ),
            body = document.body;
            
            showmenu.onclick = function() {
            classie.toggle( this, 'active' );
            classie.toggle( menu, 'vmm-menu-open' ); */

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
		}						
    
    };*/
            
            
	</script>	
</body>
</html>
