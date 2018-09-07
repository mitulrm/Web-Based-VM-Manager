<%-- 
    Document   : createVM
    Created on : Jan 26, 2015, 3:27:12 AM
    Author     : root
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="Cache-control" content="no-cache">
        <meta http-equiv="Cache-control" content="no-store">
        <meta http-equiv="Cache-control" content="must-revalidate">
        <meta http-equiv="pragma" content="no-cache">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
        <link rel="stylesheet" type="text/css" href="css/menu.css" />
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
        <title>Create New VM</title>
    </head>
    <body>
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
	    
		%>
        <div class="col-lg-9" style="position:fixed; left:260px;">
            <div class="panel panel-primary" >
		<div class="panel-heading" aria-expanded="true">
                    <h3 class="panel-title">Create A New VM</h3>
                </div>                  

                <div class="panel-body">

                <form name="createvm" id="createvm" method="POST" action="createVM">
                    <div id="part1">
			<div class="row">
                            <div class="col-lg-7">
				<div class="input-group">
                                    <span class="input-group-addon" >Name</span> 
                                    <input type="text" class="form-control" name="nameofvm" id="nameofvm" placeholder="Enter Name of VM" aria-describedby="sizing-addon3">
				</div>
                            </div>
                        </div>
                    <br>
                    Choose How would you like to install the Operating System
                    <div class="row">
                        <div class="col-lg-7">
                            <div class="radio">
                                <label>
                                    <input type="radio" name="installos" id="installos" value="localmedia" checked>
                                        Local Install Media (ISO Image or CDROM)
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" name="installos" id="installos2" value="networkinstall">
                                        Network Install
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" name="installos" id="installos3" value="networkboot">
                                        Network Boot (PXE)
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" name="installos" id="installos4" value="existingdisk">
                                        Import Existing Disk Image
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <button type="button" class="btn btn-default" id="next1">Next</button>    
                    <button type="button" class="btn btn-default" id="cancel">Cancel</button>
                    
                </div>    

        
		<div id="part2">
                    <div class="col-lg-12">
                        Locate your install Media                    
                        <div class="row">
                            <div class="col-lg-7">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <label>
                                            <input type="radio" name="install media" id="installmedia1" value="cdordvd" aria-label="Install Media">
                                            Use CDROM or DVD
                                        </label>
                                    </span>
                                        <div class="dropdown">
                                            <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                                                 <span class="caret"></span>
                                            </button>
                                            <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1" name="noOfCPU">
                                                																		
                                            </ul>
                                            
                                        </div>
                                   
                                    
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-lg-7">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <label>
                                            <input type="radio" name="install media" id="installmedia1" value="iso" aria-label="Install Media">
                                            Use ISO Image
                                        </label>
                                    </span>
                                        
                                    <input type="text" class="form-control" name="isopath" aria-label="isopath">
                                    
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    
                    <div class="row">
			<div class="col-lg-3">
                            <div class="input-group">
				<span class="input-group-addon">OS Type</span> 

                            <select class="form-control" name="ostype" id="ostype">
                                <option>Generic</option>
                                <option>Windows</option>
                                <option>Linux</option>
                                <option>Solaris</option>
                                <option>Other</option>
                            </select>
                            </div>
			</div> 
                    </div>
                                                                                                                        
                    <div class="row">
			<div class="col-lg-3">
                            <div class="input-group">
				<span class="input-group-addon" >Architecture</span> 

                            <select class="form-control" name="osversion" id="osversion">
                                <option>RHEL 5</option>
                                <option>RHEL 6</option>
                                <option>RHEL 7</option>
                            </select>
                            </span>							
                            </div>
			</div> 
                    </div>
                       
                    
                   
                
                    <div class="row">
			<div class="col-lg-3">
                            <div class="input-group">
				<span class="input-group-addon" id="sizing-addon3">Architecture</span> 

                            <select class="form-control" name="architecture">
                                <option>i686</option>
                                <option>x86_64</option>
                            </select>
                            </span>							
                            </div>
			</div> 
                    </div>
                        
                    
                    
                    <button type="button" class="btn btn-default" id="back2">Back</button>    
                    <button type="button" class="btn btn-default" id="next2">Next</button>   
                    <button type="button" class="btn btn-default" id="cancel">Cancel</button>    
                </div>

                <div id="part3">
                    <div class="row">
			<div class="col-lg-4">
                            <div class="input-group">
				<span class="input-group-addon">RAM</span> 
                                    <input type="text" class="form-control" placeholder="Enter Memory" aria-describedby="sizing-addon3" name="ramsize">
					<span class="input-group-addon"> <input type="radio" aria-label="RAM" name="ramunit" value="MiB" CHECKED> MiB</span>							
					<span class="input-group-addon"> <input type="radio" aria-label="RAM" name="ramunit" value="GiB"> GiB</span> 
                            </div>
			</div>
                    </div>
                   
                    <br>
                                    
                    <div class="row">
			<div class="col-lg-3">
                            <div class="input-group">
				<span class="input-group-addon">No of CPU</span> 

                            <select class="form-control" name="noofcpu">
					<%
                                            int n = conn.nodeInfo().cpus;
                                            int i=1;
                                            while(i<=n)
                                            {
						out.println("<option>"+i+"</option>");										
						i++;
                                            }
					%>																		                                
                                
                            </select>
                            </span>							
                            </div>
			</div> 
                    </div>                                    
                                                                                                                        
                    <button type="button" class="btn btn-default" id="back3">Back</button>    
                    <button type="button" class="btn btn-default" id="next3">Next</button>   
                    <button type="button" class="btn btn-default" id="cancel">Cancel</button>    
                </div>
             
                <div id="part4">
                    
                    <label>
                        Storage for Virtual Machine
                    </label>
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <label>
                                            <input type="radio" name="storage" id="createDisk" value="file" aria-label="Install Media">
                                            Create Disk Image:
                                        </label>
                                    </span>
                                        
                                    <input type="text" class="form-control" name="disksize" id="diskSize" aria-label="disksize">
                                    <span class="input-group-addon">GB</span> 
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-lg-7">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <label>
                                            <input type="radio" name="storage" id="selectExisting" value="volume" aria-label="Install Media" checked>
                                            Select Existing Storage:
                                        </label>
                                    </span>
                                        
                                    <input type="text" class="form-control" name="volPath" id="volPath" aria-label="selectexisting">
                                    
                                </div>
                            </div>
                        </div>
                    
                    
                    <a data-toggle="modal" href="storagePool.jsp" data-target="#myModal">Click me !</a>

