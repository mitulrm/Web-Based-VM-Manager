<%-- 
    Document   : storagepool
    Created on : Mar 6, 2015, 3:55:04 AM
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
	<title> Add new Storage Pool </title>
	<link rel="stylesheet" type="text/css" href="css/menu.css" />
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
	<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
    </head>
    <body>
        <div class="col-lg-9" style="position:fixed; left:260px;">
            <div class="panel panel-primary" >
		<div class="panel-heading" aria-expanded="true">
                    <h3 class="panel-title">Add New Storage Pool</h3>
                </div>                  

                <div class="panel-body">
                    <form name="createvm" method="POST" action="createStoragePool">
                        <div id="part1">
                            
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Name</span> 
                                        <input type="text" class="form-control" name="name" id="name" placeholder="Enter Name of Storage Pool" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon">Type</span> 
                                        <select class="form-control" name="type" id='type'>
                                            <option value='dir'>dir : Filesystem Directory</option>
                                            <option value='disk'>disk : Physical Disk Device</option>
                                            <option value='iscsi'>iscsi : ISCSI Target</option>
                                            <option value='logical'>logical : Logical Volume Group</option>                                        
                                        </select>                               							
                                    </div>
                                </div>
                            </div>
                            <br />
                            <button type="button" class="btn btn-default" id="next">Next</button>                                
                        </div>
                        
                        <div id="dir">
                            <h3>File System Directory</h3> 
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Directory Path</span> 
                                        <input type="text" class="form-control" name="dirpath" id="dirpath" placeholder="Enter Path of your Directory" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>
                            <br />
                            <button type="button" class="btn btn-default" id="back1">Back</button>
                            <button type="submit" class="btn btn-default" id="finish">Finish</button>
                        </div>
                        
                        <div id="disk">
                            <h3>Physical Disk </h3>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Disk Path</span> 
                                        <input type="text" class="form-control" name="diskpath" id="diskpath" placeholder="Enter Path of your Disk" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Format</span> 
                                        <select class="form-control" name="diskformattype">
                                            <option></option>
                                            <option></option>
                                            <option></option>
                                            <option></option>                                        
                                        </select>                                                                  
                                    </div>
                                </div>
                            </div>                            
                            <br />
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Source Path</span> 
                                        <input type="text" class="form-control" name="sourcepath" id="sourcepath" placeholder="Path to existing Disk Device" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>
                            <br />
                            <button type="button" class="btn btn-default" id="back2">Back</button>
                            <button type="submit" class="btn btn-default" id="finish">Finish</button>                            
                        </div>                        

                        <div id="iscsi">
                            <h3>ISCSI Target</h3>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Target Path</span> 
                                        <input type="text" class="form-control" name="iscsipath" id="iscsipath" placeholder="/dev/disk/by-path" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>                            
                            <br />
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Host Name</span> 
                                        <input type="text" class="form-control" name="hostname" id="hostname" placeholder="Name of the host sharing the storage" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>                                                        
                            <br />
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Source Path</span> 
                                        <input type="text" class="form-control" name="iscsisourcepath" id="iscsisourcepath" placeholder="Path on the host that is being shared" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>                            
                            <br />
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">IQN</span>
                                        <input type="text" class="form-control" name="iqn" id="iqn" placeholder="IQN name of ISCSI target" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>                            
                            <br />
                            <button type="button" class="btn btn-default" id="back3">Back</button>
                            <button type="submit" class="btn btn-default" id="finish">Finish</button>                            
                        </div>                        

                        <div id="logical">
                            <h3>Logical Volume Group</h3> 
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Target Path</span> 
                                        <input type="text" class="form-control" name="logicaltargetpath" id="logicaltargetpath" placeholder="Location to the existing Volume Group" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>                          
                            
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <span class="input-group-addon" id="sizing-addon3">Source Path</span> 
                                        <input type="text" class="form-control" name="logicalsourcepath" id="logicalsourcepath" placeholder="Optional Volume to build new Volume on" aria-describedby="sizing-addon3">
                                    </div>
                                </div>
                            </div>
                            <br />
                            <button type="button" class="btn btn-default" id="back4">Back</button>
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
                $('#dir').hide();
                $('#disk').hide();
                $('#iscsi').hide();
                $('#logical').hide();
                
    
                $('#next').click(function(){
                    var type = $('#type').val();                                       
                    $('#part1').hide(); 
                    switch(type)
                    {
                        case 'dir' : 
                                $('#dir').fadeIn(2000);
                                break;
                                
                        case 'disk' : 
                                $('#disk').fadeIn(2000);
                                break;
            
                        case 'iscsi' : 
                                $('#iscsi').fadeIn(2000);
                                break;
                
                        case 'logical' : 
                                $('#logical').fadeIn(2000);
                                break;                                                        
                    }
                });
                
                $('#back1').click(function(){
                   $('#dir').hide();
                   $('#part1').fadeIn(2000); 
                });

                $('#back2').click(function(){
                    $('#disk').hide();                   
                    $('#part1').fadeIn(2000); 
                });

                $('#back3').click(function(){
                   $('#iscsi').hide();
                   $('#part1').fadeIn(2000); 
                });

                $('#back4').click(function(){
                   $('#logical').hide();
                   $('#part1').fadeIn(2000); 
                });

        
            });
		
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
