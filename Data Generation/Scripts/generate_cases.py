import pandas as pd
import numpy as np
from faker import Faker
from datetime import timedelta
import random

fake=Faker()
random.seed(42)
np.random.seed(42)

accounts=pd.read_csv("data/accounts.csv")
agents=pd.read_csv("data/agents.csv")
products=pd.read_csv("data/products.csv")
regions=pd.read_csv("data/regions.csv")

priorities=["Low","Medium","High","Critical"]
weights=[0.35,0.40,0.20,0.05]
complaints=["Login Issue","Integration Failure","Performance","Billing","API Error","Security","Feature Request","Data Quality"]
sla={"Low":72,"Medium":48,"High":24,"Critical":8}

rows=[]
for i in range(1,50001):
    priority=np.random.choice(priorities,p=weights)
    created=fake.date_time_between(start_date='-2y', end_date='now')
    breach=np.random.choice([0,1],p=[0.85,0.15])
    hrs=random.randint(sla[priority]+1,sla[priority]*3) if breach else random.randint(1,sla[priority])
    rows.append({
        "Case_ID":f"CASE{i:05}",
        "Account_ID":random.choice(accounts["Account_ID"].tolist()),
        "Agent_ID":random.choice(agents["Agent_ID"].tolist()),
        "Product_ID":random.choice(products["Product_ID"].tolist()),
        "Region_ID":random.choice(regions["Region_ID"].tolist()),
        "Created_Date":created,
        "Resolved_Date":created+timedelta(hours=hrs),
        "Priority":priority,
        "Status":"Closed",
        "Complaint_Category":random.choice(complaints),
        "Resolution_Hours":hrs,
        "SLA_Hours":sla[priority],
        "SLA_Breach_Flag":breach,
        "Reopen_Flag":np.random.choice([0,1],p=[0.90,0.10]),
        "Escalation_Flag":np.random.choice([0,1],p=[0.95,0.05])
    })

pd.DataFrame(rows).to_csv("data/cases.csv", index=False)
print("Cases generated")
