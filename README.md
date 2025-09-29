# PL/SQL Window Functions - Celine Baby Shop Analysis

**Student:** Umukamisha Celine  
**ID:** 27400   
**Course:** Database Development with PL/SQL  
**Assignment:** Individual Assignment I - Window Functions Mastery Project

## Step 1: Problem Definition

### Business Context
Celine Baby Shop operates 8 retail locations across Rwanda (Kigali, Huye, Musanze, Rubavu) specializing in baby products including clothing, toys, feeding supplies, and nursery furniture.

### Data Challenge
Management needs to identify which baby products perform best in each region and season, track monthly sales patterns to optimize inventory, analyze customer purchasing behavior to understand repeat buyers vs. one-time shoppers, and segment customers based on spending patterns for targeted marketing campaigns.

### Expected Outcome
Strategic decisions on inventory allocation by region, seasonal stocking patterns, customer retention strategies, and personalized marketing approaches to increase revenue and customer loyalty.

## Step 2: Success Criteria

• Top 5 baby products per region/quarter → RANK() to identify best-sellers by location  
• Running monthly sales totals → SUM() OVER() to track cumulative performance  
• Month-over-month growth analysis → LAG()/LEAD() to identify seasonal trends  
• Customer spending quartiles → NTILE(4) to segment customers (Premium Parents, Regular Families, etc.)  
• 3-month moving averages → AVG() OVER() to smooth seasonal fluctuations

## Step 3: Database Schema - Celine Baby Shop

### Database Overview
- **Database Name:** celinebabyshop
- **Purpose:** Baby products retail business across Rwanda
- **Tables Count:** 3 main tables
- **Relationships:** 2 one-to-many relationships

### Table 1: CUSTOMERS
**Table Purpose:** Customer information and regional data  
**Key Columns:** customer_id (PK), customer_name, region  
**Example Row:** 1001, 'Uwizeye', '0781234567', 'Kigali', '2024-01-15', 6

#### Complete Column Specifications

| Column Name | Data Type | Constraints | Purpose | Example Value |
|-------------|-----------|-------------|---------|---------------|
| customer_id | INTEGER | PRIMARY KEY | Unique customer identifier | 1001 |
| customer_name | VARCHAR(100) | NOT NULL | Customer full name | 'Uwizeye Jean' |
| phone | VARCHAR(20) | | Customer phone number | '0781234567' |
| region | VARCHAR(50) | | Customer region (Kigali, Huye, Musanze, Rubavu) | 'Kigali' |
| registration_date | DATE | | Customer registration date | '2024-01-15' |
| baby_age_months | INTEGER | | Baby's age in months for targeted marketing | 6 |

```sql
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    region VARCHAR(50),
    registration_date DATE,
    baby_age_months INTEGER
);
```

### Table 2: PRODUCTS
**Table Purpose:** Product catalog with categories, brands, and pricing  
**Key Columns:** product_id (PK), product_name, category, unit_price  
**Example Row:** 2001, 'Baby Onesie Set', 'Clothing', 'BabyWear', 15000.00, '0-6 months'

#### Complete Column Specifications

| Column Name | Data Type | Constraints | Purpose | Example Value |
|-------------|-----------|-------------|---------|---------------|
| product_id | INTEGER | PRIMARY KEY | Unique product identifier | 2001 |
| product_name | VARCHAR(100) | NOT NULL | Product name | 'Baby Onesie Set' |
| category | VARCHAR(50) | | Product category | 'Clothing' |
| brand | VARCHAR(50) | | Product brand/manufacturer | 'BabyWear' |
| unit_price | NUMERIC(10,2) | | Unit price in RWF | 15000.00 |
| age_group | VARCHAR(20) | | Target age group for baby products | '0-6 months' |

```sql
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    brand VARCHAR(50),
    unit_price NUMERIC(10,2),
    age_group VARCHAR(20)
);
```

### Table 3: TRANSACTIONS
**Table Purpose:** Sales records linking customers and products with complete transaction details  
**Key Columns:** transaction_id (PK), customer_id (FK), product_id (FK), sale_date, total_amount  
**Example Row:** 3001, 1001, 2001, '2024-03-15', 2, 30000.00, 'Kigali Main Store'

#### Complete Column Specifications

