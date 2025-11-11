package com.library.libman.model;

import java.util.Date;
import java.util.List;

public class ReturnSlip {
    private int id;
    private Date returnDate;
    private float totalFine;
    private String status;
    private Librarian librarian;
    private Reader reader;
    private List<ReturnSlipDetail> returnSlipDetails;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }
    public float getTotalFine() { return totalFine; }
    public void setTotalFine(float totalFine) { this.totalFine = totalFine; }
    public Librarian getLibrarian() { return librarian; }
    public void setLibrarian(Librarian librarian) { this.librarian = librarian; }
    public Reader getReader() { return reader; }
    public void setReader(Reader reader) { this.reader = reader; }
    public List<ReturnSlipDetail> getReturnSlipDetails() { return returnSlipDetails; }
    public void setReturnSlipDetails(List<ReturnSlipDetail> returnSlipDetails) { this.returnSlipDetails = returnSlipDetails; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}



