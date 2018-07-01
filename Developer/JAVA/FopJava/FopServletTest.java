package com.cloudcreek.fop;

import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.saxon.TransformerFactoryImpl;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class FopServletTest extends org.apache.fop.servlet.FopServlet
{

    public FopServletTest()
    {
    }

	private FopFactory fopFactory = FopFactory.newInstance();
	private TransformerFactory tFactory = TransformerFactory.newInstance();

    public void init()
        throws ServletException
    {
        super.init();
        transFactory = new TransformerFactoryImpl();
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException
    {
        doFop(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException
    {
        doFop(request, response);
    }

    public void doFop(HttpServletRequest request, HttpServletResponse response)
        throws ServletException
    {
        try
        {

	        Fop fop;
            String xmlParam = request.getParameter("xml");
            String templateParam = request.getParameter("template");
			
			//introduce a new parameter to decide the file format
			String docType = request.getParameter("doctype");
			
            logger.info("xml param: {}", new Object[] {
                xmlParam
            });
            logger.info("template param: {}", new Object[] {
                templateParam
            });
            if(xmlParam != null && templateParam != null)
            {
				//Instantiate the fop using different MIME Type
				if(docType.equalsIgnoreCase("rtf"))
					fop = fopFactory.newFop(MimeConstants.MIME_RTF, out);
            	else
					fop = fopFactory.newFop(MimeConstants.MIME_PDF, out);
				
				Source xsltSrc = new StreamSource(new File((new StringBuilder()).append("/tmp/fop/data/new/").append(xmlParam).toString()));
                Transformer transformer = tFactory.newTransformer(xsltSrc);
				/*
					getDefaultHandler should return application/rtf or application/pdf
				*/
                Result res = new SAXResult(fop.getDefaultHandler());
                Source src = new StreamSource(new File((new StringBuilder()).append("/tmp/fop/templates/").append(templateParam).toString()));
                transformer.transform(src, res);
				
				//http header need to be changed too
				if(docType.equalsIgnoreCase("rtf"))
					response.setContentType("application/rtf");
            	else
					response.setContentType("application/pdf");
                
				response.setContentLength(out.size());
                response.getOutputStream().write(out.toByteArray());
				response.getOutputStream().flush();
//                renderXML((new StringBuilder()).append("/tmp/fop/data/new/").append(xmlParam).toString(), (new StringBuilder()).append("/tmp/fop/templates/").append(templateParam).toString(), response);
            } else
            {
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("<html><head><title>Error</title></head>\n<body><h1>Errors on Request</h1>\nMissing params</body></html>");
            }
        }
        catch(Exception ex)
        {
            throw new ServletException(ex);
        }
    }

    private static final Logger logger = LogManager.getLogger();
    private static final long serialVersionUID = 1L;
    private static final String XML_DATA_DIRECTORY = "/tmp/fop/data/new/";
    private static final String XML_DATA_ARCHIVE = "/tmp/fop/data/archive/";
    private static final String XML_DATA_BAD = "/tmp/fop/data/bad/";
    private static final String TEMPLATE_DIRECTORY = "/tmp/fop/templates/";
    private static final String LOG_DIRECTORY = "/tmp/fop/logs/";

}