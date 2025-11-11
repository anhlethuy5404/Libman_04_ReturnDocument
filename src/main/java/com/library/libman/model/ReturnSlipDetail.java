package com.library.libman.model;

import java.util.List;

public class ReturnSlipDetail {
    private int id;
    private float totalFineDetail;
    private ReturnSlip returnSlip;
    private BorrowSlipDetail borrowSlipDetail;
    private List<FineDetail> fineDetails;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public float getTotalFineDetail() { return totalFineDetail; }
    public void setTotalFineDetail(float totalFineDetail) { this.totalFineDetail = totalFineDetail; }
    public ReturnSlip getReturnSlip() { return returnSlip; }
    public void setReturnSlip(ReturnSlip returnSlip) { this.returnSlip = returnSlip; }
    public List<FineDetail> getFineDetails() { return fineDetails; }
    public void setFineDetails(List<FineDetail> fineDetails) { this.fineDetails = fineDetails; }
    public BorrowSlipDetail getBorrowSlipDetail() { return borrowSlipDetail; }
    public void setBorrowSlipDetail(BorrowSlipDetail borrowSlipDetail) { this.borrowSlipDetail = borrowSlipDetail; }    
}



