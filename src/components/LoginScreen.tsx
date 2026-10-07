import React, { useState } from 'react';
import { Truck, Shield, Check, Info, ArrowRight, X, User, Building2, Package, Lock } from 'lucide-react';

interface LoginScreenProps {
  onLoginSuccess: (user: { email: string; role: 'customer' | 'staff' | 'admin'; name: string }) => void;
}

export const LoginScreen: React.FC<LoginScreenProps> = ({ onLoginSuccess }) => {
  const [dpaConsent, setDpaConsent] = useState(false);
  const [isPrivacyModalOpen, setIsPrivacyModalOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [selectedRole, setSelectedRole] = useState<'customer' | 'admin'>('customer');
  const [emailInput, setEmailInput] = useState('');
  const [nameInput, setNameInput] = useState('');
  const [mode, setMode] = useState<'login' | 'signup'>('login');

  const handleSignIn = (overrideEmail?: string, overrideRole?: 'customer' | 'admin', overrideName?: string) => {
    if (!dpaConsent) return;
    setIsLoading(true);

    setTimeout(() => {
      setIsLoading(false);

      const targetEmail = (overrideEmail ?? emailInput).trim().toLowerCase();
      const isAdmin = targetEmail === 'gj8506@gmail.com' || overrideRole === 'admin';
      
      const role = isAdmin ? 'admin' : 'customer';
      const email = targetEmail || (isAdmin ? 'gj8506@gmail.com' : 'new.customer@gmail.com');
      const name = overrideName || nameInput.trim() || (isAdmin ? 'GJ & Asher Admin' : 'New Customer');

      onLoginSuccess({
        email,
        name,
        role,
      });
    }, 400);
  };

  return (
    <div className="min-h-screen bg-[#F8FAFC] flex flex-col justify-center items-center px-4 py-8 max-w-md mx-auto w-full">
      {/* Brand Header */}
      <div className="flex flex-col items-center text-center mb-5">
        <div className="w-16 h-16 rounded-2xl bg-[#0F172A] flex items-center justify-center text-white shadow-xl shadow-slate-900/10 mb-3">
          <Truck className="w-8 h-8 text-white" />
        </div>
        <h1 className="text-xl font-bold tracking-tight text-[#0F172A]">
          GJandAsher ShipTracker
        </h1>
        <p className="text-xs text-slate-500 mt-0.5 max-w-xs leading-relaxed">
          Logistics Hub & Customer Order Tracking System
        </p>
      </div>

      {/* Mode Selector Tabs: Sign In vs First Time Sign Up */}
      <div className="w-full bg-slate-200/80 p-1 rounded-xl flex items-center mb-4 text-xs font-semibold">
        <button
          onClick={() => setMode('login')}
          className={`flex-1 py-1.5 rounded-lg transition-all ${
            mode === 'login'
              ? 'bg-white text-[#0F172A] shadow-xs'
              : 'text-slate-600 hover:text-slate-900'
          }`}
        >
          Sign In
        </button>
        <button
          onClick={() => setMode('signup')}
          className={`flex-1 py-1.5 rounded-lg transition-all ${
            mode === 'signup'
              ? 'bg-white text-[#0F172A] shadow-xs'
              : 'text-slate-600 hover:text-slate-900'
          }`}
        >
          Register (First Time)
        </button>
      </div>

      {/* Input / Account Selection Card */}
      <div className="w-full bg-white rounded-2xl p-4 border border-slate-200 shadow-2xs mb-4">
        {mode === 'signup' ? (
          <div className="space-y-3">
            <div className="flex items-center gap-2 text-[#0F172A] font-bold text-xs mb-1">
              <Lock className="w-4 h-4 text-sky-600" />
              <span>Register New Customer Account</span>
            </div>
            <p className="text-[11px] text-slate-500 leading-relaxed">
              Every newly registered account starts as a <strong>Customer</strong>. Only the Admin can promote staff members.
            </p>
            <div>
              <label className="block text-[11px] font-semibold text-slate-700 mb-1">Your Full Name</label>
              <input
                type="text"
                value={nameInput}
                onChange={(e) => setNameInput(e.target.value)}
                placeholder="e.g. Nolan Cortez"
                className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs text-slate-800 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
              />
            </div>
            <div>
              <label className="block text-[11px] font-semibold text-slate-700 mb-1">Email Address</label>
              <input
                type="email"
                value={emailInput}
                onChange={(e) => setEmailInput(e.target.value)}
                placeholder="your.email@gmail.com"
                className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs text-slate-800 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
              />
            </div>
          </div>
        ) : (
          <div className="space-y-3">
            <div className="flex items-center justify-between mb-1">
              <span className="text-[11px] font-bold text-slate-500 uppercase tracking-wider">
                Sign In Options
              </span>
              <span className="text-[10px] text-slate-400 font-mono">
                Role-guarded
              </span>
            </div>

            {/* Quick account choices */}
            <div className="space-y-2 text-xs">
              {/* New Customer */}
              <div
                onClick={() => setSelectedRole('customer')}
                className={`p-3 rounded-xl border flex items-center justify-between cursor-pointer transition-all ${
                  selectedRole === 'customer'
                    ? 'bg-sky-50 border-sky-400 text-sky-950 font-bold'
                    : 'bg-white border-slate-200 text-slate-700 hover:bg-slate-50'
                }`}
              >
                <div className="flex items-center gap-2.5">
                  <div className="w-7 h-7 rounded-full bg-sky-100 text-sky-700 flex items-center justify-center font-bold text-xs">
                    CU
                  </div>
                  <div>
                    <div className="text-xs font-semibold leading-tight">New Customer</div>
                    <div className="text-[10px] text-slate-400">Personal Orders & Store Chat</div>
                  </div>
                </div>
                <span className="text-[10px] px-2 py-0.5 rounded-md bg-white border border-slate-200 text-slate-600">
                  Customer
                </span>
              </div>

              {/* Admin gj8506 */}
              <div
                onClick={() => setSelectedRole('admin')}
                className={`p-3 rounded-xl border flex items-center justify-between cursor-pointer transition-all ${
                  selectedRole === 'admin'
                    ? 'bg-emerald-50 border-emerald-400 text-emerald-950 font-bold'
                    : 'bg-white border-slate-200 text-slate-700 hover:bg-slate-50'
                }`}
              >
                <div className="flex items-center gap-2.5">
                  <div className="w-7 h-7 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold text-xs">
                    GJ
                  </div>
                  <div>
                    <div className="text-xs font-semibold leading-tight">gj8506@gmail.com</div>
                    <div className="text-[10px] text-slate-400">Warehouse Administrator (All Access)</div>
                  </div>
                </div>
                <span className="text-[10px] px-2 py-0.5 rounded-md bg-emerald-100 text-emerald-800 font-bold">
                  Admin
                </span>
              </div>
            </div>

            <div className="pt-1">
              <label className="block text-[10px] font-semibold text-slate-500 mb-1">Or enter custom email:</label>
              <input
                type="email"
                value={emailInput}
                onChange={(e) => setEmailInput(e.target.value)}
                placeholder="e.g. gj8506@gmail.com or your email"
                className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs text-slate-800 focus:outline-none focus:ring-2 focus:ring-[#0EA5E9]"
              />
            </div>
          </div>
        )}
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
              className="mt-1 text-[11px] text-[#0EA5E9] font-bold hover:underline inline-flex items-center gap-1"
            >
              <Info className="w-3 h-3" />
              Read Privacy Notice
            </button>
          </div>
        </div>
      </div>

      {/* Action Button */}
      <div className="w-full space-y-2">
        <button
          onClick={() => handleSignIn(
            emailInput.trim() ? emailInput.trim() : (selectedRole === 'admin' ? 'gj8506@gmail.com' : 'new.customer@gmail.com'),
            selectedRole,
            nameInput.trim() ? nameInput.trim() : (selectedRole === 'admin' ? 'GJ & Asher Admin' : 'New Customer')
          )}
          disabled={!dpaConsent || isLoading}
          className={`w-full py-3 px-4 rounded-xl font-bold text-xs flex items-center justify-center gap-3 transition-all border ${
            dpaConsent
              ? 'bg-[#0F172A] hover:bg-slate-800 text-white shadow-md cursor-pointer border-[#0F172A]'
              : 'bg-slate-100 text-slate-400 border-slate-200 cursor-not-allowed'
          }`}
        >
          {isLoading ? (
            <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
          ) : (
            <>
              {/* Google G Icon */}
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
              <span>
                {mode === 'signup'
                  ? 'Register as New Customer'
                  : selectedRole === 'admin'
                  ? 'Sign In as Admin (gj8506@gmail.com)'
                  : 'Sign In as New Customer'}
              </span>
            </>
          )}
        </button>

        {!dpaConsent && (
          <p className="text-[11px] text-center text-slate-400">
            Sign-in is blocked until privacy consent is acknowledged.
          </p>
        )}
      </div>

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
                className="p-1 rounded-full text-slate-400 hover:text-slate-600 hover:bg-slate-100"
              >
                <X className="w-5 h-5" />
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
                  <li>Only verified warehouse staff and administrators have access to dispatches.</li>
                </ul>
              </div>
            </div>

            <button
              onClick={() => {
                setDpaConsent(true);
                setIsPrivacyModalOpen(false);
              }}
              className="mt-5 w-full py-2.5 bg-[#0F172A] hover:bg-slate-800 text-white font-bold text-xs rounded-xl shadow-xs"
            >
              I Understand & Acknowledge
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
