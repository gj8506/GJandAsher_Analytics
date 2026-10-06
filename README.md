# GJandAsher ShipTracker (React Web)

A Mobile Outbound Logistics, Analytics, and Returns Manager for Shopee, Lazada, and TikTok Shop. Rewritten from Android Jetpack Compose to React + TypeScript + Vite + Tailwind CSS.

## Features Ported

1. **Parcels Dashboard (Module 1 & 4)**
   - Outbound logistics hub monitoring dispatches across Shopee, Lazada, and TikTok Shop.
   - Platform summary package chips with original brand palettes (Shopee Orange, Lazada Blue, TikTok Black).
   - Real-time parcel cards showing tracking numbers, courier partners (SPX Express, Lazada Express, J&T Express, Flash Express), recipient, amounts, and statuses (Dispatched, In Transit, Delivered, Return Logged).
   - Filter by marketplace and dispatch status, interactive search, and parcel airway bill details modal with digital barcode preview.

2. **Manual Dispatch Form (Module 3)**
   - Fast courier entry with dynamic courier partner matching by platform.
   - Auto-fill waybill generator simulating customer and destination routing.
   - Dispatch submission logging parcels directly into outbound manifests.

3. **Returns & Refunds Logger (Module 5)**
   - Log returned parcels with condition assessment: Intact (Resellable), Damaged Packaging, Item Damaged, or Total Loss.
   - Refund resolution tracking: Pending Inspection, Approved for Refund, Disputed with Platform, Refund Completed.
   - Photographic evidence verification and inspector notes.

4. **Admin Visual Analytics & Predictive Forecasting (Modules 6 & 7)**
   - Role-guarded dashboard with KPI cards: Outbound GMV, Delivery Success Rate, and Return / RTS rate.
   - Multi-platform volume share distribution and daily dispatch trends across 7d/30d/90d intervals.
   - 1–12 Month predictive forecasting engine with monthly growth algorithms and peak mega-sale multipliers.

5. **User Profile & Security (Module 2)**
   - Google account authentication status and active role switching (Staff Mode / Admin Mode).
   - Republic Act No. 10173 (Philippine Data Privacy Act) compliance with masked customer PII.
   - Warehouse terminal facility configuration (MNL-HUB-04).

## Running the Application

- **Development**: `npm run dev` (runs on `http://0.0.0.0:3000`)
- **Production Build**: `npm run build`
