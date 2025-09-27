# Estate Management Platform - Deployment Guide

## 🚀 Quick Start

### Prerequisites
- Java 17 or higher
- Maven 3.6 or higher
- PostgreSQL 12+ (for production)
- Git

### 1. Clone and Build
```bash
git clone <repository-url>
cd estate
mvn clean install
```

### 2. Run Application
```bash
# Development (H2 Database)
mvn spring-boot:run

# Production (PostgreSQL)
mvn spring-boot:run -Dspring.profiles.active=prod
```

### 3. Access Application
- **API Base URL**: `http://localhost:8080/api`
- **H2 Console**: `http://localhost:8080/h2-console`
- **Health Check**: `http://localhost:8080/actuator/health`

---

## 🗄️ Database Configuration

### Development (H2 - Default)
No additional setup required. H2 in-memory database is configured by default.

### Production (PostgreSQL)

1. **Install PostgreSQL**
```bash
# Ubuntu/Debian
sudo apt-get install postgresql postgresql-contrib

# macOS
brew install postgresql
brew services start postgresql

# Windows
# Download from https://www.postgresql.org/download/windows/
```

2. **Create Database**
```sql
CREATE DATABASE estate_db;
CREATE USER estate_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE estate_db TO estate_user;
```

3. **Update Configuration**
```properties
# application-prod.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/estate_db
spring.datasource.username=estate_user
spring.datasource.password=your_password
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=update
```

---

## 🐳 Docker Deployment

### 1. Create Dockerfile
```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/estate-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 2. Build and Run
```bash
# Build Docker image
docker build -t estate-backend .

# Run container
docker run -p 8080:8080 estate-backend

# Run with environment variables
docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/estate_db \
  -e SPRING_DATASOURCE_USERNAME=estate_user \
  -e SPRING_DATASOURCE_PASSWORD=your_password \
  estate-backend
```

### 3. Docker Compose
```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/estate_db
      - SPRING_DATASOURCE_USERNAME=estate_user
      - SPRING_DATASOURCE_PASSWORD=your_password
    depends_on:
      - db
  
  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=estate_db
      - POSTGRES_USER=estate_user
      - POSTGRES_PASSWORD=your_password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
```

```bash
# Run with Docker Compose
docker-compose up -d
```

---

## ☁️ Cloud Deployment

### AWS Elastic Beanstalk

1. **Package Application**
```bash
mvn clean package
```

2. **Create JAR file**
```bash
cp target/estate-0.0.1-SNAPSHOT.jar estate.jar
```

3. **Deploy to Elastic Beanstalk**
```bash
# Install EB CLI
pip install awsebcli

# Initialize EB
eb init

# Create environment
eb create production

# Deploy
eb deploy
```

### Google Cloud Platform

1. **Create app.yaml**
```yaml
runtime: java17
env: standard

handlers:
- url: /.*
  script: auto
```

2. **Deploy**
```bash
gcloud app deploy
```

### Heroku

1. **Create Procfile**
```
web: java -jar target/estate-0.0.1-SNAPSHOT.jar
```

2. **Deploy**
```bash
# Install Heroku CLI
# Create Heroku app
heroku create estate-platform

# Set environment variables
heroku config:set SPRING_DATASOURCE_URL=jdbc:postgresql://...
heroku config:set SPRING_DATASOURCE_USERNAME=...
heroku config:set SPRING_DATASOURCE_PASSWORD=...

# Deploy
git push heroku main
```

---

## 🔧 Environment Configuration

### Development
```properties
# application-dev.properties
spring.profiles.active=dev
spring.datasource.url=jdbc:h2:mem:estate_db
spring.jpa.hibernate.ddl-auto=create-drop
logging.level.com.example.estate=DEBUG
```

### Production
```properties
# application-prod.properties
spring.profiles.active=prod
spring.datasource.url=jdbc:postgresql://localhost:5432/estate_db
spring.jpa.hibernate.ddl-auto=update
logging.level.com.example.estate=INFO
logging.level.org.springframework.security=WARN
```

### Environment Variables
```bash
# Database
export SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/estate_db
export SPRING_DATASOURCE_USERNAME=estate_user
export SPRING_DATASOURCE_PASSWORD=your_password

# JWT
export JWT_SECRET=your_jwt_secret_key
export JWT_EXPIRATION=86400000

# Email
export MAIL_USERNAME=your_email@gmail.com
export MAIL_PASSWORD=your_app_password
```

---

## 📊 Monitoring and Logging

### Application Monitoring
```properties
# Enable Actuator endpoints
management.endpoints.web.exposure.include=health,info,metrics,prometheus
management.endpoint.health.show-details=always
```

### Logging Configuration
```xml
<!-- logback-spring.xml -->
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/estate.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/estate.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <root level="INFO">
        <appender-ref ref="STDOUT" />
        <appender-ref ref="FILE" />
    </root>
