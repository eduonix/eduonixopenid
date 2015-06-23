<%@ page import="eduonix.server.security.SecureUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!

    String key=SecureUtils.CONSUMER_KEY_VALUE;
    String callbackurl =SecureUtils.OAUTH_CALLBACK_VALUE;
    String authorizeEndpoint=SecureUtils.OAUTH2_AUTHZ_ENDPOINT_VALUE;
%>


<!DOCTYPE html>
<html><head>
<title>Eduonix OpenID Connect </title>
<meta charset="UTF-8">
<meta name="description" content="" />
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>


</head><body>
            <div id="headerDiv" > </div>

              <div id="loginDiv" style="background-color:blue;margin:20px; padding:10px;top:120px;left:120px;position:fixed;font-size:large;" >

                  <form id="target" action="oauth2-auth-call.jsp" method="post">
                      <input type="hidden" name="grantType" value="code">
                      <input type="hidden" name="consumerKey" value="<%=key%>">
                      <input type="hidden" name="scope" value="openid">
                      <input type="hidden" name="callbackurl" value="<%=callbackurl%>">
                      <input type="hidden" name="authorizeEndpoint" value="<%=authorizeEndpoint%>">
                      <input type="submit" name="authorize" value="Login">
                  </form>
                </div>



            <script type="text/javascript">

                $( document ).ready(function() {
                    console.log( "ready!" );

                    $( "#headerDiv" ).css({ "background-color":"black", "margin":"20px", "padding":"10px 0 0 200px", "top":"-10px", "left":"-10px",
                        "position":"fixed", "font-size":"large" , "width":"100%" , "height":"5%", "color":"white"  }).text("Eduonix Secure Applications Open ID Connect");
                });

            </script>


</body>
</html>
