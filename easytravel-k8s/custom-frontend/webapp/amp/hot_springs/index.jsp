<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Eliminate the automatic creation of an HTTP session when accessing to a JSP page --%>
<%@page session="false"%>

<jsp:useBean id="ampWebsiteBean" class="com.dynatrace.easytravel.frontend.beans.AmpWebsiteBean" scope="request"/>
<!doctype html>
<html amp lang="en">
<head>
	<meta charset="utf-8">
	<script async src="https://cdn.ampproject.org/v0.js"></script>
	<title>Sathish Travels AMP website</title>
	<link href="/amp/img/favicon_orange_plane.ico" rel="shortcut icon">
	<link rel="canonical" href="/amp/">
	<meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">
	<script async custom-element="amp-analytics" src="https://cdn.ampproject.org/v0/amp-analytics-0.1.js"></script>
	<script async custom-element="amp-sidebar" src="https://cdn.ampproject.org/v0/amp-sidebar-0.1.js"></script>
	<script async custom-element="amp-fit-text" src="https://cdn.ampproject.org/v0/amp-fit-text-0.1.js"></script>
	<script async custom-element="amp-social-share" src="https://cdn.ampproject.org/v0/amp-social-share-0.1.js"></script>
	<script async custom-element="amp-carousel" src="https://cdn.ampproject.org/v0/amp-carousel-0.1.js"></script>
	<style amp-custom>
		#header ul {
			list-style-type: none;
			margin: 0;
			padding: 0;
			overflow: hidden;
			background-color: #F7BE81;
		}

		#header li {
			float: left;
			height: 50px;
			border-right:1px solid #FBF5EF;
		}

		#header li:last-child {
			border-right: none;
			float: right;
		}

		#header li a {
			display: block;
			color: white;
			text-align: center;
			padding: 16px 16px;
			text-decoration: none;
		}

		#header .active {
			background-color: #FF8000;
		}

		#sidebar {
			background-color: #F7BE81;
			text-align: left;
		}

		#sidebar ul {
			list-style-type: none;
			margin: 0;
			padding: 10px;
		}

		#sidebar li {
			font: 200 20px/1.5 Helvetica, Verdana, sans-serif;
			border-bottom: 1px solid #FBF5EF;
		}

		#sidebar li:last-child {
			border: none;
		}

		#sidebar li a {
			text-decoration: none;
			color: #000;
			display: block;
			width: 200px;
		}

		#sidebar .navigation {
			font: 200 30px/1.5 Helvetica, Verdana, sans-serif;
		}

		#sidebar .dynatrace {
			text-align: center;
		}

		#content h1 {
			font-size: 80px;
			text-align: center;
			font-family: helvetica, sans-serif;
			text-transform: uppercase;
		}

		#content h3 {
			font-size: 30px;
			text-align: center;
			font-family: helvetica, sans-serif;
			text-transform: uppercase;
		}

		#content .articles {
			background-color: #f5f5f5;
			margin: 1rem;
			display: flex;
			color: #111;
			padding: 0;
			box-shadow: 0 1px 1px 0 rgba(0,0,0,.14), 0 1px 1px -1px rgba(0,0,0,.14), 0 1px 5px 0 rgba(0,0,0,.12);
			text-decoration: none;
		}

		#content .articles > span {
			font-weight: 400;
			margin: 8px;
		}

		#content p {
			margin: 30px;
			text-align: justify;
		}

		#content ul {
			list-style-type: none;
			margin: 0;
			padding: 10px;
		}

		.dynatrace-ad {
			margin: 0 auto;
		}

		.dynatrace-ad-container {
			display: flex;
		}
	</style>
	<style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}</style><noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>
