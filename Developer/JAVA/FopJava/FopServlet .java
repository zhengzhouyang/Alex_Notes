package com.cloudcreek.fop;

import java.io.*;
import java.net.URI;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import static java.nio.file.StandardCopyOption.*;
//
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.*;
//
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.fop.apps.*;
import org.apache.commons.io.output.*;
import javax.xml.transform.sax.*;
//
import java.nio.file.FileAlreadyExistsException;
import java.net.URISyntaxException;
import javax.servlet.ServletException;
//import javax.xml.transform.TransformerException;
//import org.apache.fop.apps.FOPException;
//
@WebServlet(value = "/fop", name = "fopServlet")
public class FopServlet extends org.apache.fop.servlet.FopServlet {
//
  private static final Logger logger = LogManager.getLogger();
//
  private static final long serialVersionUID = 1L;
  private String BASE_DIRECTORY ;
  private String XML_DATA_DIRECTORY = null;
  private String XML_DATA_ARCHIVE = null;
  private String XML_DATA_BAD = null;
  private String TEMPLATE_DIRECTORY = null;
  private String LOG_DIRECTORY = null;
  private String BASE_IMAGE_DIRECTORY = null;
//
  public void init() throws ServletException {
    super.init();
	//   this.transFactory = new net.sf.saxon.TransformerFactoryImpl();
	//
    // ResourceResolver resolver = new ResourceResolver() {
    //   public OutputStream getOutputStream(URI uri) throws IOException {
    //     logger.info("getOutputStream - Calling for uri: " + uri.toString());
    //     URL url = getServletContext().getResource(uri.toASCIIString());
    //     return url.openConnection().getOutputStream();
    //   }
    //   public Resource getResource(URI uri) throws IOException {
    //     logger.info("getResource - Calling for uri: " + uri.toString());
    //     return new Resource(getServletContext().getResourceAsStream(uri.toASCIIString()));
    //   }
    // };
    // FopFactoryBuilder builder = new FopFactoryBuilder(new File(".").toURI(), resolver);
    // FopFactoryBuilder builder = new FopFactoryBuilder(new File(".").toURI());
    URI uri = null;
	try {
		uri = new URI("http://localhost:8080/");
	} catch (URISyntaxException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    FopFactoryBuilder builder = new FopFactoryBuilder(uri);
    configureFopFactory(builder);
    fopFactory = builder.build();
    ResourceBundle bundle = ResourceBundle.getBundle("fop");
    Enumeration e = bundle.getKeys();
    while (e.hasMoreElements())
    {
      String key = (String) e.nextElement();
      String value = bundle.getString(key);
      if (key.equals("BASE_DIRECTORY"))
    	  BASE_DIRECTORY = value;
      else if (key.equals("XML_DATA_DIRECTORY"))
          XML_DATA_DIRECTORY = value;
      else if (key.equals("XML_ARCHIVE_DIRECTORY"))
    	  XML_DATA_ARCHIVE = value;
      else if (key.equals("XML_TEMPLATE_DIRECTORY"))
    	  TEMPLATE_DIRECTORY = value;
      else if (key.equals("LOG_DIRECTORY"))
    	  LOG_DIRECTORY = value;
      else if (key.equals("XML_DATA_BAD"))
    	  XML_DATA_BAD = value;
      else if (key.equals("BASE_IMAGE_DIRECTORY"))
   	   BASE_IMAGE_DIRECTORY = value;
    }
  }
//
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException {
    doFop(request, response);
  }
//
  public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException {
    doFop(request, response);
  }
//
  public void doFop(HttpServletRequest request, HttpServletResponse response) throws ServletException {
    try {
//
      String xmlParam = request.getParameter("xml");
      String templateParam = request.getParameter("template");
	  String docType  = request.getParameter("docType");
	
	  if (docType == null )
		  docType = "PDF";

      String pGoodSource = XML_DATA_DIRECTORY + xmlParam;
      Boolean fileFlag;
  //    Path pGoodTarget = (XML_DATA_ARCHIVE + xmlParam);
  //    Path pBadTarget = Paths.get(XML_DATA_BAD + xmlParam);
      logger.info("xml param: {}", xmlParam);
      logger.info("template param: {}", templateParam);
//
      String serverPath = request.getSession().getServletContext().getRealPath("/");
      logger.info("Server Path: {}", serverPath);
      //
      //fopFactory.setBaseURL(serverPath);
      // for fonts base URL :  .ttf from Resource path of project
      //fopFactory.getFontManager().setFontBaseURL(serverPath);
      // load up static values from fop.properties file
      //
      if (xmlParam != null && templateParam != null) {
    	  try {
    		  //renderXML(XML_DATA_DIRECTORY + xmlParam, TEMPLATE_DIRECTORY + templateParam, response);
			  if ( docType.equalsIgnoreCase("RTF"))
			  {
					response.setHeader("Content-disposition", "attachment; filename="+ xmlParam.substring(0,xmlParam.length()-4)+".rtf");
					renderRTF(XML_DATA_DIRECTORY + xmlParam, TEMPLATE_DIRECTORY + templateParam, response);
			  } else
			  {
					response.setHeader("Content-disposition", "attachment; filename="+ xmlParam.substring(0,xmlParam.length()-4)+".pdf");
					renderXML(XML_DATA_DIRECTORY + xmlParam, TEMPLATE_DIRECTORY + templateParam, response);
			  }
			  logger.info("Source Path {}", pGoodSource);
			  logger.info("XML Archive Path {}", XML_DATA_ARCHIVE);
			  logger.info("XML Bad Path {}", XML_DATA_BAD);
			  logger.info("Rendered Report Successfully - XML File: {} XSLT Template: {}", xmlParam, templateParam);
    		  fileFlag = moveFile(pGoodSource, XML_DATA_ARCHIVE);
    		  if(fileFlag) {
    			  logger.info("Moved XML File: {} Successfully.", xmlParam);
    		  } else {
    			  logger.info("Unable to Move XML File: {}.", xmlParam);
    		  }
    	  }  catch (  IOException ex) {
    		  fileFlag = moveFile(pGoodSource, XML_DATA_BAD);
    		  if(fileFlag) {
    			  logger.info("Moved XML File to Bad Archive: {} Successfully.", xmlParam);
    		  } else {
    			  logger.info("Unable to Move XML File to Bad Archive: {}.", xmlParam);
    		  }
    	  }
      } else {
        response.setContentType("text/html");
        PrintWriter out1 = response.getWriter();
        out1.println("<html><head><title>Error</title></head>\n" + "<body><h1>Errors on Request</h1>\n"
            + "Missing params</body></html>");
      }
    } catch (Exception ex) {
      throw new ServletException(ex);
    }
  }
	public boolean moveFile(String srcFileName, String destDirName) {

	    File srcFile = new File(srcFileName);
	    if(!srcFile.exists() || !srcFile.isFile())
	        return false;

	    File destDir = new File(destDirName);
	    if (!destDir.exists())
	        destDir.mkdirs();
	    return srcFile.renameTo(new File(destDirName + File.separator + srcFile.getName()));
	}
//
	protected void renderRTF(String xml, String xslt, HttpServletResponse response	)
						throws FOPException, TransformerException, IOException {

		Source xmlSrc = convertString2Source(xml);
		Source xsltSrc = convertString2Source(xslt);
		Transformer transformer = this.transFactory.newTransformer(xsltSrc);
		transformer.setURIResolver(this.uriResolver);
		renderRTF(xmlSrc, transformer, response);
	}
//
	protected void renderRTF(Source src, Transformer transformer, HttpServletResponse response)
						throws FOPException, TransformerException, IOException {
		FOUserAgent foUserAgent = getFOUserAgent();
		org.apache.commons.io.output.ByteArrayOutputStream out = new org.apache.commons.io.output.ByteArrayOutputStream();
		Fop fop = fopFactory.newFop(MimeConstants.MIME_RTF, foUserAgent, out);
		Result res = new SAXResult(fop.getDefaultHandler());
		transformer.transform(src, res);
		sendRTF(out.toByteArray(), response);
	}
//
	private void sendRTF(byte[] content, HttpServletResponse response) throws IOException {
		response.setContentType("application/rtf");
		response.setContentLength(content.length);
		response.getOutputStream().write(content);
		response.getOutputStream().flush();
	}
}
