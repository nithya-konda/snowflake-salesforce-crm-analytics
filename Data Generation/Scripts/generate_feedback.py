import pandas as pd, numpy as np

cases=pd.read_csv("data/cases.csv")
feedback=[]

for i,row in cases.sample(frac=0.8, random_state=42).iterrows():
    rating=np.random.choice([1,2,3], p=[0.4,0.4,0.2]) if row["SLA_Breach_Flag"]==1 else np.random.choice([3,4,5], p=[0.2,0.4,0.4])
    feedback.append({
        "Feedback_ID":f"FB{i:06}",
        "Case_ID":row["Case_ID"],
        "Rating":int(rating)
    })

pd.DataFrame(feedback).to_csv("data/customer_feedback.csv", index=False)
print("Feedback generated")
