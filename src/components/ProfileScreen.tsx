import React from 'react';
import { User, Shield, KeyRound, CheckCircle2, Lock, Building2, RefreshCw } from 'lucide-react';

interface ProfileScreenProps {
  userRole: string;
  setUserRole: (role: string) => void;
}

export const ProfileScreen: React.FC<ProfileScreenProps> = ({
  userRole,
  setUserRole,
}) => {
  return (
    <div className="flex flex-col px-4 pt-3 pb-24 max-w-md mx-auto w-full">
      {/* Module 2 Android Header */}
      <div className="flex flex-col items-center text-center py-2">
        <div className="w-12 h-12 rounded-2xl bg-slate-100 flex items-center justify-center text-[#1E293B] shadow-inner">
          <User className="w-6 h-6 text-[#1E293B]" />
        </div>
        <h2 className="text-base font-bold text-[#0F172A] mt-2">
          User Profile & Security
        </h2>
        <p className="text-xs text-slate-500 mt-1 max-w-xs leading-relaxed">
          Google Sign-In, RA 10173 Data Privacy consent, and real-time Firestore Role syncing.
        </p>
      </div>

      {/* Account Info Card */}
      <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm mt-3">
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-full bg-gradient-to-tr from-slate-900 to-sky-600 flex items-center justify-center text-white font-bold text-base shadow-sm">
            GJ
          </div>
          <div>
            <div className="text-sm font-bold text-[#0F172A]">
              GJ & Asher Logistics Hub
            </div>
            <div className="text-xs text-slate-500 font-mono">
              gj8506@gmail.com
            </div>
            <div className="flex items-center gap-1.5 mt-1">
              <span className="w-2 h-2 rounded-full bg-emerald-500" />
              <span className="text-[10px] font-semibold text-emerald-700">
                Google Auth Verified
              </span>
            </div>
          </div>
        </div>

        {/* Role Toggle Switcher */}
        <div className="mt-4 pt-3 border-t border-slate-100">
          <label className="block text-xs font-semibold text-slate-700 mb-1.5">
            Active System Role (Firestore Synced)
          </label>
          <div className="grid grid-cols-2 gap-2">
            {(['Staff Mode', 'Admin Mode'] as const).map((role) => (
              <button
                key={role}
                onClick={() => setUserRole(role)}
                className={`py-2 px-3 rounded-xl text-xs font-bold transition-all border ${
                  userRole === role
                    ? 'bg-[#0F172A] text-white border-[#0F172A] shadow-sm'
                    : 'bg-white text-slate-600 border-slate-200 hover:bg-slate-50'
                }`}
              >
                {role}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* RA 10173 Philippine Data Privacy Act Card */}
      <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm mt-3">
        <div className="flex items-start gap-2.5">
          <div className="p-1.5 bg-sky-50 text-[#0EA5E9] rounded-lg mt-0.5">
            <Shield className="w-4 h-4" />
          </div>
          <div>
            <h3 className="text-xs font-bold text-[#0F172A]">
              Republic Act No. 10173 (Data Privacy Act)
            </h3>
            <p className="text-[11px] text-slate-500 mt-1 leading-relaxed">
              Customer Personally Identifiable Information (PII) including phone numbers and delivery addresses are masked in transit logs according to NPC circular compliance.
            </p>
          </div>
        </div>

        <div className="mt-3 flex items-center justify-between bg-slate-50 p-2.5 rounded-xl border border-slate-100">
          <span className="text-[11px] font-medium text-slate-600">
            DPA Consent Status:
          </span>
          <span className="text-[10px] font-bold text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded-md flex items-center gap-1">
            <CheckCircle2 className="w-3 h-3" />
            Acknowledged & Signed
          </span>
        </div>
      </div>

      {/* Logistics Hub Terminal Info */}
      <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm mt-3">
        <h3 className="text-xs font-bold text-[#0F172A] mb-2">
          Warehouse Terminal Configuration
        </h3>
        <div className="space-y-2 text-xs">
          <div className="flex justify-between py-1 border-b border-slate-100">
            <span className="text-slate-500">Facility Code</span>
            <span className="font-mono font-semibold text-slate-800">MNL-HUB-04</span>
          </div>
          <div className="flex justify-between py-1 border-b border-slate-100">
            <span className="text-slate-500">Supported Marketplaces</span>
            <span className="font-semibold text-slate-800">Shopee • Lazada • TikTok</span>
          </div>
          <div className="flex justify-between py-1 border-b border-slate-100">
            <span className="text-slate-500">Default Courier Routing</span>
            <span className="font-semibold text-slate-800">SPX / J&T / LEX Priority</span>
          </div>
          <div className="flex justify-between py-1">
            <span className="text-slate-500">Applet Version</span>
            <span className="font-mono text-slate-800 font-semibold">v2.0 (React Web)</span>
          </div>
        </div>
      </div>
    </div>
  );
};
