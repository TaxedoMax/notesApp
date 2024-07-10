package com.taxmax.notesapi.service.implementation;

import com.taxmax.notesapi.models.User;
import com.taxmax.notesapi.repository.UserRepository;
import com.taxmax.notesapi.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@AllArgsConstructor
public class UserServiceImpl implements UserService {
    UserRepository repository;
    PasswordEncoder passwordEncoder;
    @Override
    public Long findUserIdByLogin(String login) throws Exception {
        Optional<User> user = repository.findUserByLogin(login);
        if(user.isPresent()){
            return user.get().getId();
        }
        else{
            throw new Exception("Login is incorrect. User not found");
        }
    }

    @Override
    public void saveUser(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        repository.save(user);
    }

    @Override
    public void updateUser(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        repository.save(user);
    }

    @Override
    public void deleteUserById(Long id) {
        repository.deleteById(id);
    }

    @Override
    public User getUserByLogin(String login) throws Exception {
        Optional<User> user = repository.findUserByLogin(login);
        if(user.isPresent()){
            return user.get();
        }
        else{
            throw new Exception("Login is incorrect. User not found");
        }
    }
}
