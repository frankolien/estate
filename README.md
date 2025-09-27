# Estate Management Platform 

A comprehensive real estate management platform built with Spring Boot that provides all-in-one solutions for buying, selling, renting, and investing in real estate properties.

## 🏗️ Architecture Overview

This backend implements a multi-tier real estate platform with the following key features:

### Core Features (Tier 1)
- **Property Listings**: Buy, Sell, Lease, Rent properties
- **Categories & Filters**: Location, Purpose, Status-based filtering
- **Basic Search**: Keyword and filter combination search

### Trust & Transparency (Tier 2)
- **Verification System**: Verified property badges and agent verification
- **Legal Templates**: Standard tenancy agreements and contracts
- **Role-based Dashboards**: Different interfaces for Landlords, Agents, Tenants, Investors

### Growth & Engagement (Tier 3)
- **Saved Searches & Alerts**: Smart notifications for property matches
- **Media-rich Listings**: Photos, video tours, VR/3D integration support
- **Payment Integration**: Escrow services and rent collection
- **Social Features**: Property feeds, likes, comments, reviews, follows

### Education & Market Authority (Tier 4)
- **Educational Content**: Beginner courses and market insights
- **News & Analytics**: Market trends and policy updates

### Financial Expansion (Tier 5)
- **Investment Tools**: ROI calculators and yield projections
- **Fractional Ownership**: Tokenization support for luxury properties

### AI-Powered Features (Tier 6)
- **AI Broker**: Concierge, Tutor, and Investor modes
- **Personalized Recommendations**: AI-driven property suggestions

## 🛠️ Technology Stack

- **Framework**: Spring Boot 3.5.6
- **Database**: H2 (Development), PostgreSQL (Production)
- **Security**: Spring Security with JWT
- **ORM**: Spring Data JPA with Hibernate
- **Validation**: Bean Validation (Jakarta)
- **Documentation**: OpenAPI/Swagger (planned)
- **Testing**: JUnit 5, TestContainers
- **Build Tool**: Maven


## 🚀 Getting Started

### Prerequisites

- Java 17 or higher
- Maven 3.6 or higher
- PostgreSQL (for production)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd estate
   ```

2. **Build the project**
   ```bash
   mvn clean install
   ```

3. **Run the application**
   ```bash
   mvn spring-boot:run
   ```

4. **Access the application**
   - API Base URL: `http://localhost:8080`
   - H2 Console: `http://localhost:8080/h2-console`
   - Actuator Health: `http://localhost:8080/actuator/health`

### Database Configuration

The application uses H2 in-memory database for development. To use PostgreSQL in production:

1. Update `application.properties`:
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/estate_db
   spring.datasource.username=your_username
   spring.datasource.password=your_password
   spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
   ```


## 📊 Key Features Implemented

### Property Management
- ✅ CRUD operations for properties
- ✅ Advanced search and filtering
- ✅ Property verification system
- ✅ Featured property management
- ✅ View count tracking

### User Management
- ✅ User registration and authentication
- ✅ Email verification system
- ✅ Password reset functionality
- ✅ User profile management
- ✅ Role-based access control

### Social Features
- ✅ Property likes and comments
- ✅ Property reviews and ratings
- ✅ Saved searches with notifications
- ✅ User following system (foundation)

### Media Management
- ✅ Property image upload and management
- ✅ Primary image designation
- ✅ Image ordering and captions

## 🔄 Data Flow

1. **User Registration**: Users register with email verification
2. **Property Listing**: Verified users can list properties
3. **Search & Discovery**: Advanced filtering and search capabilities
4. **Social Interaction**: Users can like, comment, and review properties
5. **Saved Searches**: Users can save search criteria and get notifications
6. **Verification Process**: Properties and users can be verified for trust

## 🧪 Testing

Run tests using Maven:

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=PropertyServiceTest

# Run with coverage
mvn test jacoco:report
```

## 🚀 Deployment

### Docker Deployment

1. **Create Dockerfile**:
   ```dockerfile
   FROM openjdk:17-jdk-slim
   COPY target/estate-0.0.1-SNAPSHOT.jar app.jar
   EXPOSE 8080
   ENTRYPOINT ["java", "-jar", "/app.jar"]
   ```

2. **Build and run**:
   ```bash
   docker build -t estate-backend .
   docker run -p 8080:8080 estate-backend
   ```

### Production Considerations

- Configure PostgreSQL database
- Set up proper JWT secrets
- Configure email service for notifications
- Set up file storage for property images
- Configure monitoring and logging
- Set up load balancing for high availability

## 🔮 Future Enhancements

### Planned Features
- [ ] Payment integration (Paystack, Flutterwave)
- [ ] Real-time notifications (WebSocket)
- [ ] Advanced analytics dashboard
- [ ] Mobile app API optimization
- [ ] AI-powered recommendations
- [ ] Blockchain integration for fractional ownership
- [ ] Video tour integration
- [ ] 3D property visualization

### Performance Optimizations
- [ ] Redis caching for frequently accessed data
- [ ] Database indexing optimization
- [ ] CDN integration for media files
- [ ] Elasticsearch for advanced search
- [ ] Microservices architecture migration

## 📝 Legal Compliance

The platform is designed to comply with Nigerian regulations:

- **NDPR Compliance**: Data protection and privacy
- **CAMA Registration**: Corporate registration requirements
- **Land Use Acts**: Property title validation
- **SEC Regulations**: Investment platform compliance
- **Consumer Protection**: Truth in advertising compliance

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support


---

**Built with ❤️ for the Nigerian real estate market**
