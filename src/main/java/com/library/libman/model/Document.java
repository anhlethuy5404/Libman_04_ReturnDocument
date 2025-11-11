package com.library.libman.model;

import java.util.Date;

public class Document {
    private int id;
    private String title;
    private String type;
    private String author;
    private Date publishedYear;
    private float price;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public Date getPublishedYear() { return publishedYear; }
    public void setPublishedYear(Date publishedYear) { this.publishedYear = publishedYear; }
    public float getPrice() { return price; }
    public void setPrice(float price) { this.price = price; }
}