| Column Name | Data Type | Constraints | Purpose | Example Value |
|-------------|-----------|-------------|---------|---------------|
| transaction_id | INTEGER | PRIMARY KEY | Unique transaction identifier | 3001 |
| customer_id | INTEGER | FOREIGN KEY | References customers.customer_id | 1001 |
| product_id | INTEGER | FOREIGN KEY | References products.product_id | 2001 |
| sale_date | DATE | | Date when transaction occurred | '2024-03-15' |
| quantity | INTEGER | | Number of items purchased | 2 |
| total_amount | NUMERIC(10,2) | | Total amount paid (quantity × unit_price) | 30000.00 |
| store_location | VARCHAR(100) | | Store where purchase was made | 'Kigali Main Store' |

```sql
CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    product_id INTEGER,
    sale_date DATE,
    quantity INTEGER,
    total_amount NUMERIC(10,2),
    store_location VARCHAR(100),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### Foreign Key Relationships

| Parent Table | Child Table | Relationship | Foreign Key | Business Rule |
|--------------|-------------|--------------|-------------|---------------|
| CUSTOMERS | TRANSACTIONS | One-to-Many (1:M) | customer_id | One customer can make multiple purchases |
| PRODUCTS | TRANSACTIONS | One-to-Many (1:M) | product_id | One product can be sold in multiple transactions |

### CELINE BABY SHOP DATABASE STRUCTURE
### ENTITY RELATIONSHIP DIAGRAM

```
[CUSTOMERS]
- customer_id (Primary Key)
- customer_name
- phone
- region
- registration_date
- baby_age_months
|
| One Customer
|
v Many Transactions
[TRANSACTIONS]
- transaction_id (Primary Key)
- customer_id (Foreign Key → CUSTOMERS.customer_id)
- product_id (Foreign Key → PRODUCTS.product_id)
- sale_date
- quantity
- total_amount
- store_location

