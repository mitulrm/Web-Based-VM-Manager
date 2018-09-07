/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.*;

import org.libvirt.*;

import com.sun.jna.*;

import executor.*;
import java.util.Arrays;
import javax.servlet.RequestDispatcher;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

import org.w3c.dom.*;

/**
 *
 * @author root
 */
public class createStoragePool extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    Connect connect;
    	public createStoragePool() throws LibvirtException {        	
		
		System.out.println("Servlet Called");
	    try
		{
	    	connect = new Connect("qemu:///system", false);
	    } 
		catch (LibvirtException e) 
		{
	            System.out.println("exception caught:"+e);
	            System.out.println(e.getError());
	    }	        
        }

    
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        out.println("<html>");        
        out.println("<head>");
        out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
        out.println("<meta http-equiv=\"Cache-control\" content=\"no-cache\">");
        out.println("<meta http-equiv=\"Cache-control\" content=\"no-store\">");
        out.println("<meta http-equiv=\"Cache-control\" content=\"must-revalidate\">");
        out.println("<meta http-equiv=\"pragma\" content=\"no-cache\"> ");
        out.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\">");
        out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/menu.css\" />");
        out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/bootstrap.css\" />");
        out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/bootstrap.min.css\" />		");
        out.println("</head>");
        out.println("<body>");        
        
        
        
        try 
        {
            /* TODO output your page here. You may use following sample code. */
            
            String storageType = request.getParameter("type");
            
            out.println("<h2>Storage Type" + storageType + "</h2>");
            String xml = null;
            
            switch(storageType)
            {
                case "dir": 
                    xml = createDir(request);
                    break;
                
                case "disk":
                    xml = createDisk(request);
                    break;
                   
                case "iscsi":
                    xml = createIscsi(request);
                    break;
                    
                case "logical":
                    xml = createLogical(request);
                    break;
            }
            
            out.println("XML : " + xml);
            StoragePool pool = connect.storagePoolDefineXML(xml,0);
            pool.build(0);
            pool.create(0);
            
            
            out.println("<h2>Pool Created!!</h2>");
            
            response.sendRedirect("storagePool.jsp");
            
        } 
        
        catch (LibvirtException | TransformerException | ParserConfigurationException ex) {
            displayerror(out,Arrays.toString(ex.getStackTrace()));
        }
        
        finally
        {
            out.println("</body>");
            out.println("</html>");
        }        

    }

    String createDir(HttpServletRequest request) throws TransformerException, ParserConfigurationException
    {
        String output = null;
        
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
            Document doc = docBuilder.newDocument();
            
            Element pool = doc.createElement("pool");
            doc.appendChild(pool);
            pool.setAttribute("type", "dir");
            
            Element name = doc.createElement("name");
            name.appendChild(doc.createTextNode(request.getParameter("name")));
            pool.appendChild(name);
            
            Element target = doc.createElement("target");
            pool.appendChild(target);
            
            Element path = doc.createElement("path");
            String dirpath = request.getParameter("dirpath");
            if(dirpath.isEmpty())
                dirpath = "/var/lib/libvirt/images";
            path.appendChild(doc.createTextNode(dirpath));
            target.appendChild(path);            
            
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
            StringWriter writer = new StringWriter();
            transformer.transform(new DOMSource(doc), new StreamResult(writer));
            output=writer.getBuffer().toString().replaceAll("\n|\r","");
            
        return output;
    }
    
    String createDisk(HttpServletRequest request) throws TransformerException, ParserConfigurationException
    {
        String output = null;

            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
            Document doc = docBuilder.newDocument();
            
            Element pool = doc.createElement("pool");
            doc.appendChild(pool);
            pool.setAttribute("type", "disk");
            
            Element name = doc.createElement("name");
            name.appendChild(doc.createTextNode(request.getParameter("name")));
            pool.appendChild(name);
            
            Element source = doc.createElement("source");
            pool.appendChild(source);
            
            Element device  = doc.createElement("device");
            device.setAttribute("path", request.getParameter("diskpath"));
            source.appendChild(device);
            
            Element format = doc.createElement("format");
            format.setAttribute("type", request.getParameter("format"));
            source.appendChild(format);
            
            Element target = doc.createElement("target");
            pool.appendChild(target);
            
            Element path = doc.createElement("path");
            path.appendChild(doc.createTextNode(request.getParameter("sourcepath")));
            target.appendChild(path);

            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
            StringWriter writer = new StringWriter();
            transformer.transform(new DOMSource(doc), new StreamResult(writer));
            output=writer.getBuffer().toString().replaceAll("\n|\r","");
            
        
        return output;                
    }
            
    String createIscsi(HttpServletRequest request) throws TransformerException, ParserConfigurationException
    {       
        String output = null;

            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
            Document doc = docBuilder.newDocument();
            
            Element pool = doc.createElement("pool");
            doc.appendChild(pool);
            pool.setAttribute("type", "iscsi");
            
            Element name = doc.createElement("name");
            name.appendChild(doc.createTextNode(request.getParameter("name")));
            pool.appendChild(name);
            
            Element source = doc.createElement("source");
            pool.appendChild(source);
            
            Element host = doc.createElement("host");
            host.setAttribute("name", request.getParameter("hostname"));
            source.appendChild(host);
            
            Element device = doc.createElement("device");
            device.setAttribute("path", request.getParameter("iqn"));
            source.appendChild(device);
            
            Element target = doc.createElement("target");
            pool.appendChild(target);
            
            Element path = doc.createElement("path");
            String iscsipath = request.getParameter("iscsipath");
            if(iscsipath.isEmpty())
                iscsipath = "/dev/disk/by‐path";
            path.appendChild(doc.createTextNode(iscsipath));
            target.appendChild(path);
            
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
            StringWriter writer = new StringWriter();
            transformer.transform(new DOMSource(doc), new StreamResult(writer));
            output=writer.getBuffer().toString().replaceAll("\n|\r","");
            
        return output;
    }
    
    String createLogical(HttpServletRequest request)
    {
        String output = null;
        
        return output;        
    }
    
    void displayerror(PrintWriter out, String error)
    {
        out.println("<div class=\"col-lg-9\" style=\"position:fixed; left:260px;\">");
        out.println("<div class=\"panel panel-default panel-danger\" >");
        out.println("<div class=\"panel-heading\" ");
        out.println("<h3 class=\"panel-title\">");
        out.println("Error!!");
        out.println("</h3>");
        out.println("</div>");
        out.println("<div class=\"panel-body\">");
        out.println("</h6>"+error+"</h6>");
        out.println("</div>");
        out.println("</div>");
        out.println("</div>");
    }    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
