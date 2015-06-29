<%@ page import="org.apache.amber.oauth2.client.request.OAuthClientRequest" %>
<%@ page import="eduonix.server.security.SecureUtils" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%

    try {

        String consumerKey = request.getParameter(SecureUtils.CONSUMER_KEY);
        String authzEndpoint = request.getParameter(SecureUtils.OAUTH2_AUTHZ_ENDPOINT);
        String consumerSecret = request.getParameter(SecureUtils.CONSUMER_SECRET);
        String authzGrantType = request.getParameter(SecureUtils.OAUTH2_GRANT_TYPE);
        String scope = request.getParameter(SecureUtils.SCOPE);

        session.setAttribute("callbackurl", request.getParameter("callbackurl"));
        session.setAttribute(SecureUtils.OAUTH2_GRANT_TYPE, authzGrantType);
        session.setAttribute(SecureUtils.CONSUMER_KEY, consumerKey);
        session.setAttribute(SecureUtils.CONSUMER_SECRET, consumerSecret);


            OAuthClientRequest authzRequest = OAuthClientRequest
                    .authorizationLocation(authzEndpoint)
                    .setClientId(consumerKey)
                    .setRedirectURI((String) session.getAttribute("callbackurl"))
                    .setResponseType(authzGrantType)
                    .setScope(scope)
                    .buildQueryMessage();
            String authoriseURI =authzRequest.getLocationUri();

            response.sendRedirect(authoriseURI);




    } catch (Exception e) {

    }
%>



    