</head>
<body>
	<amp-sidebar id="sidebar" layout="nodisplay" side="left">
		<amp-img class="amp-close-image" srcset="/amp/img/ic_close_black_1x_web_24dp.png 1x, /amp/img/ic_close_black_2x_web_24dp.png 2x" width="40" height="40" alt="close sidebar" on="tap:sidebar.close" role="button" tabindex="0"></amp-img>
		<div id="sidebar">
			<ul>
				<li><a class="dynatrace" href="http://www.dynatrace.com"><amp-img width="180px" height="60px" src="/amp/img/dynatrace-logo.png"></amp-img></a></li>
				<li><a class="navigation" href="/amp/index.jsp">Home</a></li>
				<li><a class="navigation" href="/amp/gallery.jsp">Gallery</a></li>
				<li><a class="navigation" href="/amp/offices.jsp">Contact</a></li>
				<li><a class="navigation" href="/amp/info.jsp">About</a></li>
				<li><a href="/amp/hazel_hurst/">Hazel Hurst – Porta Westfalica</a></li>
				<li><a href="/amp/latrobe/">Latrobe</a></li>
				<li><a href="/amp/italy/">Italy</a></li>
				<li><a href="/amp/imbler/">Imbler – Mardela Springs</a></li>
				<li><a href="/amp/hot_springs/">Latrobe – California Hot Springs</a></li>
			</ul>
		</div>
	</amp-sidebar>

	<div id="header">
		<ul>
			<li><a on="tap:sidebar.toggle"><amp-img src="/amp/img/ic_menu_white_1x_web_24dp.png" width="24" height="24" alt="navigation"></amp-img></a></li>
			<li><a class="active" href="/amp/index.jsp">Home</a></li>
			<li><a href="/amp/gallery.jsp">Gallery</a></li>
			<li><a href="/amp/offices.jsp">Contact</a></li>
			<li><a href="/amp/info.jsp">About</a></li>
		</ul>
	</div>

	<div id="content">
		<div class="heading">
			<p><small>By demouser - Last updated: Thursday, July 4, 2013</small></p>
			<amp-social-share type="twitter" width="40" height="33"></amp-social-share>
			<amp-social-share type="facebook" width="40" height="33"></amp-social-share>
			<amp-social-share type="gplus" width="40" height="33"></amp-social-share>
			<amp-social-share type="email" width="40" height="33"></amp-social-share>
			<amp-social-share type="linkedin" width="40" height="33"></amp-social-share>
			<h1><amp-fit-text height="200" layout="fixed-height">Latrobe – California Hot Springs</amp-fit-text></h1>
			<p id="summary">As you slip into one of the many California hot springs, you’re sure to think it’s just another reason why we all love the place so much. You’ll find natural, mineral-laden hot water bubbling up all around the state, and we’ve rounded up a collection of the best places to enjoy them.</p>
			<amp-img src="/amp/img/hot_springs.jpg" width="1280" height="853" layout="responsive"></amp-img>

			<p>The California Hot Springs Resort is located in the Central-Southern Sierra Nevada Mountains of California. Just after entering The Sequoia National Monument, on Mountain Road 56, the traveler will happen upon the historic site of the resort.</p>

			<div class="dynatrace-ad-container"><a class="dynatrace-ad" href="http://www.dynatrace.com"><amp-img width="600px" height="200px" src="/amp/img/dynatrace-ads/dynatrace-2.png"></amp-img></a></div>

			<p>With elevations from 3,100 to 3,700 feet, California Hot Springs is mostly above the fog line and below the snow line.  On occasion the visitor can expect to experience Valley Floor (fog) or High Sierra (snow) weather, although it usually does not last.  Our winters are generally mild and are summers are sunny and beautiful.  The privately owned resort and R.V. Park are abutted on three sides by The Giant Sequoia National Monument.  For those who like to hike, nature trails are available to the east in The National Monument, including the Trail of a Hundred Giants.</p>

			<amp-carousel width="1280" height="1000" layout="responsive" type="slides">
				<figure>
					<amp-img src="/amp/img/hot_springs_1.jpg" width="1280" height="857" layout="responsive"></amp-img>
					<figcaption>Hot Springs in California</figcaption>
				</figure>
				<figure>
					<amp-img src="/amp/img/hot_springs_2.jpg" width="1280" height="853" layout="responsive"></amp-img>
					<figcaption>Hot Springs in California</figcaption>
				</figure>
				<figure>
					<amp-img src="/amp/img/hot_springs_3.jpg" width="1280" height="853" layout="responsive"></amp-img>
					<figcaption>Hot Springs in California</figcaption>
				</figure>
				<figure>
					<amp-img src="/amp/img/hot_springs_4.jpg" width="1280" height="853" layout="responsive"></amp-img>
					<figcaption>Hot Springs in California</figcaption>
				</figure>
			</amp-carousel>
			
			<h3>Related Articles</h3>
			<ul>
				<li><a class="articles" href="/amp/latrobe/"><amp-img width="100" height="70" src="/amp/img/latrobe.jpg"></amp-img><span>Latrobe</span></a></li>
				<li><a class="articles" href="/amp/imbler/"><amp-img width="100" height="70" src="/amp/img/imbler.jpg"></amp-img><span>Imbler – Mardela Springs</span></a></li>
			</ul>
		</div>
	</div>

	<div>
		<%= ampWebsiteBean.getJavaScriptTag() %>
	</div>
</body>
</html>