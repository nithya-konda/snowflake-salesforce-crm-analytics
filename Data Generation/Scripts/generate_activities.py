import pandas as pd, random
from faker import Faker

fake=Faker()
cases=pd.read_csv("data/cases.csv")

types=["Email Sent","Customer Reply","Internal Note","Escalation","Case Reopened","Resolution"]
activities=[]
aid=1

for cid in cases["Case_ID"]:
    for _ in range(random.randint(3,8)):
        activities.append({
            "Activity_ID":f"ACT{aid:07}",
            "Case_ID":cid,
            "Activity_Type":random.choice(types),
            "Activity_Date":fake.date_time_between(start_date='-2y', end_date='now')
        })
        aid += 1

pd.DataFrame(activities).to_csv("data/case_activities.csv", index=False)
print("Activities generated")
