# Snowpark ML: Machine Learning in Snowflake

Build, train, and deploy machine learning models directly in Snowflake using Snowpark ML.

## Overview

Snowpark ML provides:
- Native ML capabilities in Snowflake
- Model registry and management
- Feature store integration
- Notebook-based development
- Scalable model training

## Prerequisites

- Snowflake account with Snowpark ML enabled
- Python knowledge
- Basic understanding of machine learning concepts

## Getting Started

### Environment Setup

```python
# Import required libraries
from snowflake.ml.modeling import *
from snowflake.ml.modeling.linear_model import LinearRegression
from snowflake.ml.modeling.ensemble import RandomForestRegressor
from snowflake.ml.modeling.preprocessing import StandardScaler
from snowflake.ml.modeling.model_selection import train_test_split
from snowflake.ml.modeling.metrics import mean_squared_error, r2_score

# Connect to Snowflake
import snowflake.snowpark as snowpark
from snowflake.snowpark import Session

# Create session
session = Session.builder.configs({
    "account": "your_account",
    "user": "your_user",
    "password": "your_password",
    "warehouse": "your_warehouse",
    "database": "your_database",
    "schema": "your_schema"
}).create()
```

## Data Preparation

### Loading and Exploring Data

```python
# Load data from Snowflake table
df = session.table("CUSTOMER_DATA")

# Basic data exploration
print("Dataset shape:", df.count())
print("Columns:", df.columns)
df.show(10)

# Data types and statistics
df.describe().show()

# Check for missing values
df.select([col(c).isNull().sum().alias(c) for c in df.columns]).show()
```

### Feature Engineering

```python
# Create features
df_features = df.select(
    col("age"),
    col("income"),
    col("credit_score"),
    col("years_employed"),
    (col("income") / col("age")).alias("income_per_age"),
    (col("credit_score") / 100).alias("credit_score_normalized"),
    when(col("years_employed") > 10, 1).otherwise(0).alias("senior_employee")
)

# Handle missing values
df_clean = df_features.fillna({
    "age": df_features.select(avg("age")).collect()[0][0],
    "income": df_features.select(avg("income")).collect()[0][0],
    "credit_score": df_features.select(avg("credit_score")).collect()[0][0]
})

df_clean.show(10)
```

## Model Training

### Linear Regression

```python
# Prepare features and target
feature_cols = ["age", "income", "credit_score", "years_employed", 
                "income_per_age", "credit_score_normalized", "senior_employee"]
target_col = "loan_amount"

# Split data
train_df, test_df = train_test_split(df_clean, test_size=0.2, random_state=42)

# Scale features
scaler = StandardScaler(input_cols=feature_cols, output_cols=feature_cols)
train_df_scaled = scaler.fit(train_df).transform(train_df)
test_df_scaled = scaler.transform(test_df)

# Train linear regression model
lr_model = LinearRegression(
    input_cols=feature_cols,
    label_cols=target_col,
    output_cols=["prediction"]
)

lr_model.fit(train_df_scaled)
```

### Random Forest

```python
# Train random forest model
rf_model = RandomForestRegressor(
    input_cols=feature_cols,
    label_cols=target_col,
    output_cols=["prediction"],
    n_estimators=100,
    max_depth=10,
    random_state=42
)

rf_model.fit(train_df_scaled)

# Make predictions
predictions = rf_model.predict(test_df_scaled)
predictions.show(10)
```

## Model Evaluation

### Performance Metrics

```python
# Calculate metrics
mse = mean_squared_error(
    df=predictions,
    y_true_col_names=target_col,
    y_pred_col_names="prediction"
)

r2 = r2_score(
    df=predictions,
    y_true_col_names=target_col,
    y_pred_col_names="prediction"
)

print(f"Mean Squared Error: {mse}")
print(f"R-squared: {r2}")

# Feature importance (for tree-based models)
if hasattr(rf_model, 'feature_importances_'):
    feature_importance = rf_model.feature_importances_
    for feature, importance in zip(feature_cols, feature_importance):
        print(f"{feature}: {importance:.4f}")
```

### Cross-Validation

```python
from snowflake.ml.modeling.model_selection import cross_val_score

# Perform cross-validation
cv_scores = cross_val_score(
    estimator=rf_model,
    df=train_df_scaled,
    cv=5,
    scoring="r2"
)

print(f"Cross-validation scores: {cv_scores}")
print(f"Mean CV score: {cv_scores.mean():.4f} (+/- {cv_scores.std() * 2:.4f})")
```

## Model Registry

### Registering Models

```python
from snowflake.ml.registry import ModelRegistry

# Create model registry
registry = ModelRegistry(session=session)

# Register the model
model_version = registry.log_model(
    model=rf_model,
    model_name="loan_amount_predictor",
    version_name="v1.0",
    description="Random Forest model for predicting loan amounts",
    tags={"environment": "production", "algorithm": "random_forest"}
)

print(f"Model registered with version: {model_version}")
```

### Model Management

```python
# List all models
models = registry.list_models()
for model in models:
    print(f"Model: {model.name}, Versions: {model.versions}")

# Get specific model
model_info = registry.get_model("loan_amount_predictor")
print(f"Model info: {model_info}")

# Deploy model
deployment = registry.deploy(
    model_name="loan_amount_predictor",
    version_name="v1.0",
    target_method="predict",
    options={"warehouse": "ML_WH"}
)

print(f"Model deployed: {deployment}")
```

## Feature Store

### Creating Features

