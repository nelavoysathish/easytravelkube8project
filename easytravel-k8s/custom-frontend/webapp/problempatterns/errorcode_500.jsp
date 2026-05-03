<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Http Error Response Generator</title>
</head>
<body>
<%@page import="java.util.Map"%>
<%@page import="java.util.Enumeration"%>
<%@page import="javax.servlet.http.HttpSession"%>

<%
String preventError = request.getParameter("showerror");

if (preventError!=null && preventError.equalsIgnoreCase("true")) 
{
	throw new IllegalArgumentException("Exception thrown because http-errorcode 500 expected as response.");	
}
%>

No error thrown --> showing page.
<br/>
If you would like to see an http-errocode 5xx. Please call this page with a 
parameter "showerror=true".


</body>
</html>