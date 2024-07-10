package com.taxmax.notesapi.service.implementation;

import com.taxmax.notesapi.models.Note;
import com.taxmax.notesapi.models.User;
import com.taxmax.notesapi.repository.NoteRepository;
import com.taxmax.notesapi.repository.UserRepository;
import com.taxmax.notesapi.service.NoteService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class NoteServiceImpl implements NoteService {
    UserRepository userRepository;
    NoteRepository noteRepository;

    @Override
    public List<Note> findAllNotes() {
        return noteRepository.findAll();
    }

    @Override
    public List<Note> findAllNotesByOwnerId(Long id) throws Exception {
        Optional<User> owner = userRepository.findById(id);

        if(owner.isPresent()){
            return noteRepository.findAllByOwner(owner.get());
        }
        else{
            throw new Exception("Wrong id. User not found.");
        }
    }

    @Override
    public Note findNoteById(Long id) {
        return noteRepository.findById(id).get();
    }

    @Override
    public void saveNote(Note note) {
        noteRepository.save(note);
    }

    @Override
    public void removeNoteById(Long id) {
        noteRepository.deleteById(id);
    }
}
