# Bawaskar Dealer App

Flutter Dealer B2B eCommerce app using GetX modules.

## Important

Products and dealer prices are visible only after login and admin approval.

## Main Features

- Dealer mobile OTP login
- Dealer registration with firm name and GST number
- Admin approval pending handling
- Dealer dashboard cards: credit limit, outstanding, pending orders
- Dealer product catalogue with dealer pricing
- Category screen
- Cart and B2B checkout
- Dealer orders
- Profile and logout
- Green professional theme based on Laravel storefront

## Run

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

For live server:

```bash
flutter run --dart-define=API_BASE_URL=https://drbawasakar.turnkeyinfotech.live/api/v1
```

## Laravel APIs used

- POST /auth/otp/request with purpose=dealer_login
- POST /auth/dealer/otp/verify
- GET /dealer/dashboard
- GET /dealer/profile
- GET /dealer/statements
- GET /catalog/categories
- GET /catalog/products?audience=dealer
- GET /dealer/orders
- POST /dealer/orders

Email login, dealer address save, and dealer support endpoints are UI-ready but require backend endpoints if you want to activate them.
