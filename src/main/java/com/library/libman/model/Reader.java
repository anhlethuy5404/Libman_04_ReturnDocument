package com.library.libman.model;

import java.util.Date;


public class Reader extends User {
    private String readerCode;

    public String getReaderCode() { return readerCode; }
    public void setReaderCode(String readerCode) { this.readerCode = readerCode; }

    public Reader(int id, String name, String username, String password, Date birthday, String address, String email, String phoneNumber, String role, String readerCode) {
        super(id, name, username, password, birthday, address, email, phoneNumber, "READER");
        this.readerCode = readerCode;
    }
    
    public Reader() {
        super(0, "", "", "", null, "", "", "", "READER");
        this.readerCode = "";
    }
}


