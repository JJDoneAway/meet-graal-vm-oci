package de.magicinside.meetgraalvm.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @RequestMapping(method = RequestMethod.GET, path = "/public/hello")
    ResponseEntity<String> sayHello() {
        return ResponseEntity.ok("Public Endpoint: Hello, GraalVM!");
    }
}
