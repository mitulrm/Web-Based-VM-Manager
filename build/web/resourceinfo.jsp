<%@page import="com.sun.jna.*"%>
<%@ page import="com.sun.jna.ptr.*" %>
<%@page import="org.libvirt.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache-control" content="no-store">
<meta http-equiv="Cache-control" content="must-revalidate">
<meta http-equiv="pragma" content="no-cache"> 

<title>Resource Info About VM</title>
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

<a href="home.jsp"> Back to Home</a>
<br>
<h4>Select the VM whose resource usage is needed:(Resource Usage of only Active VMs can be obtained.)</h4>
<form method="post" action="VMOpsServlet"><input type="hidden" name="type" value="ResUsage" >
<select title="Resource Usage For VM" name="chosenVM">

<%
int idsOfVM[]= conn.listDomains();
int i=0;
while(i<idsOfVM.length)
{
	String name = conn.domainLookupByID(idsOfVM[i]).getName();
	out.println("<option name=\""+name+"\">"+name);
	i++;
}
%>

</select>
<input type="submit" value="Get Info">
</form>
<h3>Inactive VMs:</h3>
<%
Object flag;
flag = request.getAttribute("Status");

if(flag=="Processed")
	out.println("<div id=\"divInfo\" style=\"display: inline-block;\">");	
else
	out.println("<div id=\"divInfo\" style=\"display: none;\">");
%>

	<h2 align="center">General Info About VM</h2>
	<br>
	
	
	
	<p>
		ID:
		<%=request.getAttribute("ID")%></p>
	<p>
		Name:
		<%=request.getAttribute("Name")%></p>
	<p>
		UUID:
		<%=request.getAttribute("UUID")%></p>
	<hr>
	<h2 align="center">DomainInfo</h2>
	<br>
	<p>
		CPU Time:
		<%=request.getAttribute("CPUTime")%>
		seconds
	</p>
	<p>
		Max Memory:
		<%=request.getAttribute("MaxMem")%>
		MBytes
	</p>
	<p>
		Memory Used:
		<%=request.getAttribute("Mem")%>
		MBytes
	</p>
	<p>
		No. Of Virtual CPUs:
		<%=request.getAttribute("NVCPU")%></p>
	<hr>
	<h2 align="center">DomainJobInfo</h2>
	<br>
	<p>
		Data Processed:
		<%=request.getAttribute("DataProc")%></p>
	<p>
		Data Remaining:
		<%=request.getAttribute("DataRem")%></p>
	<p>
		Data Total:
		<%=request.getAttribute("DataTot")%></p>
	<p>
		File Processed:
		<%=request.getAttribute("FileProc")%></p>
	<p>
		Files Remaining:
		<%=request.getAttribute("FileRem")%></p>
	<p>
		Files Total:
		<%=request.getAttribute("FileTot")%></p>
	<p>
		Memory Processed:
		<%=request.getAttribute("MemProc")%></p>
	<p>
		Memory Remaining:
		<%=request.getAttribute("MemRem")%></p>
	<p>
		Memory Total:
		<%=request.getAttribute("MemTot") %></p>
	<p>
		Type:
		<%=request.getAttribute("Type") %></p>

</body>
</html>