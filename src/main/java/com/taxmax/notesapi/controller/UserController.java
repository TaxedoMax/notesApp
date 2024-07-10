package com.taxmax.notesapi.controller;

import com.sun.net.httpserver.Authenticator;
import com.taxmax.notesapi.models.User;
import com.taxmax.notesapi.service.UserService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
@AllArgsConstructor
public class UserController {
    private final UserService service;

    @PostMapping("/reg")
    String saveUser(@RequestBody User user, HttpServletResponse response){
        try{
            service.saveUser(user);
            response.setStatus(200);
            return "Success";
        }
        catch(Exception exception){
            response.setStatus(409);
            return "Failed";
        }
    }

    @PutMapping("/update")
    String updateUser(@RequestBody User user){
        try{
            service.saveUser(user);
            return "Success";
        }
        catch(Exception exception){
            return exception.toString();
        }
    }

    @GetMapping("/user_id/{login}")
    Long getUserId(@PathVariable String login) {
        try {
            return service.findUserIdByLogin(login);
        } catch (Exception exception) {
            if (exception.getMessage() == "Login is incorrect. User not found") {
                return -1L;
            }
            else return -2L;
        }
    }

    @GetMapping("/check_auth")
    boolean checkAuth(HttpServletResponse response){
        response.setStatus(200);
        return true;
    }

    @GetMapping("/user/{login}")
    User getUserByLogin(@PathVariable String login, HttpServletResponse response){
        try {
            response.setStatus(200);
            return service.getUserByLogin(login);
        } catch (Exception exception) {
            if (exception.getMessage() == "Login is incorrect. User not found") {
                response.setStatus(404);
                return null;
            }
            else{
                response.setStatus(400);
                return null;
            }
        }
    }

    @DeleteMapping("/delete/{id}")
    String removeUser(@PathVariable Long id){
        service.deleteUserById(id);
        return "Success";
    }
}
