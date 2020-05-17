codeunit 69009 "Commission Base Profit" implements "Commission Calculation"
{
    procedure GetInvCommission(SalesInvoiceHeader: Record "Sales Invoice Header"): Decimal;
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        Salesperson: Record "Salesperson/Purchaser";
        BaseCommission: Decimal;
        CostAmount: decimal;
    begin
        if not Salesperson.get(SalesInvoiceHeader."Salesperson Code") then
            exit;
        with SalesInvoiceLine do begin
            SetRange("Document No.", SalesInvoiceHeader."No.");
            if not FindSet() then
                exit;
            repeat
                CostAmount := "Unit Cost" * Quantity;
                BaseCommission := BaseCommission + (Amount - CostAmount)
            until next = 0;
            exit(Round(BaseCommission * Salesperson."Commission %" / 100));
        end;
    end;

    procedure LookupCommission(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        with SalesInvoiceLine do begin
            SetRange("Document No.", SalesInvoiceHeader."No.");
            page.RunModal(0, SalesInvoiceLine);
        end;
    end;

}