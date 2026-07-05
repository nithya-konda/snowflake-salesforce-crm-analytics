import pandas as pd
import numpy as np
from faker import Faker
import random, os

fake = Faker()
random.seed(42)
np.random.seed(42)

os.makedirs("data", exist_ok=True)

industries=["Technology","Manufacturing","Healthcare","Retail","Banking","Telecom"]
segments=["Enterprise","Mid-Market","SMB"]

accounts=[{
    "Account_ID":f"ACC{i:04}",
    "Account_Name":fake.company(),
    "Industry":random.choice(industries),
    "Segment":random.choice(segments),
    "Country":fake.country(),
    "Created_Date":fake.date_between(start_date='-3y', end_date='today')
} for i in range(1,1001)]

pd.DataFrame(accounts).to_csv("data/accounts.csv", index=False)

teams=["Technical Support","Product Support","Billing","Escalations"]
agents=[{
    "Agent_ID":f"AG{i:03}",
    "Agent_Name":fake.name(),
    "Team":random.choice(teams),
    "Manager":fake.name(),
    "Location":fake.country(),
    "Hire_Date":fake.date_between(start_date='-5y', end_date='today')
} for i in range(1,101)]

pd.DataFrame(agents).to_csv("data/agents.csv", index=False)

categories=["CRM","Analytics","Security","Integration","AI"]
products=[{
    "Product_ID":f"PROD{i:03}",
    "Product_Name":f"Product {i}",
    "Product_Category":random.choice(categories)
} for i in range(1,31)]

pd.DataFrame(products).to_csv("data/products.csv", index=False)

pd.DataFrame(
    [["R001","North America"],["R002","Europe"],["R003","APAC"],["R004","LATAM"]],
    columns=["Region_ID","Region_Name"]
).to_csv("data/regions.csv", index=False)

pd.DataFrame(
    [["Low",72],["Medium",48],["High",24],["Critical",8]],
    columns=["Priority","SLA_Hours"]
).to_csv("data/sla_targets.csv", index=False)

print("Master data generated")
