import React, { useState } from 'react';
import { Navbar } from './components/Navbar';
import { ParcelsDashboard } from './components/ParcelsDashboard';
import { DispatchScreen } from './components/DispatchScreen';
import { ReturnsScreen } from './components/ReturnsScreen';
import { AnalyticsScreen } from './components/AnalyticsScreen';
import { ProfileScreen } from './components/ProfileScreen';
import { ParcelDetailModal } from './components/ParcelDetailModal';
import { LoginScreen } from './components/LoginScreen';
import { CustomerPortal } from './components/customer/CustomerPortal';
import { INITIAL_PARCELS, INITIAL_RETURNS, INITIAL_PRODUCTS, INITIAL_CHAT_MESSAGES, INITIAL_USERS } from './mockData';
import { Parcel, ReturnRecord, Product, ChatMessage, PortalType, UserRecord } from './types';
import { LogOut, Truck } from 'lucide-react';

export const App: React.FC = () => {
  // Directly put user into login page on first open
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(() => {
    return sessionStorage.getItem('shiptracker_auth') === 'true';
  });

  const [users, setUsers] = useState<UserRecord[]>(INITIAL_USERS);

  const [currentUser, setCurrentUser] = useState<UserRecord>(() => {
    const savedUserJson = sessionStorage.getItem('shiptracker_user');
    if (savedUserJson) {
      try {
        return JSON.parse(savedUserJson);
      } catch {
        // fallback
      }
    }
    return INITIAL_USERS[0]; // default to Admin if pre-authenticated
  });

  const [selectedTab, setSelectedTab] = useState<number>(0);
  const [parcels, setParcels] = useState<Parcel[]>(INITIAL_PARCELS);
  const [customerParcels, setCustomerParcels] = useState<Parcel[]>([]);
  const [returns, setReturns] = useState<ReturnRecord[]>(INITIAL_RETURNS);
  const [products, setProducts] = useState<Product[]>(INITIAL_PRODUCTS);
  const [chatMessages, setChatMessages] = useState<ChatMessage[]>(INITIAL_CHAT_MESSAGES);
  const [selectedParcel, setSelectedParcel] = useState<Parcel | null>(null);

  const activePortal: PortalType = currentUser.role === 'customer' ? 'customer' : 'warehouse';

  const handleLoginSuccess = (userPayload: { email: string; role: 'customer' | 'staff' | 'admin'; name: string }) => {
    // Check if user already exists in users list
    let existingUser = users.find((u) => u.email.toLowerCase() === userPayload.email.toLowerCase());
    
    if (!existingUser) {
      // Newly registered user: automatically registered with the 'customer' role
      existingUser = {
        uid: `usr-${Date.now()}`,
        email: userPayload.email,
        displayName: userPayload.name,
        role: userPayload.role, // 'customer' by default on signup
        registeredAt: 'Just now',
        dpaConsent: true,
      };
      setUsers((prev) => [...prev, existingUser!]);
    }

    setCurrentUser(existingUser);
    setIsAuthenticated(true);
    sessionStorage.setItem('shiptracker_auth', 'true');
    sessionStorage.setItem('shiptracker_user', JSON.stringify(existingUser));
    setSelectedTab(0);
  };

  const handleSignOut = () => {
    setIsAuthenticated(false);
    sessionStorage.removeItem('shiptracker_auth');
    sessionStorage.removeItem('shiptracker_user');
    setSelectedTab(0);
  };

  // Only Administrator can edit whether a newly signed-in user is a staff
  const handleUpdateUserRole = (uid: string, newRole: 'customer' | 'staff' | 'admin') => {
    setUsers((prev) =>
      prev.map((u) => {
        if (u.uid === uid) {
          const updated = { ...u, role: newRole };
          if (currentUser.uid === uid) {
            setCurrentUser(updated);
            sessionStorage.setItem('shiptracker_user', JSON.stringify(updated));
          }
          return updated;
        }
        return u;
      })
    );
  };

  const handleAddParcel = (newParcel: Parcel) => {
    setParcels((prev) => [newParcel, ...prev]);
    if (newParcel.customer.toLowerCase() === currentUser.displayName.toLowerCase()) {
      setCustomerParcels((prev) => [newParcel, ...prev]);
    }
  };

  const handleAddReturn = (newReturn: ReturnRecord) => {
    setReturns((prev) => [newReturn, ...prev]);
  };

  // Two-way messaging between customer and admin
  const handleSendMessage = (
    text: string,
    attachedItem?: { type: 'parcel' | 'product'; id: string; name: string }
  ) => {
    const newMsg: ChatMessage = {
      id: `msg-${Date.now()}`,
      sender: 'customer',
      senderName: currentUser.displayName || 'New Customer',
      text: text || `Inquiring about ${attachedItem?.name}`,
      timestamp: 'Just now',
      trackingNumber: attachedItem?.type === 'parcel' ? attachedItem.name.match(/#(\w+)/)?.[1] : undefined,
      productId: attachedItem?.type === 'product' ? attachedItem.id : undefined,
    };

    setChatMessages((prev) => [...prev, newMsg]);

    // Simulated Smart Admin Response from Admin gj8506 after 1 second
    setTimeout(() => {
      let replyText = 'Thank you for reaching out to GJ & Asher Logistics Hub. Our fulfillment team is reviewing your request.';
      const lower = text.toLowerCase();

      if (lower.includes('where') || lower.includes('dispatched') || lower.includes('order') || lower.includes('tracking')) {
        replyText = 'Hi! We checked your order status. The courier has scanned the waybill and it is currently in transit to your city hub on schedule!';
      } else if (lower.includes('stock') || lower.includes('available') || lower.includes('keyboard') || lower.includes('earbuds')) {
        replyText = 'Great news! That item is in stock at our warehouse (MNL-HUB-04) with same-day dispatch available.';
      } else if (lower.includes('return') || lower.includes('refund') || lower.includes('damage') || lower.includes('broken')) {
        replyText = 'We apologize for any inconvenience! Please keep the parcel and shipping seal intact. We can log an RTS condition inspection for immediate refund processing.';
      } else if (lower.includes('address') || lower.includes('change')) {
        replyText = 'We can update your destination hub routing as long as the parcel has not yet been loaded into the courier last-mile dispatch van.';
      }

      const adminReply: ChatMessage = {
        id: `msg-admin-${Date.now()}`,
        sender: 'admin',
        senderName: 'Admin (gj8506)',
        text: replyText,
        timestamp: 'Just now',
      };

      setChatMessages((prev) => [...prev, adminReply]);
    }, 1100);
  };

  // If not authenticated, directly present Login / First-time Sign-up page
  if (!isAuthenticated) {
    return <LoginScreen onLoginSuccess={handleLoginSuccess} />;
  }

  // If account role is Customer, render dedicated Customer Portal (Separate account required)
  if (activePortal === 'customer') {
    return (
      <CustomerPortal
        parcels={customerParcels}
        products={products}
        chatMessages={chatMessages}
        onSendMessage={handleSendMessage}
        onSelectParcel={(p) => setSelectedParcel(p)}
        onSignOut={handleSignOut}
        customerName={currentUser.displayName}
        customerEmail={currentUser.email}
      />
    );
  }

  // Otherwise, render Warehouse Logistics Hub (Staff / Admin)
  const isAdmin = currentUser.role === 'admin';
  const roleDisplay = isAdmin ? 'Admin' : 'Staff';

  return (
    <div className="min-h-screen bg-[#F8FAFC] flex justify-center text-slate-900">
      {/* Mobile-centric Applet Container */}
      <div className="w-full max-w-md min-h-screen bg-[#F8FAFC] flex flex-col relative shadow-sm border-x border-slate-200/60">
        {/* Top Warehouse Hub Banner (Displays current role, strictly no customer toggle button) */}
        <header className="bg-[#0F172A] text-white px-4 py-2.5 flex items-center justify-between text-xs border-b border-slate-800">
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 rounded-lg bg-sky-500/20 text-[#0EA5E9] flex items-center justify-center font-bold">
              <Truck className="w-3.5 h-3.5 text-sky-400" />
            </div>
            <div>
              <div className="flex items-center gap-1.5 font-bold text-xs tracking-tight">
                <span>GJ & Asher Warehouse Hub</span>
              </div>
              <div className="text-[10px] text-slate-400 leading-none">
                Logged in as {currentUser.displayName}
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <span
              className={`text-[10px] font-bold px-2 py-0.5 rounded-full border ${
                isAdmin
                  ? 'bg-emerald-500/20 text-emerald-300 border-emerald-500/40'
                  : 'bg-sky-500/20 text-sky-300 border-sky-500/40'
              }`}
            >
              {roleDisplay}
            </span>
            <button
              onClick={handleSignOut}
              className="p-1 text-slate-400 hover:text-white transition-colors cursor-pointer"
              title="Sign Out of Account"
            >
              <LogOut className="w-3.5 h-3.5" />
            </button>
          </div>
        </header>

        <main className="flex-1 overflow-y-auto">
          {selectedTab === 0 && (
            <ParcelsDashboard
              parcels={parcels}
              onSelectParcel={(p) => setSelectedParcel(p)}
              userRole={`${roleDisplay.toUpperCase()} MODE`}
            />
          )}

          {selectedTab === 1 && (
            <DispatchScreen
              onAddParcel={handleAddParcel}
              onNavigateToParcels={() => setSelectedTab(0)}
            />
          )}

          {selectedTab === 2 && (
            <ReturnsScreen
              returns={returns}
              onAddReturn={handleAddReturn}
            />
          )}

          {selectedTab === 3 && (
            <AnalyticsScreen />
          )}

          {selectedTab === 4 && (
            <ProfileScreen
              userRole={roleDisplay}
              currentUser={{
                email: currentUser.email,
                name: currentUser.displayName,
                role: currentUser.role,
              }}
              users={users}
              onUpdateUserRole={handleUpdateUserRole}
              onSignOut={handleSignOut}
            />
          )}
        </main>

        {/* Modal for parcel details */}
        <ParcelDetailModal
          parcel={selectedParcel}
          onClose={() => setSelectedParcel(null)}
        />

        {/* Bottom Navigation Bar */}
        <Navbar
          currentTab={selectedTab}
          onSelectTab={setSelectedTab}
          pendingReturnsCount={returns.filter((r) => r.refundStatus === 'Pending Inspection').length}
        />
      </div>
    </div>
  );
};

export default App;