</configuration>
```

---

## 🔒 Security Configuration

### JWT Configuration
```properties
# Strong JWT secret (use environment variable in production)
jwt.secret=your_very_strong_secret_key_here
jwt.expiration=86400000
```

### CORS Configuration
```java
@Bean
public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedOriginPatterns(Arrays.asList("*"));
    configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    configuration.setAllowedHeaders(Arrays.asList("*"));
    configuration.setAllowCredentials(true);
    return source;
}
```

### SSL/HTTPS (Production)
```properties
# Enable HTTPS
server.port=8443
server.ssl.key-store=classpath:keystore.p12
server.ssl.key-store-password=your_password
server.ssl.key-store-type=PKCS12
server.ssl.key-alias=tomcat
```

---

## 📈 Performance Optimization

### Database Optimization
```properties
# Connection pooling
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=20000

# JPA optimization
spring.jpa.properties.hibernate.jdbc.batch_size=20
spring.jpa.properties.hibernate.order_inserts=true
spring.jpa.properties.hibernate.order_updates=true
```

### Caching
```java
@EnableCaching
@Configuration
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager() {
        return new ConcurrentMapCacheManager("properties", "users", "templates");
    }
}
```

---

## 🧪 Testing

### Unit Tests
```bash
mvn test
```

### Integration Tests
```bash
mvn verify
```

### Load Testing
```bash
# Using Apache Bench
ab -n 1000 -c 10 http://localhost:8080/api/properties

# Using JMeter
# Create test plan and run performance tests
```

---

## 🚨 Troubleshooting

### Common Issues

1. **Database Connection Issues**
   - Check database credentials
   - Ensure database is running
   - Verify network connectivity

2. **JWT Token Issues**
   - Check JWT secret configuration
   - Verify token expiration settings
   - Ensure proper token format

3. **CORS Issues**
   - Update CORS configuration
   - Check allowed origins
   - Verify preflight requests

4. **File Upload Issues**
   - Check file size limits
   - Verify file type restrictions
   - Ensure proper multipart configuration

### Logs Location
- **Development**: Console output
- **Production**: `logs/estate.log`

### Health Checks
```bash
# Application health
curl http://localhost:8080/actuator/health

# Database health
curl http://localhost:8080/actuator/health/db

# Disk space
curl http://localhost:8080/actuator/health/diskSpace
```

---

## 📞 Support

- **Documentation**: [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
- **Issues**: [GitHub Issues](https://github.com/your-repo/estate/issues)
- **Email**: support@estateplatform.com

---

## 📚 API Documentation

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | User login |
| POST | `/api/auth/refresh` | Refresh JWT token |

### User Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users` | Get all users |
| GET | `/api/users/{id}` | Get user by ID |
| GET | `/api/users/email/{email}` | Get user by email |
| GET | `/api/users/type/{userType}` | Get users by type |
| POST | `/api/users` | Create new user |
| PUT | `/api/users/{id}` | Update user |
| DELETE | `/api/users/{id}` | Delete user |

### Property Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/properties` | Get all properties (paginated) |
| GET | `/api/properties/{id}` | Get property by ID |
| GET | `/api/properties/user/{userId}` | Get properties by user |
| GET | `/api/properties/type/{propertyType}` | Get properties by type |
| GET | `/api/properties/listing/{listingType}` | Get properties by listing type |
| GET | `/api/properties/city/{city}` | Get properties by city |
| GET | `/api/properties/state/{state}` | Get properties by state |
| GET | `/api/properties/featured` | Get featured properties |
| GET | `/api/properties/search?keyword={keyword}` | Search properties |
| GET | `/api/properties/filter` | Advanced property filtering |
| POST | `/api/properties` | Create new property |
| PUT | `/api/properties/{id}` | Update property |
| DELETE | `/api/properties/{id}` | Delete property |

### Advanced Filtering

The `/api/properties/filter` endpoint supports multiple query parameters:

- `minPrice` / `maxPrice`: Price range
- `city` / `state`: Location filters
- `propertyType`: Type of property (APARTMENT, HOUSE, etc.)
- `listingType`: Listing type (BUY, SELL, RENT, LEASE)
- `minBedrooms` / `maxBedrooms`: Bedroom count range
- `minBathrooms` / `maxBathrooms`: Bathroom count range
- `page` / `size`: Pagination parameters

## 🔐 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Role-based Access Control**: Different access levels for different user types
- **Password Encryption**: BCrypt password hashing
- **CORS Configuration**: Cross-origin resource sharing support
- **Input Validation**: Comprehensive request validation

## 🏢 User Types

The platform supports five user types:

1. **LANDLORD**: Property owners who list properties for rent/sale
2. **AGENT**: Real estate agents managing multiple listings
3. **TENANT**: Users looking for rental properties
4. **INVESTOR**: Users interested in property investment
5. **ADMIN**: Platform administrators

**Happy Deploying! 🚀**