```python
from snowflake.ml.feature_store import FeatureStore

# Create feature store
feature_store = FeatureStore(session=session)

# Define feature group
customer_features = feature_store.create_feature_group(
    name="customer_features",
    description="Customer demographic and financial features",
    entities=[{"name": "customer_id", "type": "int"}],
    features=[
        {"name": "age", "type": "int"},
        {"name": "income", "type": "float"},
        {"name": "credit_score", "type": "int"},
        {"name": "years_employed", "type": "int"}
    ]
)

# Add features to group
customer_features.add_features(
    df=df_clean.select("customer_id", "age", "income", "credit_score", "years_employed")
)
```

### Using Features

```python
# Get features for training
training_features = feature_store.get_features(
    feature_group_names=["customer_features"],
    entity_df=df_clean.select("customer_id")
)

# Use features in model training
rf_model_with_features = RandomForestRegressor(
    input_cols=["age", "income", "credit_score", "years_employed"],
    label_cols=target_col,
    output_cols=["prediction"]
)

rf_model_with_features.fit(training_features)
```

## Advanced Techniques

### Hyperparameter Tuning

```python
from snowflake.ml.modeling.model_selection import GridSearchCV

# Define parameter grid
param_grid = {
    "n_estimators": [50, 100, 200],
    "max_depth": [5, 10, 15],
    "min_samples_split": [2, 5, 10]
}

# Perform grid search
grid_search = GridSearchCV(
    estimator=RandomForestRegressor(
        input_cols=feature_cols,
        label_cols=target_col,
        output_cols=["prediction"]
    ),
    param_grid=param_grid,
    cv=3,
    scoring="r2"
)

grid_search.fit(train_df_scaled)

# Get best parameters
print(f"Best parameters: {grid_search.best_params_}")
print(f"Best score: {grid_search.best_score_}")
```

### Custom Model Development

```python
from snowflake.ml.modeling.base import BaseEstimator
from snowflake.ml.modeling.metrics import mean_squared_error

class CustomRegressor(BaseEstimator):
    def __init__(self, input_cols, label_cols, output_cols, learning_rate=0.01, n_epochs=100):
        self.input_cols = input_cols
        self.label_cols = label_cols
        self.output_cols = output_cols
        self.learning_rate = learning_rate
        self.n_epochs = n_epochs
        self.weights = None
        
    def fit(self, df):
        # Custom training logic
        # This is a simplified example
        self.weights = [0.1] * len(self.input_cols)
        return self
    
    def predict(self, df):
        # Custom prediction logic
        predictions = df.select(
            sum([col(f) * w for f, w in zip(self.input_cols, self.weights)]).alias("prediction")
        )
        return predictions

# Use custom model
custom_model = CustomRegressor(
    input_cols=feature_cols,
    label_cols=target_col,
    output_cols=["prediction"]
)

custom_model.fit(train_df_scaled)
predictions = custom_model.predict(test_df_scaled)
```

## Production Deployment

### Batch Scoring

```python
# Score new data in batch
def batch_score(model_name, input_table, output_table):
    # Get model from registry
    model = registry.get_model(model_name).deploy()
    
    # Load new data
    new_data = session.table(input_table)
    
    # Make predictions
    predictions = model.predict(new_data)
    
    # Save results
    predictions.write.mode("overwrite").save_as_table(output_table)
    
    return f"Scored {predictions.count()} records"

# Run batch scoring
result = batch_score("loan_amount_predictor", "new_customers", "loan_predictions")
print(result)
```

### Real-time Scoring

```python
# Create UDF for real-time scoring
@udf(
    name="predict_loan_amount",
    is_permanent=True,
    stage_location="@ml_stage",
    replace=True
)
def predict_loan_amount(age: int, income: float, credit_score: int, years_employed: int) -> float:
    # Load model (in practice, you'd load from registry)
    # This is a simplified example
    prediction = (age * 0.1 + income * 0.001 + credit_score * 0.01 + years_employed * 0.05) * 1000
    return prediction

# Use UDF in SQL
session.sql("""
    SELECT 
        customer_id,
        predict_loan_amount(age, income, credit_score, years_employed) as predicted_loan_amount
    FROM customer_data
    WHERE customer_id = 12345
""").show()
```

## Best Practices

### 1. Data Quality
- Validate input data before training
- Handle missing values appropriately
- Monitor data drift in production

### 2. Model Management
- Version all models
- Document model performance
- Implement A/B testing for model updates

### 3. Performance Optimization
- Use appropriate warehouse sizes
- Optimize feature engineering
- Monitor resource usage

## Exercises

### Exercise 1: Customer Churn Prediction
Build a classification model to predict customer churn using Snowpark ML.

### Exercise 2: Feature Engineering Pipeline
Create a comprehensive feature engineering pipeline using the feature store.

### Exercise 3: Model Monitoring
Implement model performance monitoring and alerting.

## Next Steps

- Learn about [Cortex ML Forecasting](cortex-forecasting.md)
- Explore [Embeddings and Vector Search](embeddings-vector-search.md)
- Check out [Document AI capabilities](document-ai.md)

## Additional Resources

- [Snowpark ML Documentation](https://docs.snowflake.com/en/developer-guide/snowpark-ml/index.html)
- [Model Registry Guide](https://docs.snowflake.com/en/developer-guide/snowpark-ml/model-registry.html)
- [Feature Store Documentation](https://docs.snowflake.com/en/developer-guide/snowpark-ml/feature-store.html)
