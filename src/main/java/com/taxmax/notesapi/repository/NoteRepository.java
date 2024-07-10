package com.taxmax.notesapi.repository;

import com.taxmax.notesapi.models.Note;
import com.taxmax.notesapi.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NoteRepository extends JpaRepository<Note, Long> {
    List<Note> findAllByOwner(User owner);
}