<!-- Modal -->
<div class="modal-lg fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false">
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
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->
                    
                    
                    
                    <button type="button" class="btn btn-default" id="back4">Back</button>    
                    <button type="button" class="btn btn-default" id="next4">Next</button>   
                    <button type="button" class="btn btn-default" id="cancel">Cancel</button>    
                </div>
                
                <div id="part5">
                    <button type="button" class="btn btn-default" id="back5">Back</button>    
                    <button type="button" class="btn btn-default" id="cancel">Cancel</button>    
                    <button type="submit" class="btn btn-default" id="finish">Finish</button>   
                </div>
            </form>                                
            </div>
        </div>
    </div>                               
	<script src="js/bootstrap.js"></script>
	<script src="js/npm.js"></script>
	<script src="js/menu.js"></script>
	<script src="js/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script >
	
            //For initializing Tooltips 
            $(document).ready(function(){
		$('[data-toggle="tooltip"]').tooltip();   
                
                $('#part1').show();
                $('#part2').hide();
                $('#part3').hide();
                $('#part4').hide();
                $('#part5').hide();
                
    
                $('#next1').click(function(){
                    $('#part1').hide();
                    $('#part2').fadeIn(2000);
                });
                
                $('#next2').click(function(){
                    $('#part2').hide();
                    $('#part3').fadeIn(2000);
                });

                $('#next3').click(function(){
                    $('#part3').hide();
                    $('#part4').fadeIn(2000);                                      
                });
                $('#next4').click(function(){
                    $('#part4').hide();
                    $('#part5').fadeIn(2000);
                });

                $('#back2').click(function(){
                    $('#part2').hide();
                    $('#part1').fadeIn(2000);
                });
                
                $('#back3').click(function(){
                    $('#part3').hide();
                    $('#part2').fadeIn(2000);
                });

                $('#back4').click(function(){
                    $('#part4').hide();
                    $('#part3').fadeIn(2000);
                });
                $('#back5').click(function(){
                    $('#part5').hide();
                    $('#part4').fadeIn(2000);
                });
                
    
            });
            
<%--
                $(#createvm input[name='storage']:radio).change(function{
                    if($(#createvm input[name="storage"]:checked).val()=='file')
                    {
                        $('#createDisk').removeAttr('disabled');
                        $('#selectExisting').attr('disabled','disabled');
                    }
                    else
                    {
                        $('#createDisk').attr('disabled','disabled');
                        $('#selectExisting').removeAttr('disabled');
                    }
                });
--%>        

            //For Menu
            var menu = document.getElementById( 'menu' ),
            showmenu = document.getElementById( 'showmenu' ),
            body = document.body;
            
            showmenu.onclick = function() {
            classie.toggle( this, 'active' );
            classie.toggle( menu, 'vmm-menu-open' );
            };
            
            
                    
            
	</script>

    </body>
</html>
