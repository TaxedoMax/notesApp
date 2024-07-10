package com.taxmax.notesapi.controller;

import com.taxmax.notesapi.models.Note;
import com.taxmax.notesapi.service.NoteService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/notes")
@AllArgsConstructor
public class NoteController {

    final NoteService service;

    @GetMapping("/all")
    List<Note> getAllNotes(){
        return service.findAllNotes();
    }
    @GetMapping("/note/{id}")
    Note getNoteById(@PathVariable Long id){
        return service.findNoteById(id);
    }

    @GetMapping("/all_by/{ownerId}")
    List<Note> getAllNotesByOwnerId(@PathVariable Long ownerId){
        try{
            return service.findAllNotesByOwnerId(ownerId);
        }
        catch (Exception e){
            return null;
        }
    }

    @PostMapping("/new")
    String saveNote(@RequestBody Note note){
        service.saveNote(note);
        return "Success";
    }

    @DeleteMapping("/delete/{id}")
    String deleteNote(@PathVariable Long id){
        service.removeNoteById(id);
        return "Success";
    }
}
