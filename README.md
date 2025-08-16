Cloud-Based Big Data Analytics Pipeline for E-Commerce User Behavior Analysis

This project implements a cloud-native analytics pipeline for large-scale e-commerce data. It leverages AWS services (S3, Glue, Athena, SageMaker) and Power BI to ingest, clean, transform, analyze, and visualize user behavior data, enabling insights into customer patterns, inventory optimization, and personalized recommendations.

📌 Project Overview

The pipeline addresses key problems in modern retail analytics:

Data Ingestion & Storage: Raw event, item, and category data stored in Amazon S3.

Data Cleaning & Quality Enforcement: Schema validation, null handling, and malformed row management using AWS Glue (PySpark).

Data Transformation & Feature Engineering: Aggregations, timestamp handling, and feature creation for ML models.

Machine Learning (Fraud & Anomaly Detection): Isolation Forest model in SageMaker detects unusual user behavior.

Visualization & Insights: Power BI dashboards display purchase trends, product performance, recommendation effectiveness, and user segmentation.

🛠️ Tech Stack

AWS S3 → Data lake for raw and processed datasets

AWS Glue → ETL (PySpark) for cleaning & transformation

Amazon Athena → SQL queries over partitioned Parquet data

Amazon SageMaker → ML model training (Isolation Forest)

Power BI → Dashboards for business insights

📊 Dashboards

Purchase Trends → Daily purchases, product frequency, conversion funnel

Recommendation Analysis → Top co-viewed products, conversion rates, category performance

User Segmentation → Engagement & purchase behavior by customer segment

🔒 Security & IAM

Role-based access for Glue, Athena, SageMaker, and Power BI

S3 bucket policies with least-privilege

VPC isolation & private endpoints

Encryption (SSE-S3/KMS, TLS 1.2+)

📂 Repository Structure
├── data/              # Sample cleaned datasets  
├── notebooks/         # Jupyter notebooks (EDA, ML training)  
├── scripts/           # PySpark ETL scripts for Glue  
├── athena-queries/    # SQL queries used in analysis  
├── dashboards/        # Power BI .pbix files  
├── report/            # Final project report & appendix  
└── README.md          # Project documentation

📑 Appendix

Appendix A → Detailed pipeline diagrams

Appendix B → Key Power BI dashboards

Appendix C → GitHub Repository Files

🚀 Future Work

Automating forecasts with AWS Forecast

Scaling recommendation models with Amazon Personalize

Expanding dashboard interactivity with real-time Athena queries.
