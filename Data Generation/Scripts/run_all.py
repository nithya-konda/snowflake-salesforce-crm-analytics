import subprocess, sys

for f in [
    "scripts/generate_master_data.py",
    "scripts/generate_cases.py",
    "scripts/generate_activities.py",
    "scripts/generate_feedback.py"
]:
    subprocess.check_call([sys.executable, f])

print("All datasets generated successfully")
