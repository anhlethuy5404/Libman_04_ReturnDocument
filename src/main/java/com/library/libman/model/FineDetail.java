package com.library.libman.model;

public class FineDetail {
    private int id;
    private Fine fine;
    private ReturnSlipDetail returnSlipDetail;
    private int quantity;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Fine getFine() { return fine; }
    public void setFine(Fine fine) { this.fine = fine; }
    public ReturnSlipDetail getReturnSlipDetail() { return returnSlipDetail; }
    public void setReturnSlipDetail(ReturnSlipDetail returnSlipDetail) { this.returnSlipDetail = returnSlipDetail; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}



