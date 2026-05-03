<h3>Session Key Names</h3>
<%@page import="java.util.Map"%>
<%@page import="java.util.Enumeration"%>

<%  
	for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet())
	{ 
		session.setAttribute(entry.getKey(), entry.getValue()[0]);
	}
%>
<pre>
<%
	for (Enumeration<String> e = session.getAttributeNames(); e.hasMoreElements(); )
	{
		%><%=e.nextElement()%><br /><%
	}
%>
</pre>