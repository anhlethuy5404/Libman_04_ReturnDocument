package com.library.libman.model;

import java.util.Date;


public class Librarian extends User {
    public Librarian(int id, String name, String username, String password, Date birthday, String address, String email, String phoneNumber, String role) {
        super(id, name, username, password, birthday, address, email, phoneNumber, "LIBRARIAN");
    }
    
    // Default constructor for DAO usage
    public Librarian() {
        super(0, "", "", "", null, "", "", "", "LIBRARIAN");
    }
}


