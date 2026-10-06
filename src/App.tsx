import React, { useState } from 'react';
import { Navbar } from './components/Navbar';
import { ParcelsDashboard } from './components/ParcelsDashboard';
import { DispatchScreen } from './components/DispatchScreen';
import { ReturnsScreen } from './components/ReturnsScreen';
import { AnalyticsScreen } from './components/AnalyticsScreen';
import { ProfileScreen } from './components/ProfileScreen';
import { ParcelDetailModal } from './components/ParcelDetailModal';
import { INITIAL_PARCELS, INITIAL_RETURNS } from './mockData';
import { Parcel, ReturnRecord } from './types';

export const App: React.FC = () => {
  const [selectedTab, setSelectedTab] = useState<number>(0);
  const [parcels, setParcels] = useState<Parcel[]>(INITIAL_PARCELS);
  const [returns, setReturns] = useState<ReturnRecord[]>(INITIAL_RETURNS);
  const [selectedParcel, setSelectedParcel] = useState<Parcel | null>(null);
  const [userRole, setUserRole] = useState<string>('Staff Mode');

  const handleAddParcel = (newParcel: Parcel) => {
    setParcels((prev) => [newParcel, ...prev]);
  };

  const handleAddReturn = (newReturn: ReturnRecord) => {
    setReturns((prev) => [newReturn, ...prev]);
  };

  return (
    <div className="min-h-screen bg-[#F8FAFC] flex justify-center text-slate-900">
      {/* Mobile-centric Applet Container matching Android Compose Scaffold */}
      <div className="w-full max-w-md min-h-screen bg-[#F8FAFC] flex flex-col relative shadow-sm border-x border-slate-200/60">
        <main className="flex-1 overflow-y-auto">
          {selectedTab === 0 && (
            <ParcelsDashboard
              parcels={parcels}
              onSelectParcel={(p) => setSelectedParcel(p)}
              userRole={userRole}
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
              userRole={userRole}
              setUserRole={setUserRole}
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
