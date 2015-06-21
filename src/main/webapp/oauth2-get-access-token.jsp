<%@page import="org.apache.amber.oauth2.client.response.OAuthClientResponse"%>
<%@page import="org.apache.amber.oauth2.client.response.GitHubTokenResponse"%>
<%@page import="org.apache.amber.oauth2.client.URLConnectionClient"%>
<%@page import="org.apache.amber.oauth2.client.OAuthClient"%>
<%@page import="eduonix.server.security.OAuth2Constants"%>
<%@page import="org.apache.amber.oauth2.common.message.types.GrantType"%>
<%@ page import="org.apache.amber.oauth2.client.request.OAuthClientRequest" %>
<%@ page import="org.apache.amber.oauth2.common.message.types.ResponseType" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    try {
    	   
    String consumerKey = (String) session.getAttribute(OAuth2Constants.CONSUMER_KEY);
    System.out.println("oauth2-get-access-token.jsp consumerKey "+consumerKey);

    String consumerSecret =  (String) session.getAttribute(OAuth2Constants.CONSUMER_SECRET);
    System.out.println("oauth2-get-access-token.jsp consumerSecret "+consumerSecret);

    String tokenEndpoint = (String) session.getAttribute(OAuth2Constants.OAUTH2_ACCESS_ENDPOINT);
    System.out.println("oauth2-get-access-token.jsp tokenEndpoint "+tokenEndpoint);

    String code = (String) session.getAttribute(OAuth2Constants.CODE);
    System.out.println("oauth2-get-access-token.jsp code "+code);

    String callbackurl = (String) session.getAttribute(OAuth2Constants.OAUTH_CALLBACK);
    System.out.println("oauth2-get-access-token.jsp callbackurl "+callbackurl);

   
    OAuthClientRequest accessRequest = OAuthClientRequest.tokenLocation(tokenEndpoint)
    .setGrantType(GrantType.AUTHORIZATION_CODE)
    .setClientId(consumerKey)
    .setClientSecret(consumerSecret)
    .setRedirectURI(callbackurl)
    .setCode(code)
    .buildBodyMessage();

    System.out.println("oauth2-get-access-token.jsp getBody "+accessRequest.getBody());
    System.out.println("oauth2-get-access-token.jsp getLocationUri "+accessRequest.getLocationUri());
    System.out.println("oauth2-get-access-token.jsp getHeaders "+accessRequest.getHeaders());

    //create OAuth client that uses custom http client under the hood
    OAuthClient oAuthClient = new OAuthClient(new URLConnectionClient());
    
    OAuthClientResponse oAuthResponse = oAuthClient.accessToken(accessRequest);

    String accessToken = oAuthResponse.getParam(OAuth2Constants.ACCESS_TOKEN);
    System.out.println("oauth2-get-access-token.jsp accessToken "+accessToken);

    session.setAttribute(OAuth2Constants.ACCESS_TOKEN,accessToken);
    
    String idToken = oAuthResponse.getParam("id_token");
    System.out.println("oauth2-get-access-token.jsp idToken "+idToken);



    if(idToken != null) {
        session.setAttribute("id_token", idToken);
    }
    
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }        
%>
