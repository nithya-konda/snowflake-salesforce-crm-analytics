import pandas as pd
import numpy as np
from faker import Faker
from datetime import datetime, timedelta
import random
import os

# -----------------------------
# Setup
# -----------------------------

fake = Faker()

random.seed(42)
np.random.seed(42)

os.makedirs("data", exist_ok=True)

# -----------------------------
# Accounts
# -----------------------------

industries = [
    "Technology",
    "Manufacturing",
    "Healthcare",
    "Retail",
    "Banking",
    "Telecom"
]

segments = [
    "Enterprise",
    "Mid-Market",
    "SMB"
]

accounts = []

for i in range(1, 1001):

    accounts.append({
        "Account_ID": f"ACC{i:04}",
        "Account_Name": fake.company(),
        "Industry": random.choice(industries),
        "Segment": random.choice(segments),
        "Country": fake.country(),
        "Created_Date": fake.date_between(
            start_date='-3y',
            end_date='today'
        )
    })

accounts_df = pd.DataFrame(accounts)

# -----------------------------
# Agents
# -----------------------------

teams = [
    "Technical Support",
    "Product Support",
    "Billing",
    "Escalations"
]

agents = []

for i in range(1, 101):

    agents.append({
        "Agent_ID": f"AG{i:03}",
        "Agent_Name": fake.name(),
        "Team": random.choice(teams),
        "Manager": fake.name(),
        "Location": fake.country(),
        "Hire_Date": fake.date_between(
            start_date='-5y',
            end_date='today'
        )
    })

agents_df = pd.DataFrame(agents)

# -----------------------------
# Products
# -----------------------------

categories = [
    "CRM",
    "Analytics",
    "Security",
    "Integration",
    "AI"
]

products = []

for i in range(1, 31):

    products.append({
        "Product_ID": f"PROD{i:03}",
        "Product_Name": f"Product {i}",
        "Product_Category": random.choice(categories)
    })

products_df = pd.DataFrame(products)

# -----------------------------
# Regions
# -----------------------------

regions_df = pd.DataFrame([
    ["R001", "North America"],
    ["R002", "Europe"],
    ["R003", "APAC"],
    ["R004", "LATAM"]
], columns=["Region_ID", "Region_Name"])

# -----------------------------
# SLA Targets
# -----------------------------

sla_df = pd.DataFrame([
    ["Low", 72],
    ["Medium", 48],
    ["High", 24],
    ["Critical", 8]
], columns=["Priority", "SLA_Hours"])

# -----------------------------
# Save Master Data
# -----------------------------

accounts_df.to_csv("data/accounts.csv", index=False)
agents_df.to_csv("data/agents.csv", index=False)
products_df.to_csv("data/products.csv", index=False)
regions_df.to_csv("data/regions.csv", index=False)
sla_df.to_csv("data/sla_targets.csv", index=False)

print("Master data generated successfully")

print(f"Accounts : {len(accounts_df)}")
print(f"Agents   : {len(agents_df)}")
print(f"Products : {len(products_df)}")
print(f"Regions  : {len(regions_df)}")
print(f"SLA Rows : {len(sla_df)}")