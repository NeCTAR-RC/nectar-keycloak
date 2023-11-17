/**
 * This mapper will read the federation and organisation attributes on a user
 * account, and output a token claim called 'attributes' with the values of
 * those attributes.
 *
 * Add it to a client by choosing:
 *   - Client Scopes
 *   - client dedicated scope
 *   - Add Mapper
 *   - By Configuration
 *   - Nectar User Attributes to Groups
 *
 * Go to Client, Client scopes, Evaluate to test.
 * My output for Generated user info shows:
 *  {
 *    "sub": "b6145b90-404d-4515-adb5-23f7d90eb4ec",
 *    "email_verified": true,
 *    "nectar_attributes": [
 *      "federation:aaf",
 *      "organisation:ardc.edu.au"
 *    ],
 *    "email": "andy.botting@ardc.edu.au"
 *  }
 *
 *
 * Available variables in this environment are: 
 *   user - the current user (UserModel)
 *     https://www.keycloak.org/docs-api/21.0.1/javadocs/org/keycloak/models/UserModel.html
 *   realm - the current realm (RealmModel)
 *     https://www.keycloak.org/docs-api/21.0.1/javadocs/org/keycloak/models/RealmModel.html
 *   token - the current token (TokenModel)
 *   userSession - the current userSession (UserSessionModel)
 *     https://www.keycloak.org/docs-api/21.0.1/javadocs/org/keycloak/models/UserSessionModel.html
 *   keycloakSession - the current keycloakSession (KeycloakSessionModel)
 *     https://www.keycloak.org/docs-api/21.0.1/javadocs/org/keycloak/models/KeycloakSession.html
 */

var attributes = [];

// Add all client roles for the user
var client = keycloakSession.getContext().getClient();
client.getRolesStream().forEach(function(roleModel) {
    if (user.hasRole(roleModel)) {
        attributes.push(roleModel.getName());
    }
});

// Add these given user attributes
var attrs = ['federation', 'organisation'];
for each (var k in attrs) {
    var v = user.getFirstAttribute(k);
    if (v) {
        var result = k + ":" + v;
        attributes.push(result);
    }
}

token.setOtherClaims("nectar_attributes", Java.to(attributes, "java.lang.String[]"))
