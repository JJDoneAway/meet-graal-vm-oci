package de.magicinside.meetgraalvm.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SecureHelloController {

    @RequestMapping(method = RequestMethod.GET, path = "/secure/hello")
    ResponseEntity<Jwt> sayHello(@AuthenticationPrincipal Jwt jwt) {
        return ResponseEntity.ok(jwt);
    }

    @RequestMapping(method = RequestMethod.GET, path = "/secure/user")
    ResponseEntity<String> sayUser(@AuthenticationPrincipal Jwt jwt) {
        return ResponseEntity.ok(jwt.getClaimAsString("ca_name"));
    }
}
