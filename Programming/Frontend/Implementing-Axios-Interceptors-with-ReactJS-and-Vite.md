# Implementing Axios Interceptors with ReactJS and Vite

Handle JWT access token & refresh token automatically using Axios interceptors in a React + Vite project.

---

### 1. Axios Instance with Interceptors

`src/api/axios.js`
```js
import axios from 'axios';
import authService from '../auth/authService';

const api = axios.create({
  baseURL: 'https://your-api.com/api',
  withCredentials: true,
});

api.interceptors.request.use((config) => {
  const token = authService.getAccessToken();
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

let isRefreshing = false;
let failedQueue = [];

const processQueue = (err, token = null) => {
  failedQueue.forEach((p) => err ? p.reject(err) : p.resolve(token));
  failedQueue = [];
};

api.interceptors.response.use(
  (res) => res,
  async (err) => {
    const originalRequest = err.config;
    if (
      err.response?.status === 401 &&
      !originalRequest._retry &&
      authService.getRefreshToken()
    ) {
      originalRequest._retry = true;

      if (isRefreshing) {
        return new Promise((res, rej) =>
          failedQueue.push({ resolve: res, reject: rej })
        ).then((token) => {
          originalRequest.headers.Authorization = `Bearer ${token}`;
          return api(originalRequest);
        });
      }

      isRefreshing = true;
      try {
        const { accessToken } = await authService.refreshToken();
        authService.setAccessToken(accessToken);
        processQueue(null, accessToken);
        originalRequest.headers.Authorization = `Bearer ${accessToken}`;
        return api(originalRequest);
      } catch (e) {
        processQueue(e, null);
        authService.logout();
        return Promise.reject(e);
      } finally {
        isRefreshing = false;
      }
    }

    return Promise.reject(err);
  }
);

export default api;
````

---

### 2. Auth Service

`src/auth/authService.js`

```js
const ACCESS = 'accessToken';
const REFRESH = 'refreshToken';

const authService = {
  getAccessToken: () => localStorage.getItem(ACCESS),
  setAccessToken: (t) => localStorage.setItem(ACCESS, t),
  getRefreshToken: () => localStorage.getItem(REFRESH),
  setRefreshToken: (t) => localStorage.setItem(REFRESH, t),
  logout: () => {
    localStorage.removeItem(ACCESS);
    localStorage.removeItem(REFRESH);
    window.location.href = '/login';
  },
  refreshToken: async () => {
    const res = await fetch('https://your-api.com/api/auth/refresh', {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refreshToken: authService.getRefreshToken() }),
    });
    if (!res.ok) throw new Error('Failed to refresh');
    return res.json(); // { accessToken }
  },
};

export default authService;
```

---

### 3. Use in Component

`src/pages/Dashboard.jsx`

```js
import { useEffect, useState } from 'react';
import api from '../api/axios';

function Dashboard() {
  const [data, setData] = useState(null);

  useEffect(() => {
    api.get('/user/profile')
      .then((res) => setData(res.data))
      .catch(console.error);
  }, []);

  return data ? <div>{data.name}</div> : <div>Loading...</div>;
}

export default Dashboard;
```
