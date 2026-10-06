import React, { useState } from 'react';
import { ReturnRecord, ReturnCondition, RefundStatus, Platform, Courier } from '../types';
import { RotateCcw, AlertTriangle, Plus, CheckCircle, Camera, ShieldAlert, ArrowLeft } from 'lucide-react';

interface ReturnsScreenProps {
  returns: ReturnRecord[];
  onAddReturn: (record: ReturnRecord) => void;
}

export const ReturnsScreen: React.FC<ReturnsScreenProps> = ({
  returns,
  onAddReturn,
}) => {
  const [showLogModal, setShowLogModal] = useState(false);
  const [trackingNumber, setTrackingNumber] = useState('');
  const [platform, setPlatform] = useState<Platform>('Shopee');
  const [courier, setCourier] = useState<Courier>('Flash Express');
  const [customer, setCustomer] = useState('');
  const [reason, setReason] = useState('RTS: Customer Unreachable / Refused');
  const [condition, setCondition] = useState<ReturnCondition>('Intact (Resellable)');
  const [refundStatus, setRefundStatus] = useState<RefundStatus>('Pending Inspection');
  const [refundAmount, setRefundAmount] = useState('₱1,200.00');
  const [notes, setNotes] = useState('');
  const [hasPhoto, setHasPhoto] = useState(true);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!trackingNumber.trim() || !customer.trim()) return;

    const newRecord: ReturnRecord = {
      id: `ret-${Date.now()}`,
      trackingNumber: trackingNumber.trim().toUpperCase(),
      platform,
      courier,
      customer: customer.trim(),
      reason,
      condition,
      refundStatus,
      loggedAt: 'Just now',
      notes: notes.trim() || 'Logged via Mobile Returns Module.',
      refundAmount: refundAmount.startsWith('₱') ? refundAmount : `₱${refundAmount}`,
      evidencePhoto: hasPhoto ? 'tamper_seal_inspected.jpg' : undefined,
    };

    onAddReturn(newRecord);
    setShowLogModal(false);
    setTrackingNumber('');
    setCustomer('');
    setNotes('');
  };

  const getConditionColor = (cond: ReturnCondition) => {
    switch (cond) {
      case 'Intact (Resellable)':
        return 'bg-emerald-50 text-emerald-700 border-emerald-200';
      case 'Damaged Packaging':
        return 'bg-amber-50 text-amber-700 border-amber-200';
      case 'Item Damaged':
      case 'Total Loss / Liquid':
        return 'bg-rose-50 text-rose-700 border-rose-200';
      default:
        return 'bg-slate-50 text-slate-700 border-slate-200';
    }
  };

  return (
    <div className="flex flex-col px-4 pt-3 pb-24 max-w-md mx-auto w-full">
      {/* Module 5 Android Header */}
      <div className="flex flex-col items-center text-center py-2">
        <div className="w-12 h-12 rounded-2xl bg-rose-50 flex items-center justify-center text-[#EF4444] shadow-inner">
          <RotateCcw className="w-6 h-6 text-[#EF4444]" />
        </div>
        <h2 className="text-base font-bold text-[#0F172A] mt-2">
          Returns & Refunds Logger
        </h2>
        <p className="text-xs text-slate-500 mt-1 max-w-xs leading-relaxed">
          Log returned parcels with condition assessment, photo evidence, and refund resolution tracking.
        </p>
      </div>

      {/* Action Bar */}
      <div className="flex items-center justify-between mt-3 mb-2">
        <div>
          <span className="text-xs font-bold text-[#0F172A]">
            Logged Return Records
          </span>
          <span className="text-[11px] text-slate-400 ml-1.5">
            ({returns.length} parcels)
          </span>
        </div>
        <button
          onClick={() => setShowLogModal(true)}
          className="flex items-center gap-1.5 bg-[#EF4444] hover:bg-rose-600 text-white text-xs font-bold px-3 py-1.5 rounded-xl shadow-xs transition-colors"
        >
          <Plus className="w-3.5 h-3.5" />
          <span>Log Return</span>
        </button>
      </div>

      {/* Returns List */}
      <div className="flex flex-col gap-2.5">
        {returns.map((item) => (
          <div
            key={item.id}
            className="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm"
          >
            <div className="flex items-center justify-between">
              <span className="text-[13px] font-bold text-[#0F172A] font-mono">
                {item.trackingNumber}
              </span>
              <span className="text-[11px] font-semibold text-rose-600 bg-rose-50 border border-rose-100 px-2 py-0.5 rounded-full">
                {item.refundStatus}
              </span>
            </div>

            <div className="mt-2 text-xs">
              <div className="font-semibold text-slate-800">
                {item.customer} <span className="font-normal text-slate-400">({item.platform} • {item.courier})</span>
              </div>
              <div className="text-slate-600 mt-0.5">
                <span className="font-medium text-slate-500">Reason: </span>
                {item.reason}
              </div>
            </div>

            <div className="flex flex-wrap items-center gap-1.5 mt-2.5 pt-2 border-t border-slate-100">
              <span
                className={`text-[10px] font-bold px-2 py-0.5 rounded-md border ${getConditionColor(
                  item.condition
                )}`}
              >
                {item.condition}
              </span>
              <span className="text-[10px] text-slate-500 ml-auto font-medium">
                {item.loggedAt}
              </span>
            </div>

            {item.notes && (
              <p className="mt-2 text-[11px] text-slate-500 bg-slate-50 p-2 rounded-lg italic">
                "{item.notes}"
              </p>
            )}
          </div>
        ))}
      </div>

      {/* Log Return Modal */}
      {showLogModal && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-fade-in">
          <div className="bg-white rounded-2xl max-w-sm w-full p-4 max-h-[90vh] overflow-y-auto shadow-2xl">
            <div className="flex items-center justify-between pb-2 border-b border-slate-100">
              <h3 className="text-sm font-bold text-[#0F172A]">
                Log Returned Parcel
              </h3>
              <button
                onClick={() => setShowLogModal(false)}
                className="text-xs text-slate-400 hover:text-slate-600 font-bold"
              >
                Cancel
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-3 flex flex-col gap-3 text-xs">
              <div>
                <label className="block font-semibold text-slate-700 mb-1">
                  Airway Bill / Tracking #
                </label>
                <input
                  type="text"
                  required
                  value={trackingNumber}
                  onChange={(e) => setTrackingNumber(e.target.value)}
                  placeholder="e.g. LBC88301928"
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl font-mono focus:outline-none focus:ring-2 focus:ring-rose-400"
                />
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block font-semibold text-slate-700 mb-1">
                    Platform
                  </label>
                  <select
                    value={platform}
                    onChange={(e) => setPlatform(e.target.value as Platform)}
                    className="w-full px-2.5 py-2 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-rose-400"
                  >
                    <option value="Shopee">Shopee</option>
                    <option value="Lazada">Lazada</option>
                    <option value="TikTok Shop">TikTok Shop</option>
                  </select>
                </div>
                <div>
                  <label className="block font-semibold text-slate-700 mb-1">
                    Courier
                  </label>
                  <select
                    value={courier}
                    onChange={(e) => setCourier(e.target.value as Courier)}
                    className="w-full px-2.5 py-2 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-rose-400"
                  >
                    <option value="Flash Express">Flash Express</option>
                    <option value="SPX Express">SPX Express</option>
                    <option value="Lazada Express">Lazada Express</option>
                    <option value="J&T Express">J&T Express</option>
                    <option value="Ninja Van">Ninja Van</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">
                  Customer / Buyer Name
                </label>
                <input
                  type="text"
                  required
                  value={customer}
                  onChange={(e) => setCustomer(e.target.value)}
                  placeholder="e.g. Roberto Tan"
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-rose-400"
                />
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">
                  Return Assessment Condition
                </label>
                <select
                  value={condition}
                  onChange={(e) => setCondition(e.target.value as ReturnCondition)}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-rose-400"
                >
                  <option value="Intact (Resellable)">Intact (Resellable - Tamper Seal OK)</option>
                  <option value="Damaged Packaging">Damaged Packaging (Needs Rebox)</option>
                  <option value="Item Damaged">Item Damaged (Dispute Courier)</option>
                  <option value="Total Loss / Liquid">Total Loss / Liquid Damage</option>
                </select>
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">
                  Refund Resolution Status
                </label>
                <select
                  value={refundStatus}
                  onChange={(e) => setRefundStatus(e.target.value as RefundStatus)}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-rose-400"
                >
                  <option value="Pending Inspection">Pending Inspection</option>
                  <option value="Approved for Refund">Approved for Refund</option>
                  <option value="Disputed with Platform">Disputed with Platform</option>
                  <option value="Refund Completed">Refund Completed</option>
                </select>
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">
                  Assessment Evidence & Photos
                </label>
                <div className="flex items-center gap-2 p-2.5 border border-dashed border-slate-300 rounded-xl bg-slate-50">
                  <Camera className="w-5 h-5 text-slate-400" />
                  <span className="text-[11px] text-slate-500 font-medium">
                    Tamper seal & barcode captured
                  </span>
                  <span className="ml-auto text-[10px] bg-emerald-100 text-emerald-700 px-1.5 py-0.5 rounded font-bold">
                    Attached
                  </span>
                </div>
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">
                  Inspection Notes
                </label>
                <textarea
                  rows={2}
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  placeholder="Notes regarding parcel condition..."
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-rose-400"
                />
              </div>

              <button
                type="submit"
                className="w-full mt-2 py-2.5 bg-[#EF4444] hover:bg-rose-600 text-white font-bold rounded-xl shadow-sm transition-colors"
              >
                Save Return Record
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
