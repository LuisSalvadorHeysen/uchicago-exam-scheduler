import pandas as pd

# Replace with your actual Excel filename
excel_filename = "SpringFinalExams2025.xlsx"
json_filename = "exams.json"

# Read the Excel file
df = pd.read_excel(excel_filename)

# Optional: Clean up column names (remove spaces)
df.columns = [col.strip() for col in df.columns]

# Save as JSON
df.to_json(json_filename, orient="records", indent=2)

print(f"Saved {json_filename} with {len(df)} records.")

