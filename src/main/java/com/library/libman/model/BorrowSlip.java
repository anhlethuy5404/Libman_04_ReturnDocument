package com.library.libman.model;

import java.util.Date;

public class BorrowSlip {
    private int id;
    private Date borrowDate;
    private Date dueDate;
    private Reader reader;
    private Librarian librarian;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getBorrowDate() { return borrowDate; }
    public void setBorrowDate(Date borrowDate) { this.borrowDate = borrowDate; }
    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    public Reader getReader() { return reader; }
    public void setReader(Reader reader) { this.reader = reader; }
    public Librarian getLibrarian() { return librarian; }
    public void setLibrarian(Librarian librarian) { this.librarian = librarian; }
}