package com.taxmax.notesapi.service;
import com.taxmax.notesapi.models.User;
public interface UserService {
    Long findUserIdByLogin(String login) throws Exception;
    void saveUser(User user);
    void updateUser(User user);
    void deleteUserById(Long id);
    User getUserByLogin(String login) throws Exception;
}
