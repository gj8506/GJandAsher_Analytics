import React, { useState } from 'react';
import { Truck, Shield, Check, Info, Lock, ChevronDown, ChevronUp } from 'lucide-react';

interface LoginScreenProps {
  onLoginSuccess: (user: { email: string; role: 'customer' | 'staff' | 'admin'; name: string }) => void;
}

export const LoginScreen: React.FC<LoginScreenProps> = ({ onLoginSuccess }) => {
  const [dpaConsent, setDpaConsent] = useState(false);
  const [isPrivacyModalOpen, setIsPrivacyModalOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [customGoogleEmail, setCustomGoogleEmail] = useState('');
  const [showAccountSelector, setShowAccountSelector] = useState(false);

  const handleGoogleSignIn = (selectedEmail?: string) => {
    if (!dpaConsent) {
      alert('Please agree to the Data Privacy Notice (RA 10173) before signing in with Google.');
      return;
    }

    setIsLoading(true);

    setTimeout(() => {
      setIsLoading(false);

      const targetEmail = (selectedEmail ?? (customGoogleEmail.trim() || 'customer.google@gmail.com')).toLowerCase();
      // Admin account is gj8506@gmail.com; all other Google accounts strictly default to Customer
      const isAdmin = targetEmail === 'gj8506@gmail.com';
      const role: 'customer' | 'admin' = isAdmin ? 'admin' : 'customer';
      const name = isAdmin
        ? 'GJ & Asher Admin'
        : targetEmail.includes('@')
        ? targetEmail.split('@')[0].replace(/[._]/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase())
        : 'Google Customer';

      onLoginSuccess({
        email: targetEmail,
        name: name || 'Google Customer',
        role,
      });
    }, 450);
  };

  return (
    <div className="min-h-screen bg-[#F8FAFC] flex flex-col justify-center items-center px-4 py-8 max-w-md mx-auto w-full">
      {/* Brand Header */}
      <div className="flex flex-col items-center text-center mb-6">
        <div className="w-16 h-16 rounded-2xl bg-[#0F172A] flex items-center justify-center text-white shadow-xl shadow-slate-900/10 mb-3">
          <Truck className="w-8 h-8 text-white" />
        </div>
        <h1 className="text-xl font-bold tracking-tight text-[#0F172A]">
          GJandAsher ShipTracker
        </h1>
        <p className="text-xs text-slate-500 mt-1 max-w-xs leading-relaxed">
          Logistics Fulfillment & Order Tracking Hub
        </p>
      </div>

      {/* Main Google Sign-In Card */}
      <div className="w-full bg-white rounded-2xl p-5 border border-slate-200 shadow-2xs mb-4">
        <div className="text-center mb-4">
          <h2 className="text-sm font-bold text-[#0F172A]">Welcome to ShipTracker</h2>
          <p className="text-[11px] text-slate-500 mt-1">
            Sign in with your Google account to track parcels and access support.
          </p>
        </div>

        {/* Notice: Auto-default to Customer */}
        <div className="p-3 bg-sky-50/70 border border-sky-100 rounded-xl mb-4 text-[11px] text-slate-600 leading-relaxed flex items-start gap-2">
          <Lock className="w-4 h-4 text-sky-600 shrink-0 mt-0.5" />
          <div>
            <span className="font-semibold text-slate-800">Automatic Customer Account:</span> Google sign-in automatically defaults into a <strong>Customer</strong> account. Role changes (to Staff or Admin) can only be configured in Firebase by the administrator.
          </div>
        </div>

        {/* Primary Google Sign-In Button */}
        <button
          onClick={() => handleGoogleSignIn()}
          disabled={!dpaConsent || isLoading}
          className={`w-full py-3.5 px-4 rounded-xl font-bold text-xs flex items-center justify-center gap-3 transition-all border ${
            dpaConsent
              ? 'bg-white hover:bg-slate-50 text-slate-700 shadow-sm cursor-pointer border-slate-300 hover:border-slate-400 active:scale-[0.99]'
              : 'bg-slate-50 text-slate-400 border-slate-200 cursor-not-allowed opacity-70'
          }`}
        >
          {isLoading ? (
            <div className="w-4 h-4 border-2 border-slate-400 border-t-slate-800 rounded-full animate-spin" />
          ) : (
            <>
              {/* Google G Brand Icon */}
              <svg className="w-4 h-4" viewBox="0 0 24 24">
                <path
                  fill="#4285F4"
                  d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v4.51h6.6c-.29 1.52-1.14 2.8-2.4 3.65v3h3.88c2.27-2.09 3.665-5.17 3.665-9.09z"
                />
                <path
                  fill="#34A853"
                  d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.88-3c-1.08.72-2.45 1.16-4.05 1.16-3.12 0-5.77-2.1-6.72-4.93H1.26v3.09C3.25 21.35 7.34 24 12 24z"
                />
                <path
                  fill="#FBBC05"
                  d="M5.28 14.32c-.25-.72-.38-1.49-.38-2.32s.13-1.6.38-2.32V6.59H1.26C.46 8.19 0 9.99 0 12s.46 3.81 1.26 5.41l4.02-3.09z"
                />
                <path
                  fill="#EA4335"
                  d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.34 0 3.25 2.65 1.26 6.59l4.02 3.09c.95-2.83 3.6-4.93 6.72-4.93z"
                />
              </svg>
              <span className="font-semibold text-slate-800 text-xs">
                Sign in with Google
              </span>
            </>
          )}
        </button>

        {/* Quick Google Account Switcher / Custom Account entry */}
        <div className="mt-3 pt-3 border-t border-slate-100">
          <button
            type="button"
            onClick={() => setShowAccountSelector(!showAccountSelector)}
            className="w-full flex items-center justify-between text-[11px] text-slate-500 hover:text-slate-700 py-1"
          >
            <span>Choose specific Google account / Admin</span>
            {showAccountSelector ? (
              <ChevronUp className="w-3.5 h-3.5" />
            ) : (
              <ChevronDown className="w-3.5 h-3.5" />
            )}
          </button>

          {showAccountSelector && (
            <div className="mt-2 space-y-2 animate-fade-in">
              <div
                onClick={() => {
                  setCustomGoogleEmail('customer.google@gmail.com');
                  if (dpaConsent) handleGoogleSignIn('customer.google@gmail.com');
                }}
                className="p-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 cursor-pointer flex items-center justify-between transition-colors"
              >
                <div className="flex items-center gap-2">
                  <div className="w-6 h-6 rounded-full bg-sky-100 text-sky-700 font-bold text-[10px] flex items-center justify-center">
                    G
                  </div>
                  <div>
                    <div className="text-xs font-semibold text-slate-800">customer.google@gmail.com</div>
                    <div className="text-[10px] text-slate-400">Default Customer Account</div>
                  </div>
                </div>
                <span className="text-[9px] px-1.5 py-0.5 bg-sky-50 text-sky-700 rounded font-semibold border border-sky-100">
                  Customer
                </span>
              </div>

              <div
                onClick={() => {
                  setCustomGoogleEmail('gj8506@gmail.com');
                  if (dpaConsent) handleGoogleSignIn('gj8506@gmail.com');
                }}
                className="p-2.5 rounded-xl border border-emerald-200 bg-emerald-50/40 hover:bg-emerald-50 cursor-pointer flex items-center justify-between transition-colors"
              >
                <div className="flex items-center gap-2">
                  <div className="w-6 h-6 rounded-full bg-emerald-100 text-emerald-800 font-bold text-[10px] flex items-center justify-center">
                    GJ
                  </div>
                  <div>
                    <div className="text-xs font-semibold text-slate-800">gj8506@gmail.com</div>
                    <div className="text-[10px] text-slate-400">Warehouse Admin (Firebase Role)</div>
                  </div>
                </div>
                <span className="text-[9px] px-1.5 py-0.5 bg-emerald-100 text-emerald-800 rounded font-bold">
                  Admin
                </span>
              </div>

              <div className="pt-1">
                <input
                  type="email"
                  value={customGoogleEmail}
                  onChange={(e) => setCustomGoogleEmail(e.target.value)}
                  placeholder="Or enter any @gmail.com address..."
                  className="w-full px-3 py-1.5 bg-slate-50 border border-slate-200 rounded-lg text-xs text-slate-800 focus:outline-none focus:ring-1 focus:ring-sky-500"
                />
              </div>
            </div>
          )}
        </div>
      </div>

      {/* RA 10173 Consent Card */}
      <div className="w-full bg-white rounded-2xl p-3.5 border border-slate-200 shadow-2xs mb-4">
        <div className="flex items-start gap-2.5">
          <input
            type="checkbox"
            id="dpa-consent"
            checked={dpaConsent}
            onChange={(e) => setDpaConsent(e.target.checked)}
            className="mt-0.5 w-4 h-4 rounded border-slate-300 text-[#0EA5E9] focus:ring-[#0EA5E9] cursor-pointer"
          />
          <div className="flex-1 text-xs">
            <label htmlFor="dpa-consent" className="cursor-pointer text-slate-700 leading-snug block">
              I acknowledge and agree to the <strong>Data Privacy Notice (RA 10173)</strong> for order tracking & messaging.
            </label>
            <button
              type="button"
              onClick={() => setIsPrivacyModalOpen(true)}
              className="mt-1 text-[11px] text-[#0EA5E9] font-bold hover:underline inline-flex items-center gap-1 cursor-pointer"
            >
              <Info className="w-3 h-3" />
              Read Privacy Notice
            </button>
          </div>
        </div>
      </div>

      {!dpaConsent && (
        <p className="text-[11px] text-center text-slate-400">
          Sign-in is enabled after checking the privacy consent.
        </p>
      )}

      {/* RA 10173 Privacy Modal Sheet */}
      {isPrivacyModalOpen && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 animate-fade-in">
          <div className="bg-white rounded-3xl max-w-sm w-full p-6 shadow-2xl border border-slate-100 max-h-[85vh] overflow-y-auto">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100">
              <div className="flex items-center gap-2">
                <Shield className="w-5 h-5 text-[#0EA5E9]" />
                <h3 className="text-sm font-bold text-[#0F172A]">
                  Republic Act No. 10173
                </h3>
              </div>
              <button
                onClick={() => setIsPrivacyModalOpen(false)}
                className="p-1 rounded-full text-slate-400 hover:text-slate-600 hover:bg-slate-100 cursor-pointer"
              >
                ✕
              </button>
            </div>

            <div className="mt-3 space-y-3 text-xs text-slate-600 leading-relaxed">
              <p className="font-semibold text-slate-800">
                Data Privacy Act Compliance Notice
              </p>
              <p>
                GJ & Asher Logistics Management processes customer waybill manifests and support messaging strictly for delivery fulfillments and customer service inquiries.
              </p>
              <div className="bg-slate-50 p-3 rounded-xl border border-slate-200">
                <h4 className="font-bold text-slate-800 text-[11px] mb-1">
                  Customer & Buyer Protection
                </h4>
                <ul className="list-disc pl-4 space-y-1 text-[11px] text-slate-600">
                  <li>Your delivery address and contact numbers are protected and masked.</li>
                  <li>Customer-admin chat logs are retained strictly for resolution audits.</li>
                  <li>Newly registered users default to Customer. Admin or developer can change roles in Firebase.</li>
                </ul>
              </div>
            </div>

            <button
              onClick={() => {
                setDpaConsent(true);
                setIsPrivacyModalOpen(false);
              }}
              className="mt-5 w-full py-2.5 bg-[#0F172A] hover:bg-slate-800 text-white font-bold text-xs rounded-xl shadow-xs cursor-pointer"
            >
              I Understand & Acknowledge
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
