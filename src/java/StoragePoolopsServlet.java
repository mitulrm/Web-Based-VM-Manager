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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;

/**
 *
 * @author root
 */
public class StoragePoolopsServlet extends HttpServlet {

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
    	public StoragePoolopsServlet() throws LibvirtException {        	
		
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
                
            try {    
                String poolName = request.getParameter("poolName");
                StoragePool pool = connect.storagePoolLookupByName(poolName);
                String op = request.getParameter("op");
                
                switch(op)
                {
                    case "start" :
                        pool.create(0);
                        break;
                        
                    case "stop" :
                        pool.destroy();
                        break;
                        
                    case "delete" :
                        pool.undefine();
                }
                
                response.sendRedirect("storagePool.jsp");
            } catch (LibvirtException ex) {
                Logger.getLogger(StoragePoolopsServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            
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
