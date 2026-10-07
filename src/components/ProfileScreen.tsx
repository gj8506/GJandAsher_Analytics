import React, { useState, useMemo } from 'react';
import {
  User,
  Shield,
  CheckCircle2,
  Building2,
  LogOut,
  Users,
  UserCheck,
  Search,
  ChevronDown,
  ChevronUp,
  X,
  Filter,
  UserX,
  ShieldAlert,
  Sparkles,
} from 'lucide-react';
import { UserRecord } from '../types';

interface ProfileScreenProps {
  userRole: string;
  currentUser?: {
    email: string;
    name: string;
    role: string;
  };
  users?: UserRecord[];
  onUpdateUserRole?: (uid: string, newRole: 'customer' | 'staff' | 'admin') => void;
  onSignOut?: () => void;
}

export const ProfileScreen: React.FC<ProfileScreenProps> = ({
  userRole,
  currentUser = {
    email: 'nolancaparros.draft@gmail.com',
    name: 'Nolan Caparros',
    role: 'admin',
  },
  users = [],
  onUpdateUserRole,
  onSignOut,
}) => {
  const isAdmin = userRole.toLowerCase().includes('admin');

  // Account Manager Drawer / Collapsible states to prevent screen overflow
  const [isManagerOpen, setIsManagerOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [roleFilter, setRoleFilter] = useState<'all' | 'customer' | 'staff' | 'admin'>('all');
  const [notificationMsg, setNotificationMsg] = useState<string | null>(null);

  // Filtered users by tag/name or email, plus role filter
  const filteredUsers = useMemo(() => {
    return users.filter((u) => {
      const q = searchQuery.trim().toLowerCase();
      const matchesSearch =
        q === '' ||
        u.displayName.toLowerCase().includes(q) ||
        u.email.toLowerCase().includes(q) ||
        u.uid.toLowerCase().includes(q);

      const matchesRole = roleFilter === 'all' || u.role === roleFilter;

      return matchesSearch && matchesRole;
    });
  }, [users, searchQuery, roleFilter]);

  const handleRoleChange = (uid: string, newRole: 'customer' | 'staff' | 'admin', name: string) => {
    if (onUpdateUserRole) {
      onUpdateUserRole(uid, newRole);
      setNotificationMsg(`Updated ${name} to "${newRole.toUpperCase()}" in Firestore.`);
      setTimeout(() => setNotificationMsg(null), 3500);
    }
  };

  return (
    <div className="flex flex-col px-4 pt-3 pb-24 max-w-md mx-auto w-full">
      {/* Header */}
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
            {currentUser.name.substring(0, 2).toUpperCase()}
          </div>
          <div className="min-w-0 flex-1">
            <div className="text-sm font-bold text-[#0F172A] truncate">
              {currentUser.name}
            </div>
            <div className="text-xs text-slate-500 font-mono truncate">
              {currentUser.email}
            </div>
            <div className="flex items-center gap-1.5 mt-1">
              <span className="w-2 h-2 rounded-full bg-emerald-500" />
              <span className="text-[10px] font-semibold text-emerald-700">
                Google Auth Verified
              </span>
            </div>
          </div>
        </div>

        {/* Read-Only Role Display (No switching between staff and admin) */}
        <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between">
          <div>
            <span className="block text-xs font-semibold text-slate-700">
              Active System Role
            </span>
            <span className="text-[11px] text-slate-400">
              Synced from Cloud Firestore
            </span>
          </div>
          <div
            className={`px-3 py-1.5 rounded-xl border text-xs font-bold flex items-center gap-1.5 ${
              isAdmin
                ? 'bg-emerald-50 text-emerald-800 border-emerald-300'
                : 'bg-[#E0F2FE] text-[#0F172A] border-sky-300'
            }`}
          >
            <span
              className={`w-2 h-2 rounded-full ${
                isAdmin ? 'bg-emerald-500' : 'bg-[#0EA5E9]'
              }`}
            />
            <span>{isAdmin ? 'Admin' : 'Staff'}</span>
          </div>
        </div>
      </div>

      {/* Toast notification for role updates */}
      {notificationMsg && (
        <div className="mt-2 p-2.5 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-xl text-xs font-medium flex items-center gap-2 animate-fade-in">
          <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
          <span className="truncate">{notificationMsg}</span>
        </div>
      )}

      {/* Admin-Only: Separate / Dropdown Account Manager (prevents screen overflow) */}
      {isAdmin && onUpdateUserRole && (
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm mt-3 overflow-hidden">
          {/* Dropdown / Collapsible Header Toggle */}
          <button
            type="button"
            onClick={() => setIsManagerOpen(!isManagerOpen)}
            className="w-full p-4 flex items-center justify-between text-left hover:bg-slate-50/80 transition-colors cursor-pointer"
          >
            <div className="flex items-center gap-2.5">
              <div className="p-2 bg-indigo-50 text-indigo-600 rounded-xl">
                <Users className="w-4 h-4" />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <h3 className="text-xs font-bold text-[#0F172A]">
                    Account & Role Manager
                  </h3>
                  <span className="text-[9px] font-mono bg-indigo-100 text-indigo-700 px-1.5 py-0.5 rounded-md font-bold">
                    {users.length} Users
                  </span>
                </div>
                <p className="text-[10px] text-slate-400 mt-0.5">
                  Search user tag or email to promote to Staff
                </p>
              </div>
            </div>

            <div className="flex items-center gap-1.5 text-xs text-slate-500 font-semibold bg-slate-100 px-2 py-1 rounded-lg">
              <span>{isManagerOpen ? 'Hide' : 'Manage'}</span>
              {isManagerOpen ? (
                <ChevronUp className="w-3.5 h-3.5 text-slate-600" />
              ) : (
                <ChevronDown className="w-3.5 h-3.5 text-slate-600" />
              )}
            </div>
          </button>

          {/* Collapsible content (Prevents Screen Overflow) */}
          {isManagerOpen && (
            <div className="px-4 pb-4 pt-1 border-t border-slate-100">
              <div className="bg-indigo-50/50 p-2.5 rounded-xl border border-indigo-100/60 mb-3 text-[11px] text-indigo-950 leading-relaxed">
                <p>
                  <strong>Security Rule:</strong> Newly signed-in users automatically default to <em>Customer</em>. Only you (Admin) can inspect their tag/email and assign them <em>Staff</em> clearance.
                </p>
              </div>

              {/* Search Bar for Tag or Email */}
              <div className="relative mb-2.5">
                <Search className="w-3.5 h-3.5 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  placeholder="Search user tag, name, or email..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full pl-8 pr-8 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:bg-white transition-all text-slate-800 placeholder-slate-400"
                />
                {searchQuery && (
                  <button
                    onClick={() => setSearchQuery('')}
                    className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 p-0.5"
                  >
                    <X className="w-3 h-3" />
                  </button>
                )}
              </div>

              {/* Quick Role Filters */}
              <div className="flex items-center gap-1.5 mb-3 overflow-x-auto pb-1 text-[10px]">
                <span className="text-slate-400 font-medium mr-1 flex items-center gap-1">
                  <Filter className="w-2.5 h-2.5" /> Filter:
                </span>
                {(['all', 'customer', 'staff', 'admin'] as const).map((r) => (
                  <button
                    key={r}
                    onClick={() => setRoleFilter(r)}
                    className={`px-2 py-0.5 rounded-md font-semibold capitalize cursor-pointer transition-colors ${
                      roleFilter === r
                        ? 'bg-indigo-600 text-white'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                    }`}
                  >
                    {r}
                  </button>
                ))}
              </div>

              {/* Compact User List with Scroll Limit to Prevent Overflow */}
              <div className="max-h-60 overflow-y-auto space-y-2 pr-1 border border-slate-100 rounded-xl p-1 bg-slate-50/50">
                {filteredUsers.length === 0 ? (
                  <div className="py-6 text-center text-xs text-slate-400">
                    No users matching "{searchQuery}"
                  </div>
                ) : (
                  filteredUsers.map((u) => {
                    const isUserAdmin = u.role === 'admin';
                    const isUserStaff = u.role === 'staff';

                    return (
                      <div
                        key={u.uid}
                        className="p-2.5 rounded-xl border border-slate-200/90 bg-white flex items-center justify-between gap-2 shadow-2xs hover:border-slate-300 transition-colors"
                      >
                        <div className="min-w-0 flex-1">
                          <div className="flex items-center gap-1.5">
                            <span className="text-xs font-bold text-[#0F172A] truncate">
                              {u.displayName}
                            </span>
                            <span
                              className={`text-[9px] font-bold px-1.5 py-0.5 rounded-md uppercase ${
                                isUserAdmin
                                  ? 'bg-emerald-100 text-emerald-800'
                                  : isUserStaff
                                  ? 'bg-sky-100 text-sky-800'
                                  : 'bg-slate-100 text-slate-600'
                              }`}
                            >
                              {u.role}
                            </span>
                          </div>
                          <div className="text-[10px] text-slate-500 font-mono truncate">
                            {u.email}
                          </div>
                          <div className="text-[9px] text-slate-400 font-mono mt-0.5 truncate">
                            Tag: #{u.uid.substring(0, 12)}
                          </div>
                        </div>

                        {/* Dropdown / Quick Action per user */}
                        <div>
                          {isUserAdmin ? (
                            <span className="text-[10px] text-slate-400 font-semibold px-2 py-1 bg-slate-100 rounded-md">
                              Owner
                            </span>
                          ) : isUserStaff ? (
                            <button
                              onClick={() => handleRoleChange(u.uid, 'customer', u.displayName)}
                              className="text-[10px] font-bold px-2 py-1 bg-amber-50 hover:bg-amber-100 border border-amber-200 text-amber-800 rounded-lg transition-colors cursor-pointer flex items-center gap-1"
                              title="Demote to Customer"
                            >
                              <UserX className="w-3 h-3" />
                              <span>Revoke</span>
                            </button>
                          ) : (
                            <button
                              onClick={() => handleRoleChange(u.uid, 'staff', u.displayName)}
                              className="text-[10px] font-bold px-2.5 py-1 bg-[#0EA5E9] hover:bg-sky-600 text-white rounded-lg shadow-2xs transition-colors cursor-pointer flex items-center gap-1"
                              title="Promote to Warehouse Staff"
                            >
                              <UserCheck className="w-3 h-3" />
                              <span>Make Staff</span>
                            </button>
                          )}
                        </div>
                      </div>
                    );
                  })
                )}
              </div>
            </div>
          )}
        </div>
      )}

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

      {/* Logistics Hub Terminal Info (Clearly visible on phone screens) */}
      <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm mt-3">
        <div className="flex items-center gap-2 mb-2 pb-1.5 border-b border-slate-100">
          <Building2 className="w-4 h-4 text-slate-600" />
          <h3 className="text-xs font-bold text-[#0F172A]">
            Warehouse Terminal Configuration
          </h3>
        </div>
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
            <span className="font-mono text-slate-800 font-semibold">v2.0 (Full Integration)</span>
          </div>
        </div>
      </div>

      {/* Sign Out Action Button */}
      {onSignOut && (
        <button
          onClick={onSignOut}
          className="mt-3 w-full py-3 px-4 bg-rose-50 hover:bg-rose-100 border border-rose-200 text-rose-700 font-bold text-xs rounded-2xl flex items-center justify-center gap-2 transition-colors cursor-pointer"
        >
          <LogOut className="w-4 h-4" />
          <span>Sign Out of Google Account</span>
        </button>
      )}
    </div>
  );
};
