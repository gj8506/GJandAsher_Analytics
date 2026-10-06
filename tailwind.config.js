/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'ship-navy': '#0F172A',
        'ship-navy-secondary': '#1E293B',
        'ship-teal': '#0EA5E9',
        'ship-teal-container': '#E0F2FE',
        'ship-surface': '#F8FAFC',
        'ship-border': '#E2E8F0',
        'shopee': '#EE4D2D',
        'shopee-container': '#FFECE7',
        'lazada': '#0F146D',
        'lazada-container': '#E8EBFF',
        'tiktok': '#010101',
        'tiktok-teal': '#00F2FE',
        'tiktok-container': '#F1F5F9',
        'status-pending': '#F59E0B',
        'status-dispatched': '#3B82F6',
        'status-intransit': '#8B5CF6',
        'status-delivered': '#10B981',
        'status-returned': '#EF4444',
      },
    },
  },
  plugins: [],
}
