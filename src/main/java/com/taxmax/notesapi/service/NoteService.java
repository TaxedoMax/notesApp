package com.taxmax.notesapi.service;
import com.taxmax.notesapi.models.Note;

import java.util.List;

public interface NoteService {
    List<Note> findAllNotes();
    List<Note> findAllNotesByOwnerId(Long id) throws Exception;
    Note findNoteById(Long id);
    void saveNote(Note note);
    void removeNoteById(Long id);
}
