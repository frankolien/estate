# Estate Management Platform - API Documentation

## 🚀 Base URL
```
http://localhost:8080/api
```

## 🔐 Authentication

All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

---

## 📋 API Endpoints

### 🔑 Authentication Endpoints

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "password": "password123",
  "phoneNumber": "+2348012345678",
  "userType": "LANDLORD"
}
```

**Response:**
```json
{
  "id": 1,
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "userType": "LANDLORD",
  "isVerified": false,
  "createdAt": "2024-01-01T10:00:00"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "userType": "LANDLORD"
  },
  "type": "Bearer"
}
```

#### Refresh Token
```http
POST /api/auth/refresh
Authorization: Bearer <current_token>
```

---

### 👥 User Management

#### Get All Users
```http
GET /api/users
```

#### Get User by ID
```http
GET /api/users/{id}
```

#### Get User by Email
```http
GET /api/users/email/{email}
```

#### Get Users by Type
```http
GET /api/users/type/{userType}?page=0&size=10
```

**User Types:** `LANDLORD`, `AGENT`, `TENANT`, `INVESTOR`, `ADMIN`

#### Update User
```http
PUT /api/users/{id}
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Smith",
  "phoneNumber": "+2348012345678",
  "bio": "Experienced real estate agent"
}
```

#### Verify User
```http
PUT /api/users/verify/{token}
```

#### Reset Password
```http
POST /api/users/reset-password?email=john@example.com&newPassword=newpass123
```

---

### 🏠 Property Management

#### Get All Properties
```http
GET /api/properties?page=0&size=10&sortBy=createdAt&sortDir=desc
```

#### Get Property by ID
```http
GET /api/properties/{id}
```

#### Get Properties by User
```http
GET /api/properties/user/{userId}
```

#### Get Properties by Type
```http
GET /api/properties/type/{propertyType}
```

**Property Types:** `APARTMENT`, `HOUSE`, `CONDO`, `TOWNHOUSE`, `VILLA`, `STUDIO`, `PENTHOUSE`, `DUPLEX`, `OFFICE`, `RETAIL`, `WAREHOUSE`, `INDUSTRIAL`, `LAND`, `COMMERCIAL`, `MIXED_USE`

#### Get Properties by Listing Type
```http
GET /api/properties/listing/{listingType}
```

**Listing Types:** `BUY`, `SELL`, `RENT`, `LEASE`

#### Get Properties by City
```http
GET /api/properties/city/{city}
```

#### Get Properties by State
```http
GET /api/properties/state/{state}
```

#### Get Featured Properties
```http
GET /api/properties/featured
```

#### Search Properties
```http
GET /api/properties/search?keyword=luxury apartment
```

#### Advanced Property Filtering
```http
GET /api/properties/filter?minPrice=100000&maxPrice=500000&city=Lagos&propertyType=APARTMENT&listingType=RENT&minBedrooms=2&maxBedrooms=4&page=0&size=10
```

#### Get Latest Properties
```http
GET /api/properties/latest?page=0&size=10
```

#### Get Most Viewed Properties
```http
GET /api/properties/most-viewed?page=0&size=10
```

#### Get Most Liked Properties
```http
GET /api/properties/most-liked?page=0&size=10
```

#### Create Property
```http
POST /api/properties?userId=1
Content-Type: application/json

{
  "title": "Luxury 3-Bedroom Apartment",
  "description": "Beautiful apartment with modern amenities",
  "price": 250000,
  "propertyType": "APARTMENT",
  "listingType": "RENT",
  "address": "123 Victoria Island",
  "city": "Lagos",
  "state": "Lagos",
  "postalCode": "101241",
  "bedrooms": 3,
  "bathrooms": 2,
  "squareFeet": 1200,
  "isFurnished": true,
  "hasPool": true,
  "hasGym": true
}
```

#### Update Property
```http
PUT /api/properties/{id}
Content-Type: application/json

{
  "title": "Updated Property Title",
  "price": 300000
}
```

#### Delete Property
```http
DELETE /api/properties/{id}
```

#### Verify Property
```http
PUT /api/properties/{id}/verify
```

#### Feature Property
```http
PUT /api/properties/{id}/feature
```

---

### ❤️ Property Likes

#### Like Property
```http
POST /api/properties/{propertyId}/likes?userId=1
```

#### Unlike Property
```http
DELETE /api/properties/{propertyId}/likes?userId=1
```

#### Check if Property is Liked
```http
GET /api/properties/{propertyId}/likes/check?userId=1
```

#### Get Like Count
```http
GET /api/properties/{propertyId}/likes/count
```

#### Get Users Who Liked Property
```http
GET /api/properties/{propertyId}/likes/users
```

---

### ⭐ Property Reviews

#### Create Review
```http
POST /api/properties/{propertyId}/reviews?userId=1
Content-Type: application/json

{
  "comment": "Great property with excellent location!",
  "rating": 5
}
```

#### Get Reviews by Property
```http
GET /api/properties/{propertyId}/reviews
```

#### Get Reviews by Property (Paginated)
```http
GET /api/properties/{propertyId}/reviews/paginated?page=0&size=10
```

#### Get Reviews by User
```http
GET /api/properties/{propertyId}/reviews/user/{userId}
```

#### Update Review
```http
PUT /api/properties/{propertyId}/reviews/{reviewId}?userId=1
Content-Type: application/json

