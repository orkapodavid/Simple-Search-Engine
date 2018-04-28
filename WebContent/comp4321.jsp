<html>
<body>
<%@page contentType="text/html" pageEncoding="UTF-8" errorPage="comp4321-Error.jsp"%>

<%@page import="java.util.*" %>
<%@page import="IRUtilities.*" %>
<%@page import="searchingRelated.*" %>

<% 

if(request.getParameter("keywords")!=null)
{
	
	out.println("The results are:<hr/>");
	String allString = request.getParameter("keywords");
	char spaceChar = ' ';
	char quoteChar = '\"';
	Vector<String> wordVec = new Vector<String>();
	int i = 0, startIndex = 0;
	boolean quoteFound = false;
	for (; i < allString.length(); i++){
	    char c = allString.charAt(i);   
	    if(c == spaceChar && !quoteFound){
	    	// save the current String
	    	if(i > startIndex){ // safety check
	    		wordVec.add(new String(allString.substring(startIndex, i)));
	    	}
	    	// skip and set startIndex = i+1 for next String
	    	startIndex = i+1;
	    }else if(c == quoteChar){
	    	if(quoteFound){
	    		// the close quotation mark 
	    		if(i > startIndex){ // safety check
		    		wordVec.add(new String(allString.substring(startIndex, i)));
		    	}
	    		quoteFound = false;
	    		startIndex = i+1;
	    	}else{
	    		// the open quotation mark 
	    		startIndex = i+1;
	    		quoteFound = true;
	    	}
	    }
	}
	// handle the last keyword
	if(i > startIndex){
		wordVec.add(new String(allString.substring(startIndex, i)));
	}
	out.println(wordVec);
	if(wordVec.size() == 0 ){
		out.println("Please input keyword(s) to search");
	}
	// use Searcher to compute the result
	Searcher searchEngine = new Searcher();
	Vector<Page> resultPageVec = searchEngine.search(wordVec);
	if(resultPageVec.size() > 0){
		out.println("<table>");
		for(i = 0; i < resultPageVec.size(); i++){
			Page currPage = resultPageVec.elementAt(i);
			out.println("<tr><td valign=\"top\">"+currPage.getScore()+"</td>");
		}
	}else{
		out.println("No document matches your search.");
	}
}


%>
</body>
</html>
