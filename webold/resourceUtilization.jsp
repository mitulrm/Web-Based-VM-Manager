<%-- 
    Document   : resourceUtilization
    Created on : Apr 2, 2015, 3:18:57 AM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Resource Utilization</title>
        <script type="text/javascript" src="js/javascriptrrd.wlibs.js"></script>
    </head>
    <body>
    <button onclick="refresh()">Update</button>    
        
    <div id="mygraph"></div>

        
  
        <h1>CPU Utilization</h1>
        <div id="cpuGraph"></div>
        
        <h1>Disk I/O</h1>
        <div id="diskOpGraph"></div>
        
        <h1>Network I/O</h1>
        <div id="networkGraph"></div>
        


    <script type="text/javascript">

      //$(document).ready(function(){
    
    
        var cpu_graph_opts={legend: { noColumns:4}};
        var cpu_ds_graph_opts={'ns':{ color: "#00c0c0", label: 'CPU Utilization', 
                                       lines: { show: true, fill: true} } };


      var cpu_rrdflot_defaults={ graph_only: true, num_cb_rows:9, use_element_buttons: true, 
                             multi_ds:true, multi_rra: true, 
                             use_rra: true, rra:1, 
                             //If multi_ds is off, don't need to include "-GAUGE" in element names
                             use_checked_DSs: true, checked_DSs: ["ns-COUNTER"], 
                             use_windows:true,// window_min:1241752800000,window_max:1241974500000,
                             graph_width:"800px",graph_height:"300px", scale_width:"350px", scale_height:"200px",
                             timezone:"+5"};


        var diskop_graph_opts={legend: { noColumns:4}};
        var diskop_ds_graph_opts={'read':{ color: "#0042ff", label: 'read (KB)', 
                                       lines: { show: true, fill: true, fillColor:"#507dff"} },
                                  'write':{ label: 'write (KB)', color: "#ff3600", 
                                        lines: { show: true, fill: true, fillColor:"#ff5426" } } };
                             

        var diskop_rrdflot_defaults={ graph_only: true, num_cb_rows:9, use_element_buttons: true, 
                             multi_ds:true, multi_rra: true, 
                             use_rra: true, rra:1, 
                             //If multi_ds is off, don't need to include "-GAUGE" in element names
                             use_checked_DSs: true, checked_DSs: ["read-COUNTER","write-COUNTER"],
                             use_windows:true,// window_min:1241752800000,window_max:1241974500000,
                             graph_width:"800px",graph_height:"300px", scale_width:"350px", scale_height:"200px",
                             timezone:"+5"};


        var network_graph_opts={legend: { noColumns:4}};
        var network_ds_graph_opts={'rx':{ color: "#0042ff", label: 'In (KB)', 
                                       lines: { show: true, fill: true, fillColor:"#507dff"} },
                                'tx':{ label: 'out (KB)', color: "#ff3600", 
                                        lines: { show: true, fill: true, fillColor:"#ff5426" } } };

        var network_rrdflot_defaults={ graph_only: true, num_cb_rows:9, use_element_buttons: true, 
                             multi_ds:true, multi_rra: true, 
                             use_rra: true, rra:1, 
                             //If multi_ds is off, don't need to include "-GAUGE" in element names
                             use_checked_DSs: true, checked_DSs: ["rx-COUNTER","tx-COUNTER"],
                             use_windows:true,// window_min:1241752800000,window_max:1241974500000,
                             graph_width:"800px",graph_height:"300px", scale_width:"350px", scale_height:"200px",
                             timezone:"+5"};

        var cpurrd="data/rrd/openfiler2/libvirt/virt_cpu_total.rrd";
        var diskoprrd="data/rrd/openfiler2/libvirt/disk_octets-hda.rrd";
        var networkrrd="data/rrd/openfiler2/libvirt/if_octets-vnet0.rrd";

        cpu_obj=new rrdFlotAsync("cpuGraph",cpurrd,null,cpu_graph_opts,cpu_ds_graph_opts,cpu_rrdflot_defaults);
        diskop_obj=new rrdFlotAsync("diskOpGraph",diskoprrd,null,diskop_graph_opts,diskop_ds_graph_opts,diskop_rrdflot_defaults);
        network_obj=new rrdFlotAsync("networkGraph",networkrrd,null,network_graph_opts,network_ds_graph_opts,network_rrdflot_defaults);               

        function refresh() {
            cpu_obj.timeoutreload(cpurrd);
            diskop_obj.timeoutreload(diskoprrd);
            network_obj.timeoutreload(networkrrd);
            
            setTimeout(function(){ refresh() }, 30000);
        
        }	
            
        //  });

    </script>
        </body>
</html>
