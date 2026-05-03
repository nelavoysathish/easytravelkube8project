<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Eliminate the automatic creation of an HTTP session when accessing to a JSP page --%>
<%@page session="false"%>

<jsp:useBean id="specialOffersBean" class="com.dynatrace.easytravel.frontend.beans.SpecialOffersBean" scope="request"/>
<html>
    <head>
        <title>Special Offers - Landing Page</title>

        <link href="img/favicon_orange_plane.ico" rel="shortcut icon" />
        <link href="img/favicon_orange_plane.png" rel="apple-touch-icon" />

        <link href="css/BaseProd.css" rel="stylesheet" type="text/css" />
        <link href="css/footer.css" rel="stylesheet" type="text/css" />
        <link href="css/rime.css" rel="stylesheet" type="text/css" />
        <link href="css/rating.css" rel="stylesheet" type="text/css" />

        <link href="css/orange.css" rel="stylesheet" type="text/css" />
        <script src="js/jquery-1.8.1.js" type="text/javascript"></script>
        <script type="text/javascript" src="js/jquery-ui-1.8.2.min.js"></script>
        <script src="js/version.js" type="text/javascript"></script>
        <script src="js/dtagentApi.js" type="text/javascript"></script>
        <script src="js/FrameworkProd.js" type="text/javascript"></script>
        <script src="js/jquery.formLabels1.0.js" type="text/javascript"></script>
        <script src="js/headerRotation.js" type="text/javascript"></script>
        <script src="js/rating.js" type="text/javascript"></script>
        <script src="js/recommendation.js" type="text/javascript"></script>
    </head>
    <body>
        <div id="margins">
            <div xmlns="http://www.w3.org/1999/xhtml" class="header_container">

                <div class="header_content">
                    <div class="orangeHeader">
                        <div id="homelink">
                            <a href="/orange.jsf">Homelink</a>
                        </div>

                        <div class="orangeHeaderLinks">
                            <a href="/orange.jsf">Home</a><span class="orangeHeaderSeparator"></span>
                            <a href="/special-offers.jsp">Special Offers</a><span class="orangeHeaderSeparator"></span>
                            <a class="active_false" href="/about-orange.jsf">About</a><span class="orangeHeaderSeparator"></span>
                            <a class="active_false" href="/contact-orange.jsf">Contact</a><span class="orangeHeaderSeparator"></span>
                            <a class="active_false" href="/legal-orange.jsf">Terms of Use</a><span class="orangeHeaderSeparator"></span>
                            <a class="active_false" href="/privacy-orange.jsf">Privacy Policy</a><span class="orangeHeaderSeparator"></span>
                        </div>

                        <div class="orangeSocial">
                            <a class="iceOutLnk" href="itms-services://?action=download-manifest&amp;url=SECRET" id="j_idt37" title="download iOS app">
                                <img alt="download iOS app" src="img/apple/apple.png" /></a>
                            <a href="/apps/EasyTravelAndroid.apk" target="_blank"><img alt="download android app" src="img/androidbutton.png"/></a>
                            <a href="https://www.facebook.com/dynatrace" target="_blank"><img src="img/facebookbutton.png"/></a>
                            <a href="https://twitter.com/dynatrace" target="_blank"><img src="img/twitterbutton.png"/></a>
                            <a id="dynatrace" target="_blank" href="http://www.dynatrace.com"><img height="17px" width="17px" src="img/dynatrace.ico" /></a>
                            <img src="img/rssbutton.png"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="body_container">
                <div class="body_content">
                    <div class="contentContainer">
                        <div class="mainBox">
                            <h1 class="mainBoxHeader">Check out our new...</h1>
                            <div class="mainScrollBox">
                                <div class="mainTextBox">
                                	<script type="text/javascript">
										function specialOffersLoaded(){
											if(window.performance && window.performance.mark){
												window.performance.mark("mark_special_offers_loaded");
											}
										}
									</script>
                                    <p><img height="360px" src="img/specialoffersbig.png" width="500px" onload="specialOffersLoaded()" /></p>
									
                                </div>
                            </div>
                        </div>

                        <div class="orangeBanner">
                            <img src="img/Sathish Travels_banner.png" alt="promotion"/>
                        </div>
                        <div class="clearer"/>
                    </div>
                </div>
            </div>

            <div id="recommendation">
                <%= specialOffersBean.printRecommendations() %>
            </div>

            <div class="footer_container" xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml" xmlns:og="http://ogp.me/ns#">
                <div style="width:100%;clear:both">&#160;</div>
                <div class="footer_content">
                    <div style="clear: both;"></div>
                    <span class="pluginFooter"></span>
                    <div style="clear: both;"></div>
                    <div class="orangeLegal">
                        FARE TERMS AND CONDITIONS: Sample round-trip and one-way fares posted on www.easytravel.com are per person and include all applicable taxes and fees including, but not limited to September 11th Security Fee of up to $500 for each flight segment originating at a U.S. airport; Passenger Facility Charges of up to $18, depending on itinerary; Federal Segment Fees of $3.70 per segment; and foreign and U.S. government-imposed-charges of up to $400 per international round-trip flight, depending on routing and destination. A flight segment is defined as one takeoff and one landing. Fares are subject to availability and change without notice. If advertised fare is not available for dates chosen, higher fares may be offered. Actual prices may vary based on actual routing, fluctuations in currency (international only), and day of week.
                    </div>
                    <div style="clear: both;"></div>
                    <div class="orangeFooter">
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
