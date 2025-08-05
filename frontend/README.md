# ChefsCircle Frontend

A modern React-based frontend for the ChefsCircle User Management System.

## Features

- 🎨 **Modern UI Design**: Beautiful, responsive interface with glassmorphism effects
- 🔍 **Search Functionality**: Real-time search through users by name, email, or username
- 📱 **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- ⚡ **Fast Loading**: Optimized with loading states and error handling
- 🔄 **Auto-refresh**: Manual refresh capability to fetch latest data
- 🎯 **User Cards**: Clean display of user information with avatars and roles

## Prerequisites

- Node.js (version 16 or higher)
- npm or yarn
- Backend server running on `http://localhost:8080/backend`

## Installation

1. Install dependencies:
```bash
npm install
```

## Development

1. Start the development server:
```bash
npm run dev
```

2. Open your browser and navigate to `http://localhost:5173`

The frontend will automatically proxy API requests to the backend server running on port 8080.

## API Endpoint

The frontend connects to the backend API endpoint:
- **Local**: `/api/users` (proxied to `http://localhost:8080/backend/api/users`)
- **Production**: Configure the full backend URL as needed

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint

## Project Structure

```
src/
├── App.jsx          # Main application component
├── App.css          # Application styles
├── index.css        # Global styles
└── main.jsx         # Application entry point
```

## Backend Integration

The frontend expects the backend to return user data in the following format:

```json
[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "username": "johndoe",
    "role": "USER"
  }
]
```

## Troubleshooting

1. **CORS Issues**: The development server includes a proxy configuration to handle CORS. Make sure your backend is running on port 8080.

2. **API Connection**: If you can't connect to the API, verify that:
   - The backend server is running
   - The backend is accessible at `http://localhost:8080/backend`
   - The API endpoint `/backend/api/users` is working

3. **Build Issues**: If you encounter build issues, try:
   ```bash
   npm install
   npm run build
   ```
