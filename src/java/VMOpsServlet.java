/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.libvirt.*;
/**
 *
 * @author root
 */
public class VMOpsServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private Connect conn = null;
    
    public VMOpsServlet()
    {
        
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
        try {
            /* TODO output your page here. You may use following sample code. */
            
            
            String operation=request.getParameter("op");
            String name=request.getParameter("name");
            String str1 = request.getParameter("user");
            String str2 = request.getParameter("node");
            
            try
            {
                conn = new Connect("qemu+ssh://"+str1+"@"+str2+"/system", false);
            }
            catch(LibvirtException e)
            {
                e.printStackTrace();
            }
			                                                 
            Domain d = conn.domainLookupByName(name);
            
            String uri=null;
            uri=request.getParameter("uri");
            
            switch(operation)
            {
                case "start" : d.create();
                                break;
                case "pause" : d.suspend();
                                break;
                case "resume" : d.resume();
                                break;
                case "shutoff" : d.destroy();
                                break;         
                case "delete" : 
                                d.undefine();
                                break;                    
                case "migrate" :/* String dest = request.getParameter("dest");
                                 String desturi = "qemu+ssh://"+dest+"/system";
                                 d.migrateToURI(desturi, Domain.VIR_MIGRATE_LIVE, null, null);*/
                    
                    //d.migrateToURI(uri,Domain.VIR_MIGRATE_LIVE, null, null);
                    /*System.out.println("Migrate Op Called!");
                    List<String> migrateCommands = new ArrayList<String>();
                    migrateCommands.add("/bin/sh");
                    migrateCommands.add("-c");
                    migrateCommands.add("virsh migrate --live "+name+" "+uri);
                    ProcessBuilder pb = new ProcessBuilder(migrateCommands);
                    Process p = pb.start();
                    BufferedReader br1 = new BufferedReader(new InputStreamReader(p.getInputStream()));
                    System.out.println(br1.readLine());
                    break;
                    */
            }
            
            //displayerror(out,"Testing... Testing!!!");
            
            response.sendRedirect("Dashboard.jsp");
        }
        
        catch (LibvirtException ex) {
            //Logger.getLogger(VMOpsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        displayerror(out,ex.toString());                                    
        }
        
        catch(Exception ex)
        {
            displayerror(out,ex.toString());
        }
        finally
        {
            
            out.println("</body>");
            out.println("</html>");            
        }
        
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