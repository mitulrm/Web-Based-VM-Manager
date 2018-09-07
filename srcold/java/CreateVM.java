/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;

import java.io.*;
import java.util.ArrayList;
import java.util.List;


import org.libvirt.*;

import com.sun.jna.*;

import executor.*;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

import org.w3c.dom.*;

@SuppressWarnings("unused")

@WebServlet(urlPatterns = {"/createVM"})

/**
 *
 * @author root
 */
public class createVM extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private Connect conn=null;
	public int idsOfVM[];
	public String[] namesOfInactiveVMs = null;
	public String pathForXMLFile="/var/lib/libvirt/images/";
	String nameofvm;
        
	public createVM() throws LibvirtException {        	
		
		System.out.println("Servlet Called");
	    try
		{
	    	conn = new Connect("qemu:///system", false);
	    } 
		catch (LibvirtException e) 
		{
	            System.out.println("exception caught:"+e);
	            System.out.println(e.getError());
	    }	        
        }
    
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
        
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
        try {
            /* TODO output your page here. You may use following sample code. */
            
            	nameofvm = request.getParameter("nameofvm");
		String memory = request.getParameter("ramsize");
//                String memoryunit = request.getParameter("ramunit");
		System.out.println(memory);
		String disk = request.getParameter("disksize");
		System.out.println(disk);
//		String arch = request.getParameter("Arch");
//		String sourceImage=request.getParameter("isopath");
//		String pathForXMLFile="/var/lib/libvirt/images/";
		String finalString = "/usr/bin/qemu-img create -f raw "+pathForXMLFile+nameofvm+".img "+disk+"G";
		Domain domain;
		
		//List of Commands to be executed to create VM Disk File
		List<String> commands = new ArrayList<String>();
		commands.add("/bin/sh");	
		commands.add("-c");
		commands.add(finalString);

		SystemCommandExecutor commandExecutor = new SystemCommandExecutor(commands);
		commandExecutor.executeCommand();
		
		String xml=this.createXML(request, out);
		
		out.println(xml);
		
		domain = conn.domainDefineXML(xml);
		domain.create();	
                
		response.sendRedirect("home.jsp");
	}
                
        catch(LibvirtException | IOException | InterruptedException | ParserConfigurationException | TransformerException ex)
        {
            displayerror(out,ex.getMessage());
            //displayerror(out,Arrays.toString(ex.getStackTrace()));
        }
        
        finally
        {
            out.println("</body>");
            out.println("</html>");
        }
      
        }
    
	private String createXML(HttpServletRequest request, PrintWriter out) throws IOException,ParserConfigurationException,TransformerException, LibvirtException{
			
		String xml = null;

		
		
        
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// root elements
			Document doc = docBuilder.newDocument();
			Element domain = doc.createElement("domain");
			doc.appendChild(domain);
			domain.setAttribute("type","kvm");


			Element name = doc.createElement("name");
			name.appendChild(doc.createTextNode(nameofvm));
			domain.appendChild(name);

			Element memory = doc.createElement("memory");
			memory.setAttribute("unit",request.getParameter("ramunit"));
			memory.appendChild(doc.createTextNode(request.getParameter("ramsize")));
			domain.appendChild(memory);

/*			Element currentmemory = doc.createElement("currentMemory");
			currentmemory.setAttribute("unit", "MiB");
			currentmemory.appendChild(doc.createTextNode("1024"));
			domain.appendChild(currentmemory);
*/
			Element vcpu = doc.createElement("vcpu");
//			vcpu.setAttribute("placement", "static");
			vcpu.appendChild(doc.createTextNode(request.getParameter("noofcpu")));
			domain.appendChild(vcpu);

			Element os = doc.createElement("os");

			Element type = doc.createElement("type");
			type.setAttribute("arch", request.getParameter("architecture"));
			type.setAttribute("machine", "rhel6.5.0");
			type.appendChild(doc.createTextNode("hvm"));
			os.appendChild(type);

			Element boot = doc.createElement("boot");
			boot.setAttribute("dev", "hd");
			os.appendChild(boot);

			boot = doc.createElement("boot");
			boot.setAttribute("dev", "cdrom");
			os.appendChild(boot);

			Element bootmenu = doc.createElement("bootmenu");
			bootmenu.setAttribute("enable", "yes");
			bootmenu.setAttribute("timeout", "900000");
			os.appendChild(bootmenu);

			domain.appendChild(os);

			Element features = doc.createElement("features");

			Element acpi = doc.createElement("acpi");
			features.appendChild(acpi);
			Element acpic = doc.createElement("apic");
			features.appendChild(acpic);
			Element pae = doc.createElement("pae");
			features.appendChild(pae);

			domain.appendChild(features);

			Element clock = doc.createElement("clock");
			clock.setAttribute("offset", "utc");
			domain.appendChild(clock);

			Element onpoweroff = doc.createElement("on_poweroff");
			onpoweroff.appendChild(doc.createTextNode("destroy"));
			domain.appendChild(onpoweroff);

			Element onreboot = doc.createElement("on_reboot");
			onreboot.appendChild(doc.createTextNode("restart"));
			domain.appendChild(onreboot);

			Element oncrash = doc.createElement("on_crash");
			oncrash.appendChild(doc.createTextNode("restart"));
			domain.appendChild(oncrash);

			Element devices = doc.createElement("devices");

			Element emulator = doc.createElement("emulator");
			emulator.appendChild(doc.createTextNode("/usr/libexec/qemu-kvm"));
			devices.appendChild(emulator);

                        Element disk = doc.createElement("disk");
                        
                        String storage = request.getParameter("storage");
                        if(storage.equals("volume"))
                        {
                            String volPath = request.getParameter("volPath");
                            out.println("<h3>Path:"+volPath+"</h3><br />");
                            disk.setAttribute("type", "block");
                            disk.setAttribute("device", "disk");
                            
                            Element driver = doc.createElement("driver");
                            driver.setAttribute("name", "qemu");
                            driver.setAttribute("type", "raw");
                            disk.appendChild(driver);
                            
                            Element disksource = doc.createElement("source");
                            disksource.setAttribute("dev", volPath);
                            disk.appendChild(disksource);
                        
                            Element target = doc.createElement("target");
                            target.setAttribute("dev", "hda");
                            target.setAttribute("bus", "ide");
                            disk.appendChild(target);
                            
                        }
                        
                        else
                        {
                            
                            disk.setAttribute("type", "file");
                            disk.setAttribute("device", "disk");

                            Element driver = doc.createElement("driver");
                            driver.setAttribute("name", "qemu");
                            driver.setAttribute("type", "raw");
                            disk.appendChild(driver);
                            
                            Element disksource = doc.createElement("source");
                            disksource.setAttribute("file", "/var/lib/libvirt/images/" + nameofvm + ".img");
                            disk.appendChild(disksource);

                            Element target = doc.createElement("target");
                            target.setAttribute("dev", "vda");
                            target.setAttribute("bus", "virtio");
                            disk.appendChild(target);

                            Element alias = doc.createElement("alias");
                            alias.setAttribute("name", "virtio-disk0");
                            disk.appendChild(alias);
                        }
                        
			devices.appendChild(disk);
                        
			disk = doc.createElement("disk");
			disk.setAttribute("type", "file");
			disk.setAttribute("device", "cdrom");

                        Element driver = doc.createElement("driver");
			driver = doc.createElement("driver");
			driver.setAttribute("name", "qemu");
			driver.setAttribute("type", "raw");
			disk.appendChild(driver);

                        Element disksource = doc.createElement("source");
			disksource = doc.createElement("source");
			disksource.setAttribute("file",request.getParameter("isopath"));
			disk.appendChild(disksource);

                        Element target = doc.createElement("target");
			target = doc.createElement("target");
			target.setAttribute("dev", "hdc");
			target.setAttribute("bus", "ide");
			disk.appendChild(target);

			disk.appendChild(doc.createElement("readonly"));

                        Element alias = doc.createElement("alias");                        
			alias = doc.createElement("alias");
			alias.setAttribute("name", "ide0-1-0");
			disk.appendChild(alias);

			devices.appendChild(disk);

			Element controller = doc.createElement("controller");
			controller.setAttribute("type", "usb");
			controller.setAttribute("index", "0");

			alias = doc.createElement("alias");
			alias.setAttribute("name", "usb0");
			controller.appendChild(alias);

			devices.appendChild(controller);

			controller = doc.createElement("controller");
			controller.setAttribute("type", "ide");
			controller.setAttribute("index", "0");

			alias = doc.createElement("alias");
			alias.setAttribute("name", "ide0");
			controller.appendChild(alias);

			devices.appendChild(controller);

			Element networkinterface = doc.createElement("interface");
			networkinterface.setAttribute("type", "network");

			Element mac = doc.createElement("mac");
			mac.setAttribute("address", "52:54:00:27:40:8f");
			networkinterface.appendChild(mac);

			Element networksource = doc.createElement("source");
			networksource.setAttribute("network", "default");
			networkinterface.appendChild(networksource);

			Element networktarget = doc.createElement("target");
			networktarget.setAttribute("dev", "vnet0");
			networkinterface.appendChild(networktarget);

			Element model = doc.createElement("model");
			model.setAttribute("type", "virtio");
			networkinterface.appendChild(model);

			Element networkalias = doc.createElement("alias");
			networkalias.setAttribute("name", "net0");
			networkinterface.appendChild(networkalias);

			devices.appendChild(networkinterface);

			Element serial = doc.createElement("serial");
			serial.setAttribute("type", "pty");

			alias = doc.createElement("alias");
			alias.setAttribute("name", "serail0");
			serial.appendChild(alias);

			devices.appendChild(serial);

			Element console = doc.createElement("console");
			console.setAttribute("type", "pty");

			target = doc.createElement("target");
			target.setAttribute("type", "serial");
			console.appendChild(target);

			alias = doc.createElement("alias");
			alias.setAttribute("name", "serail0");
			console.appendChild(alias);                               

			devices.appendChild(console);

			Element input = doc.createElement("input");
			input.setAttribute("type", "mouse");

			alias = doc.createElement("alias");
			alias.setAttribute("name", "input1");
			input.appendChild(alias);                                               

			devices.appendChild(input);

			Element graphics = doc.createElement("graphics");
			graphics.setAttribute("type", "vnc");
			graphics.setAttribute("autoport", "yes");
			graphics.setAttribute("listen", "127.0.0.1");

			Element listen = doc.createElement("listen");
			listen.setAttribute("type", "address");
			listen.setAttribute("address", "127.0.0.1");
			graphics.appendChild(listen);

			devices.appendChild(graphics);

			Element sound = doc.createElement("sound");
			sound.setAttribute("model", "ich6");

			alias = doc.createElement("alias");
			alias.setAttribute("name", "sound0");
			sound.appendChild(alias);                                               

			devices.appendChild(sound);

			Element video = doc.createElement("video");

			model = doc.createElement("model");
			model.setAttribute("type", "cirrus");
			model.setAttribute("vram", "9216");
			model.setAttribute("heads", "1");
			video.appendChild(model);

			alias = doc.createElement("alias");
			alias.setAttribute("name", "video0");
			video.appendChild(alias);                                               

			devices.appendChild(video);

			Element memballoon = doc.createElement("memballoon");
			memballoon.setAttribute("model", "virtio");

			alias = doc.createElement("alias");
			alias.setAttribute("name", "balloon0");
			memballoon.appendChild(alias);                                               

			devices.appendChild(memballoon);

			domain.appendChild(devices);
/*
                        // write the content into xml file
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "3");
			DOMSource source;
			source = new DOMSource(doc);
			if(source!=null)
				System.out.println("Source is not null");
			else
				System.out.println("Source is null");
			StreamResult result = new StreamResult(new File(pathForXMLFile + nameofvm + ".xml"));			
			if(result!=null)
				System.out.println("Result is not null");
			else
				System.out.println("Result is null");
			
			// Output to console for testing
			//StreamResult result = new StreamResult(System.out);
			
			transformer.transform(source, result);

			System.out.println("File saved!");
			
			FileReader fr = new FileReader(pathForXMLFile + nameofvm +".xml");
			BufferedReader br = new BufferedReader(fr);
			String str;
			
			while((str = br.readLine()) != null)
					xml=xml+str;
			
			System.out.println(xml);
			br.close();
			fr.close();
			
*/
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
            StringWriter writer = new StringWriter();
            transformer.transform(new DOMSource(doc), new StreamResult(writer));
            xml=writer.getBuffer().toString().replaceAll("\n|\r","");
            
        
        
                
	return xml;
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
