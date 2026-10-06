export type Platform = 'Shopee' | 'Lazada' | 'TikTok Shop';

export type Courier = 'SPX Express' | 'Lazada Express' | 'J&T Express' | 'Flash Express' | 'Ninja Van';

export type ParcelStatus = 'Dispatched' | 'In Transit' | 'Delivered' | 'Return Logged';

export type DateFilterOption = 'all' | 'today' | 'last_week' | 'last_month' | 'custom';

export interface Parcel {
  id: string;
  trackingNumber: string;
  platform: Platform;
  courier: Courier;
  customer: string;
  phone?: string;
  destination?: string;
  amount: string;
  rawAmount: number;
  status: ParcelStatus;
  statusColor: string;
  dispatchedAt: string;
  dateISO: string;
  items?: string;
}

export type ReturnCondition = 'Intact (Resellable)' | 'Damaged Packaging' | 'Item Damaged' | 'Total Loss / Liquid';

export type RefundStatus = 'Pending Inspection' | 'Approved for Refund' | 'Disputed with Platform' | 'Refund Completed';

export interface ReturnRecord {
  id: string;
  trackingNumber: string;
  platform: Platform;
  courier: Courier;
  customer: string;
  reason: string;
  condition: ReturnCondition;
  refundStatus: RefundStatus;
  loggedAt: string;
  evidencePhoto?: string;
  notes?: string;
  refundAmount: string;
}
