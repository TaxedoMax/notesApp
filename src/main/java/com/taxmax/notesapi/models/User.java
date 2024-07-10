package com.taxmax.notesapi.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Data;
import lombok.Setter;

import java.util.List;

@Data
@Table(name = "users")
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Setter(AccessLevel.PRIVATE)
    @Column(name = "user_id")
    private Long id;

    @Column(unique = true, nullable = false)
    private String login;

    private String password;

    @Column(name = "image_link")
    private String imageLink;

    @JsonIgnore
    @OneToMany(mappedBy = "owner", cascade = CascadeType.REMOVE)
    private List<Note> notes;
}