^
| Many Transactions
|
| One Product
[PRODUCTS]
- product_id (Primary Key)
- product_name
- category
- brand
- unit_price
- age_group
```

**Relationship Description:**
• CUSTOMERS (1) to TRANSACTIONS (Many): One customer can make multiple purchases
• PRODUCTS (1) to TRANSACTIONS (Many): One product can be sold in multiple transactions  
• TRANSACTIONS serves as the junction table linking customers and products

## Step 4: Window Functions Implementation

### CATEGORY 1: RANKING FUNCTIONS

#### Query 1.1: ROW_NUMBER() Top customers by revenue
**Use case:** Identify top Number customers by revenue for VIP program

![ROW_NUMBER Screenshot](Screenshot/row%20number.PNG))

**Interpretation:** ROW_NUMBER() assigns unique sequential ranks to customers by revenue, enabling precise top-N selection. Customer "Uwizeye" ranks #1 with highest total spending, making them prime candidate for VIP program. This ranking helps identify exact customer hierarchy without ties.

#### Query 1.2: RANK() Product ranking with ties allowed
**Use case:** Rank products by sales volume, handling ties appropriately

![RANK and DENSE_RANK Screenshot](Screenshot/rank%20dense.PNG)

**Interpretation:** RANK() handles tied products by giving them the same rank and skipping subsequent ranks, while DENSE_RANK() doesn't skip ranks. Products with identical sales volumes receive equal ranking, crucial for fair performance evaluation and inventory decisions.

#### Query 1.3: PERCENT_RANK() Customer percentile ranking
**Use case:** Segment customers into percentiles for marketing campaigns

![PERCENT_RANK Screenshot](Screenshot/percent%20rank.PNG)

**Interpretation:** PERCENT_RANK() creates percentile-based customer segmentation from 0 to 1, enabling precise marketing targeting. Top 25% customers represent highest-value segment for premium campaigns, while bottom 25% need retention strategies to increase engagement.

### CATEGORY 2: AGGREGATE FUNCTIONS

#### Query 2.1: SUM() OVER() Running totals and cumulative analysis
**Use case:** Track cumulative sales performance over time

![SUM OVER Screenshot](Screenshot/aggregate%20sum.PNG)

**Interpretation:** Running totals show cumulative revenue growth over time, essential for cash flow monitoring. ROWS frame processes individual transactions sequentially, while RANGE frame handles same-date transactions together, providing different analytical perspectives for business performance tracking.

#### Query 2.2: AVG() OVER() Moving averages with ROWS vs RANGE
**Use case:** Smooth out daily sales fluctuations for trend analysis

![AVG OVER Screenshot](Screenshot/aggregate%20avg.PNG)

**Interpretation:** ROWS-based moving averages smooth transaction-level volatility by averaging fixed number of records, while RANGE-based averages use time periods regardless of transaction count. Three-day averages reveal underlying sales trends by filtering out daily fluctuations.

#### Query 2.3: MIN() and MAX() OVER() Extreme value analysis
**Use case:** Identify minimum and maximum sales within time periods

![MIN MAX Screenshot](Screenshot/min%20max.PNG)

**Interpretation:** Regional MIN/MAX analysis tracks extreme values within each region over time, helping identify best and worst performing transactions. This reveals regional sales patterns and helps set realistic targets based on historical performance ranges.

### CATEGORY 3: NAVIGATION FUNCTIONS

#### Query 3.1: LAG() Previous period comparison
**Use case:** Calculate month-over-month growth percentages

![LAG Growth Screenshot](Screenshot/navigation%20lag.PNG)

**Interpretation:** LAG() enables month-over-month growth calculations by accessing previous month's revenue within current row. Growth percentages reveal business momentum trends, with positive values indicating expansion and negative values showing contraction requiring management attention.

#### Query 3.2: LEAD() Forward-looking analysis
**Use case:** Analyze upcoming purchase patterns and customer behavior

![LEAD Patterns Screenshot](Screenshot/lead%20patterns.PNG)

**Interpretation:** LEAD() reveals customer purchase frequency by showing days between consecutive purchases. Customers with consistent short intervals represent high engagement, while long gaps indicate potential churn risks requiring retention campaigns.

#### Query 3.3: Combined LAG() and LEAD() Complete navigation analysis
**Use case:** Customer purchase interval analysis for retention strategies

![LAG LEAD Combined Screenshot](Screenshot/laglead%20combined.PNG)

**Interpretation:** Combined LAG/LEAD analysis provides complete customer purchase timeline view, showing both backward and forward purchase intervals. This reveals customer loyalty patterns and helps predict optimal timing for targeted marketing campaigns.

### CATEGORY 4: DISTRIBUTION FUNCTIONS

#### Query 4.1: NTILE(4) Customer quartile segmentation
**Use case:** Segment customers into quartiles for marketing campaigns

![NTILE Quartiles Screenshot](Screenshot/ntile%20quartiles.PNG)

**Interpretation:** NTILE(4) divides customers into equal-sized quartiles based on spending, creating balanced segments for targeted marketing. Premium customers (Q4) receive exclusive offers, while Entry Level (Q1) customers get acquisition-focused campaigns to increase engagement.

#### Query 4.2: CUME_DIST() Cumulative distribution analysis
**Use case:** Percentile ranking for performance benchmarking

![CUME_DIST Screenshot](Screenshot/cumedist%20percentiles.PNG)

**Interpretation:** CUME_DIST() provides precise percentile rankings from 0 to 1, showing what percentage of products perform below each item. Products in top 20% (≥0.8) are star performers deserving premium shelf space and marketing investment.

#### Query 4.3: Combined NTILE() and CUME_DIST() Complete distribution analysis
**Use case:** Comprehensive customer segmentation combining quartiles and percentiles

![Combined Distribution Screenshot](Screenshot/distribution%20combined.PNG)

**Interpretation:** Combined distribution analysis reveals customer behavior patterns across multiple dimensions. High-spending, high-frequency customers in Q4 quartiles represent ideal customer profile, while mismatched quartiles (high spend, low frequency) indicate different engagement strategies needed.

### COMPREHENSIVE BUSINESS SUMMARY QUERY
**Summary analysis combining all window function categories**
**Use case:** Executive dashboard with complete analytical overview

![Comprehensive Business Summary Screenshot](Screenshot/comprehensivebusiness%20summary.PNG)

**Interpretation:** This executive summary demonstrates all four window function categories working together to provide complete regional performance analysis. Rankings identify top regions, aggregates show cumulative impact, and distributions reveal relative performance positioning for strategic decision-making.

## Step 6: Analysis Framework for Celine Baby Shop

### Layer 1: Descriptive Analysis- What Happened?

#### Regional Performance Patterns
• Kigali Dominance: Captures 57% of total revenue (114,000 out of 199,000 RWF) with 4 customers  
• Rural Market Distribution: Huye, Musanze, and Rubavu each contribute 12.5-17.5% with single customers  
• Customer Concentration: 4 out of 7 customers (57%) are located in Kigali region  
• Transaction Value Range: Individual transactions vary from 24,000 to 30,000 RWF, showing consistent pricing

#### Customer Spending Behavior
• Top Performer: Customer "Uwizeye" leads with highest individual spending  
• Spending Quartiles: Clear segmentation from Premium Parents (Q4) to Entry Level (Q1)  
• Purchase Frequency: Varies significantly across customers and regions  
• Geographic Distribution: Urban customers show higher engagement rates

#### Product Performance Trends
• Category Performance: Baby products show consistent demand across all regions  
• Seasonal Indicators: Transaction patterns suggest stable year-round demand  
• Price Consistency: Minimal price variation across regions indicates standardized pricing strategy

### Layer 2: Diagnostic Analysis- Why These Patterns Exist?

#### Root Cause Analysis

**Urban Market Advantages:**
• Population Density: Kigali's higher population density creates larger customer pool  
• Economic Factors: Urban customers typically have higher disposable income for baby products  
• Accessibility: Better transportation and logistics infrastructure in urban areas  
• Brand Awareness: Greater marketing reach and brand recognition in metropolitan areas

**Rural Market Challenges:**
• Limited Market Penetration: Single customers per rural region indicate untapped potential  
• Geographic Barriers: Distance and transportation costs may limit shopping frequency  
• Economic Constraints: Rural customers may have different spending patterns and priorities  
• Competition: Local competitors may have stronger presence in rural market

**Customer Behavior Drivers:**
• Life Stage Alignment: Baby product purchases correlate with specific family life stages  
• Regional Income Disparities: Spending patterns reflect regional economic differences  
• Cultural Preferences: Regional preferences may influence product selection and purchase timing  
• Service Accessibility: Store locations and services availability impact customer engagement

#### Comparative Performance Analysis
• Kigali vs Rural Regions: 4:1 customer ratio suggests successful urban strategy but missed rural opportunities  
• Revenue per Customer: Kigali customers generate higher individual revenue streams  
• Market Saturation: Urban market may be approaching saturation while rural markets remain underdeveloped

### Layer 3: Prescriptive Analysis- Strategic Recommendations

#### Immediate Actions (Next 3 Months)

**1. Rural Market Expansion Strategy**
• Market Research Initiative: Conduct demographic studies in Huye, Musanze, and Rubavu to identify optimal expansion locations  
• Local Partnership Development: Establish partnerships with local retailers or community centers for market entry  
• Targeted Marketing Campaigns: Develop region-specific marketing materials addressing local cultural preferences and needs

**2. Customer Segmentation Optimization**
• VIP Program Launch: Implement loyalty program for top quartile customers (Q4) with exclusive products and services  
• Entry-Level Engagement: Create acquisition campaigns for Q1 customers with starter bundles and payment plans  
• Mid-Tier Retention: Develop retention strategies for Q2-Q3 customers to prevent churn and encourage upgrade

**3. Inventory Management Refinement**
• Regional Allocation Model: Implement 60-40 split (Kigali-Rural) based on performance data  
• Seasonal Adjustment: Prepare inventory buffers for potential seasonal demand fluctuations  
• Fast-Moving Items Priority: Prioritize top-performing products identified through ranking analysis

#### Medium-Term Strategies (6-12 Months)

**4. Geographic Expansion Plan**
• New Location Analysis: Use window function insights to identify optimal locations for new stores  
• Hub-and-Spoke Model: Establish Kigali as distribution hub with satellite locations in rural areas  
• Mobile Service Units: Deploy mobile baby product services for remote rural communities

**5. Product Portfolio Optimization**
• Regional Customization: Develop region-specific product lines based on local preferences and purchasing power  
• Premium Product Introduction: Launch high-end baby products for top-tier Kigali customers  
• Value Product Lines: Create affordable product options for price-sensitive rural markets

**6. Customer Relationship Management**
• Predictive Analytics: Use LAG/LEAD analysis to predict customer purchase cycles and timing  
• Personalized Marketing: Implement percentile-based targeting for customized promotional campaigns  
• Retention Programs: Develop early warning systems for customers showing decreased engagement patterns

#### Long-Term Vision (12+ Months)

**7. Market Leadership Consolidation**
• Regional Dominance: Achieve market leadership in each region through targeted strategies  
• Digital Integration: Develop e-commerce platform with region-specific delivery solutions  
• Brand Ecosystem: Create comprehensive baby care ecosystem including products, services, and educational content

**8. Performance Monitoring Framework**
• Real-Time Analytics: Implement dashboard using window functions for continuous performance monitoring  
• Quarterly Reviews: Regular assessment of regional performance using ranking and distribution functions  
• Predictive Modeling: Advanced analytics for forecasting demand patterns and customer behavior

#### Success Metrics and KPIs

**Revenue Targets:**
Increase rural region revenue by 40% within 12 month  
Maintain Kigali growth rate of 15% annually  
Achieve 25% increase in revenue per customer across all regions

**Customer Engagement:**
Reduce customer acquisition cost in rural areas by 30%  
Increase customer lifetime value by 20% through targeted campaigns  
Achieve 85% customer retention rate in top quartile segments

**Operational Excellence:**
Optimize inventory turnover by 25% using predictive analytics  
Reduce stockouts by 40% through improved demand forecasting  
Achieve 95% on-time delivery across all region

### Business Impact Summary

#### Strategic Advantages Gained
1. Data-Driven Decision Making: Window functions provide precise insights for strategic  
2. Competitive Intelligence: Ranking analysis reveals market positioning and opportunities  
3. Customer-Centric Approach: Distribution functions enable sophisticated customer segmentation  
4. Operational Efficiency: Aggregate functions optimize inventory and resource allocation

#### Expected Outcomes
1. Revenue Growth: Projected 35% increase in total revenue within 18 months  
2. Market Expansion: Successful penetration of underserved rural markets  
3. Customer Satisfaction: Improved customer experience through personalized services  
4. Operational Excellence: Enhanced efficiency through data-driven operations

#### Risk Mitigation
1. Market Volatility: Diversified geographic presence reduces regional risk concentration  
2. Competition Response: Advanced analytics provide early warning of competitive threats  
3. Economic Fluctuations: Multi-tier customer segments provide revenue stability  
4. Supply Chain Disruptions: Optimized inventory management reduces supply risks

### Conclusion

The comprehensive window function analysis reveals significant opportunities for Celine Baby Shop's growth and optimization. The data-driven insights support a strategic pivot towards balanced regional development while maintaining urban market leadership. Success depends on executing targeted regional strategies, implementing sophisticated customer segmentation, and maintaining operational excellence through continuous analytics monitoring.

The window function implementation demonstrates not only technical mastery but also practical business value, providing a robust foundation for sustainable competitive advantage in Rwanda's baby products market.

## References

1. PostgreSQL Documentation Team. (2024). PostgreSQL 16 Documentation: Window Functions. https://www.postgresql.org/docs/current/tutorial-window.html
2. Markus Winand. (2023). Modern SQL: Window Functions. https://modern-sql.com/feature/window-functions
3. Ben-Gan, Itzik. (2022). T-SQL Window Functions: For Data Analysis and Beyond. https://www.microsoftpressstore.com/store/t-sql-window-functions-for-data-analysis-and-beyond-9780735685048
4. PostgreSQL Tutorial. (2024). PostgreSQL Window Functions Tutorial. https://www.postgresqltutorial.com/postgresql-window-function/
5. Fehily, Chris. (2023). SQL: Visual QuickStart Guide. https://www.peachpit.com/store/sql-visual-quickstart-guide-9780134858368
6. Davenport, Thomas H., & Harris, Jeanne G. (2023). Competing on Analytics. https://hbr.org/product/competing-on-analytics-updated-with-a-new-introduction/10138
7. Kumar, V., & Reinartz, Werner. (2022). Customer Relationship Management. https://link.springer.com/book/10.1007/978-3-662-65466-5
8. Kotler, Philip, & Keller, Kevin Lane. (2024). Marketing Management. https://www.pearson.com/en-us/subject-catalog/p/marketing-management/P200000003484
9. Kimball, Ralph, & Ross, Margy. (2023). The Data Warehouse Toolkit. https://www.wiley.com/en-us/The+Data+Warehouse+Toolkit%3A+The+Definitive+Guide+to+Dimensional+Modeling%2C+3rd+Edition-p-9781118530801
10. Silberschatz, Abraham, et al. (2024). Database System Concepts. https://www.mheducation.com/highered/product/database-system-concepts-silberschatz-galvin/M9781260084504.html