{
  "comment": "Updated review comment",
  "rating": 4
}
```

#### Delete Review
```http
DELETE /api/properties/{propertyId}/reviews/{reviewId}?userId=1
```

#### Get Average Rating
```http
GET /api/properties/{propertyId}/reviews/average-rating
```

#### Get Review Count
```http
GET /api/properties/{propertyId}/reviews/count
```

#### Filter Reviews by Rating
```http
GET /api/properties/{propertyId}/reviews/filter?minRating=4
```

#### Verify Review
```http
PUT /api/properties/{propertyId}/reviews/{reviewId}/verify
```

---

### 💬 Property Comments

#### Create Comment
```http
POST /api/properties/{propertyId}/comments?userId=1
Content-Type: application/json

{
  "content": "This property looks amazing!",
  "parentCommentId": null
}
```

#### Get Comments by Property
```http
GET /api/properties/{propertyId}/comments
```

#### Get Top-Level Comments
```http
GET /api/properties/{propertyId}/comments/top-level
```

#### Get Comments by Property (Paginated)
```http
GET /api/properties/{propertyId}/comments/paginated?page=0&size=10
```

#### Get Replies by Comment
```http
GET /api/properties/{propertyId}/comments/{parentCommentId}/replies
```

#### Get Comments by User
```http
GET /api/properties/{propertyId}/comments/user/{userId}
```

#### Update Comment
```http
PUT /api/properties/{propertyId}/comments/{commentId}?userId=1
Content-Type: application/json

{
  "content": "Updated comment content"
}
```

#### Delete Comment
```http
DELETE /api/properties/{propertyId}/comments/{commentId}?userId=1
```

#### Get Comment Count
```http
GET /api/properties/{propertyId}/comments/count
```

#### Get Reply Count
```http
GET /api/properties/{propertyId}/comments/{parentCommentId}/replies/count
```

---

### 🔍 Saved Searches

#### Create Saved Search
```http
POST /api/saved-searches?userId=1
Content-Type: application/json

{
  "name": "Lagos Apartments Under 2M",
  "description": "Looking for affordable apartments in Lagos",
  "minPrice": 100000,
  "maxPrice": 2000000,
  "city": "Lagos",
  "propertyType": "APARTMENT",
  "listingType": "RENT",
  "minBedrooms": 2,
  "maxBedrooms": 3,
  "notificationEnabled": true
}
```

#### Get Saved Searches by User
```http
GET /api/saved-searches/user/{userId}
```

#### Get Active Saved Searches by User
```http
GET /api/saved-searches/user/{userId}/active
```

#### Get Notification Enabled Searches
```http
GET /api/saved-searches/notifications
```

#### Update Saved Search
```http
PUT /api/saved-searches/{searchId}?userId=1
Content-Type: application/json

{
  "name": "Updated Search Name",
  "maxPrice": 3000000,
  "notificationEnabled": false
}
```

#### Delete Saved Search
```http
DELETE /api/saved-searches/{searchId}?userId=1
```

#### Activate Saved Search
```http
PUT /api/saved-searches/{searchId}/activate?userId=1
```

#### Deactivate Saved Search
```http
PUT /api/saved-searches/{searchId}/deactivate?userId=1
```

#### Get Saved Search Count by User
```http
GET /api/saved-searches/user/{userId}/count
```

#### Get Active Saved Search Count by User
```http
GET /api/saved-searches/user/{userId}/active-count
```

---

## 📊 Response Formats

### Success Response
```json
{
  "data": { ... },
  "message": "Success",
  "status": 200
}
```

### Error Response
```json
{
  "error": "Error message",
  "status": 400,
  "timestamp": "2024-01-01T10:00:00"
}
```

### Paginated Response
```json
{
  "content": [ ... ],
  "pageable": {
    "pageNumber": 0,
    "pageSize": 10,
    "sort": {
      "sorted": true,
      "unsorted": false
    }
  },
  "totalElements": 100,
  "totalPages": 10,
  "first": true,
  "last": false,
  "numberOfElements": 10
}
```

---

## 🔒 Security Notes

1. **JWT Tokens**: All protected endpoints require valid JWT tokens
2. **User Ownership**: Users can only modify their own data (properties, reviews, comments, saved searches)
3. **Role-Based Access**: Different user types have different permissions
4. **Input Validation**: All inputs are validated using Bean Validation annotations

---

## 🚀 Getting Started

1. **Start the application**: `mvn spring-boot:run`
2. **Register a user**: `POST /api/auth/register`
3. **Login**: `POST /api/auth/login`
4. **Use the token**: Include `Authorization: Bearer <token>` in subsequent requests
5. **Create properties**: `POST /api/properties`
6. **Explore the platform**: Use the various endpoints to interact with properties, reviews, comments, and saved searches

---

## 📝 Notes

- All timestamps are in ISO 8601 format
- Pagination is 0-indexed
- All monetary values are in the base currency (Naira for Nigeria)
- Property coordinates are optional but recommended for location-based features
- Image uploads are handled separately (file upload endpoints not included in this documentation)

---

**Happy coding! 🏠✨**
