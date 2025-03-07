/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./**/*.{html,js}"],
  theme: {
    extend: {
      colors: {
        'darker': "#0F1729",
        'narn': '#56DBC5',
        'disabled': '#9CA3AF',
      }
    },
  },
  plugins: [],
}

