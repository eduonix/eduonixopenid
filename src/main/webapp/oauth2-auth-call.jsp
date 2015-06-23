<%@ page import="org.apache.amber.oauth2.client.request.OAuthClientRequest" %>
<%@ page import="eduonix.server.security.SecureUtils" %>
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

        if (authzGrantType.equals(SecureUtils.OAUTH2_GRANT_TYPE_CODE) || authzGrantType.equals(SecureUtils.OAUTH2_GRANT_TYPE_IMPLICIT)) {

            OAuthClientRequest authzRequest = OAuthClientRequest
                    .authorizationLocation(authzEndpoint)
                    .setClientId(consumerKey)
                    .setRedirectURI((String) session.getAttribute("callbackurl"))
                    .setResponseType(authzGrantType)
                    .setScope(scope)
                    .buildQueryMessage();
            String authoriseURI =authzRequest.getLocationUri();
            System.out.println("authorise 1" +authoriseURI);
            response.sendRedirect(authoriseURI);
            return;

        }


    } catch (Exception e) {

    }
%>



    