import React from 'react';
import { Parcel } from '../types';
import { X, Package, MapPin, Phone, Calendar, CheckCircle2, Truck, QrCode } from 'lucide-react';

interface ParcelDetailModalProps {
  parcel: Parcel | null;
  onClose: () => void;
}

export const ParcelDetailModal: React.FC<ParcelDetailModalProps> = ({
  parcel,
  onClose,
}) => {
  if (!parcel) return null;

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-fade-in">
      <div className="bg-white rounded-3xl max-w-sm w-full p-5 shadow-2xl border border-slate-100 max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="flex items-center justify-between pb-3 border-b border-slate-100">
          <div>
            <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
              Parcel Details
            </span>
            <div className="text-base font-bold text-[#0F172A] font-mono">
              {parcel.trackingNumber}
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-full hover:bg-slate-100 text-slate-400 hover:text-slate-600 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Status Badge */}
        <div className="my-3 flex items-center justify-between bg-slate-50 p-3 rounded-2xl">
          <div className="flex items-center gap-2">
            <div
              className="w-3 h-3 rounded-full"
              style={{ backgroundColor: parcel.statusColor }}
            />
            <span className="text-xs font-bold text-slate-800">
              {parcel.status}
            </span>
          </div>
          <span className="text-xs font-extrabold text-[#0F172A]">
            {parcel.amount}
          </span>
        </div>

        {/* Info Grid */}
        <div className="space-y-3 text-xs">
          <div>
            <span className="text-slate-400 font-medium">Platform & Courier</span>
            <div className="font-semibold text-slate-800 mt-0.5">
              {parcel.platform} • {parcel.courier}
            </div>
          </div>

          <div>
            <span className="text-slate-400 font-medium">Customer Recipient</span>
            <div className="font-semibold text-slate-800 mt-0.5">
              {parcel.customer}
            </div>
            {parcel.phone && (
              <div className="text-slate-500 text-[11px] font-mono mt-0.5 flex items-center gap-1">
                <Phone className="w-3 h-3" />
                {parcel.phone}
              </div>
            )}
          </div>

          <div>
            <span className="text-slate-400 font-medium">Delivery Address</span>
            <div className="font-medium text-slate-700 mt-0.5 flex items-start gap-1">
              <MapPin className="w-3.5 h-3.5 text-slate-400 mt-0.5 shrink-0" />
              <span>{parcel.destination || 'Metro Manila Dispatch Hub'}</span>
            </div>
          </div>

          {parcel.items && (
            <div>
              <span className="text-slate-400 font-medium">Package Contents</span>
              <div className="bg-slate-50 p-2.5 rounded-xl font-medium text-slate-700 text-[11px] mt-1 border border-slate-100">
                {parcel.items}
              </div>
            </div>
          )}

          {/* Simulated Waybill Barcode */}
          <div className="pt-2 text-center">
            <div className="inline-block p-2 bg-slate-50 rounded-xl border border-slate-200">
              <div className="font-mono text-[10px] text-slate-400 mb-1">
                Digital Airway Bill Barcode
              </div>
              <div className="h-10 flex items-center justify-center gap-[2px] bg-white px-3 py-1 rounded border border-slate-200">
                {Array.from({ length: 32 }).map((_, i) => (
                  <div
                    key={i}
                    className={`bg-slate-900 h-full ${
                      i % 3 === 0 ? 'w-1' : i % 2 === 0 ? 'w-[1.5px]' : 'w-[0.5px]'
                    }`}
                  />
                ))}
              </div>
              <div className="font-mono text-[10px] font-bold text-slate-700 mt-1">
                *{parcel.trackingNumber}*
              </div>
            </div>
          </div>
        </div>

        {/* Close Button */}
        <button
          onClick={onClose}
          className="w-full mt-4 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-800 text-xs font-bold rounded-xl transition-colors"
        >
          Close
        </button>
      </div>
    </div>
  );
};
