package eduonix.server.security;


import org.apache.amber.oauth2.client.OAuthClient;
import org.apache.amber.oauth2.client.URLConnectionClient;
import org.apache.amber.oauth2.client.response.OAuthAuthzResponse;
import org.apache.amber.oauth2.client.response.OAuthClientResponse;
import org.apache.amber.oauth2.common.exception.OAuthProblemException;
import org.apache.amber.oauth2.common.exception.OAuthSystemException;
import org.apache.amber.oauth2.common.message.types.GrantType;

import javax.net.ssl.*;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.KeyStore;
import java.util.Enumeration;

import org.apache.amber.oauth2.client.request.OAuthClientRequest;

/**
 * Created by user on 6/19/15.
 */
public class OAuth2CallbackServlet  extends HttpServlet {



    private static final long serialVersionUID = -5587487420597790757L;

    static String userName;
    static String password;
    static String serverUrl;


    @Override
    public void init(ServletConfig config) throws ServletException {

        // All the code below is to overcome host name verification failure we get in certificate
        // validation due to self-signed certificate. This code should not be used in a production
        // setup.

        try {

            SSLContext sc;

            // Get SSL context
            sc = SSLContext.getInstance("SSL");

            // Create empty HostnameVerifier
            HostnameVerifier hv = new HostnameVerifier() {
                public boolean verify(String urlHostName, SSLSession session) {
                    return true;
                }
            };

            // Create a trust manager that does not validate certificate chains
            TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }

                public void checkClientTrusted(java.security.cert.X509Certificate[] certs,
                                               String authType) {
                }

                public void checkServerTrusted(java.security.cert.X509Certificate[] certs,
                                               String authType) {
                }
            } };

            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            //SSLSocketFactory sslSocketFactory = sc.getSocketFactory();

            //HttpsURLConnection.setDefaultSSLSocketFactory(sslSocketFactory);
            SSLContext.setDefault(sc);
            HttpsURLConnection.setDefaultHostnameVerifier(hv);

            // Load init parameters.
            userName = config.getInitParameter("userName");
            password = config.getInitParameter("password");
            serverUrl = config.getInitParameter("serverUrl");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {

        String code = (String) request.getParameter(SecureUtils.CODE);
        String key =  SecureUtils.CONSUMER_KEY;
        String secret =  SecureUtils.CONSUMER_SECRET;

        HttpSession session = request.getSession();
        System.out.println("code "+code+" key "+key+" secret "+secret);
        session.setAttribute(OAuth2Constants.CONSUMER_KEY, key);
        session.setAttribute(OAuth2Constants.CONSUMER_SECRET, secret);
        session.setAttribute(OAuth2Constants.OAUTH2_ACCESS_ENDPOINT, SecureUtils.REQ_TOK_ENDPOINT);
        session.setAttribute(OAuth2Constants.CODE, code);
        session.setAttribute(OAuth2Constants.OAUTH_CALLBACK, SecureUtils.OAUTH_CALLBACK);
        resp.sendRedirect("/edusecure/oauth2-get-access-token.jsp");
    }




    // @Override
    protected void doGetFails(HttpServletRequest request, HttpServletResponse resp) throws ServletException,

            IOException {

        System.out.println("OAuth2CallbackServlet do doGet");


        HttpSession session = request.getSession();

        OAuthAuthzResponse authzResponse = null;

/**

 * A OAuth credential for this application not user.

 */

        String consumerKey = SecureUtils.CONSUMER_KEY;

/**

 * A OAuth property for this application.

 */

        String tokenEndpoint = SecureUtils.REQ_TOK_ENDPOINT;

/**

 * A OAuth credential for this application not user.

 */

        String consumerSecret =  SecureUtils.CONSUMER_SECRET;

/**

 * A OAuth property for this application.

 */

        String callbackurl = SecureUtils.OAUTH_CALLBACK;

/**

 * A OAuth access for this application.

 */

        String accessToken = null;

/**

 * A OAuth token property for this application.

 */

        String idToken = null;

/**

 * A OAuth Authorization Code property for this application.

 */

        String code = null;

/**

 * obtain the response parameters

 */

        Enumeration parameterNames = request.getParameterNames();

        while (parameterNames.hasMoreElements()) {

            String name = (String) parameterNames.nextElement();

            System.out.println("parameterName: " + name);




        }

/**

 * Step through the OAuth2 flow schema, a series of requests. If the Authorization Code

 * exists in the session then we should have an access token, if not request an Authorization Code

 * and perform the OAUth flow to obtain an access token if the user has valid credential for the Wso2

 * server login. The key to understanding this flow is that the user logs in in, then the call back

 * server can request an access token.

 */

        try {

// authorization code

            code = (String) session.getAttribute(SecureUtils.OAUTH2_GRANT_TYPE_CODE);

            if (code == null) {

                authzResponse = OAuthAuthzResponse.oauthCodeAuthzResponse(request);

// line 234 login.html to oauth2­get­access­token.jsp

                code = authzResponse.getCode();

                System.out.println("state=" + authzResponse.getState());

                System.out.println("expires=" + authzResponse.getExpiresIn());

                System.out.println("accesstoken=" + authzResponse.getAccessToken());

                System.out.println("id_token=" +

                        authzResponse.getRequest().getParameter(SecureUtils.OAUTH_TOKEN));

                session.setAttribute(SecureUtils.OAUTH2_GRANT_TYPE_CODE, code);

            } else {

                accessToken = (String) session.getAttribute(SecureUtils.ACCESS_TOKEN);

            }

        } catch (Exception e) {

        }

// this code executes if we are using encrypted OAuth credentials

        try {


            System.out.println("OAuth2CallbackServlet debug String consumerSecret " + consumerSecret);

            System.out.println("OAuth2CallbackServlet debug String consumerKey " + consumerKey);

            System.out.println("OAuth2CallbackServlet debug String callbackurl " + callbackurl);

/**

 * Used by the The Wso2 server api client for authorisation requests.

 */

            OAuthClientRequest accessRequest = OAuthClientRequest.tokenLocation(tokenEndpoint)

                    .setGrantType(GrantType.AUTHORIZATION_CODE)

                    .setClientId(consumerKey)

                    .setClientSecret(consumerSecret)

                    .setRedirectURI(callbackurl)

                    .setCode(code)

                    .buildBodyMessage();

//create OAuth client that uses custom http client under the hood

            OAuthClient oAuthClient = new OAuthClient(new URLConnectionClient());

// make the call for the access token

            OAuthClientResponse oAuthResponse = oAuthClient.accessToken(accessRequest);

            accessToken = oAuthResponse.getParam(SecureUtils.ACCESS_TOKEN );

            idToken = oAuthResponse.getParam(SecureUtils.OAUTH_TOKEN);

            if (idToken != null) {

                System.out.println("Found id token");

                session.setAttribute(SecureUtils.OAUTH_TOKEN, idToken);

            }



// get the id token

            String id_token =

                    authzResponse.getRequest().getParameter(SecureUtils.OAUTH_TOKEN);




// store everything we have obtained from the Wso2 server in the session

        session.setAttribute(SecureUtils.OAUTH2_GRANT_TYPE_CODE, code);

        session.setAttribute(SecureUtils.ACCESS_TOKEN, accessToken);

        session.setAttribute(SecureUtils.OAUTH_TOKEN, idToken);

            System.out.println("OAuth2CallbackServlet doGet returns Authorization Code: " + code);

            System.out.println("OAuth2CallbackServlet doGet returns AccessToken: " + accessToken);

            System.out.println("OAuth2CallbackServlet doGet returns idToken: " + idToken);



        } catch (OAuthSystemException e) {

        e.printStackTrace();

             } catch (OAuthProblemException e) {

        e.printStackTrace();

            }

        System.out.println("OAuth2CallbackServlet doGet redirecting to login.html ");

        resp.sendRedirect("login.html");

}

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)

            throws ServletException, IOException {

        System.out.println("OAuth2CallbackServlet do post");

    }






}
