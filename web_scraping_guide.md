# WEB SCRAPING GUIDE - SakshamMatch

## Target Data Sources

### Primary Sources
1. **data.gov.in** - Open government data platform
2. **myscheme.gov.in** - Central scheme repository
3. **Ministry Websites:**
   - Ministry of MSME: https://msme.gov.in
   - Ministry of Social Justice: https://socialjustice.gov.in
   - Ministry of Rural Development: https://ruraldev.gov.in
   - NITI Aayog: https://niti.gov.in

4. **State MSME Portals:**
   - Karnataka: https://kassia.kar.nic.in
   - Tamil Nadu: https://msme.tn.gov.in
   - Maharashtra: https://msme.maharashtra.gov.in

5. **Bank Portals:**
   - MUDRA: https://mudra.org.in
   - Stand-Up India: https://standupmitra.in

---

## Scraping Implementation Steps

### Step 1: Install Dependencies
```bash
pip install scrapy beautifulsoup4 requests selenium playwright pandas
```

### Step 2: Analyze Target Pages
- Open target URL in Chrome
- Right-click → Inspect
- Identify scheme name, description, benefits, eligibility selectors
- Check if data is in tables, cards, or unstructured text
- Note if JavaScript is required to load data

### Step 3: Build Basic Scraper (BeautifulSoup)
```python
import requests
from bs4 import BeautifulSoup
import pandas as pd

url = "https://myscheme.gov.in/schemes"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')

# Extract scheme cards
schemes = []
for card in soup.select('.scheme-card'):
    name = card.select_one('.scheme-name').text.strip()
    ministry = card.select_one('.ministry').text.strip()
    description = card.select_one('.description').text.strip()

    schemes.append({
        'name': name,
        'ministry': ministry,
        'description': description
    })

# Save to CSV
df = pd.DataFrame(schemes)
df.to_csv('schemes.csv', index=False)
```

### Step 4: Handle JavaScript-Heavy Sites (Selenium)
```python
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

driver = webdriver.Chrome()
driver.get("https://standupmitra.in/schemes")

# Wait for page to load
wait = WebDriverWait(driver, 10)
wait.until(EC.presence_of_element_located((By.CLASS_NAME, "scheme-list")))

# Extract data
schemes = driver.find_elements(By.CLASS_NAME, "scheme-item")
for scheme in schemes:
    name = scheme.find_element(By.CLASS_NAME, "name").text

driver.close()
```

### Step 5: Data Cleaning (Pandas)
```python
import pandas as pd

df = pd.read_csv('schemes.csv')

# Remove duplicates
df = df.drop_duplicates(subset=['name', 'ministry'])

# Standardize field names
df.columns = df.columns.str.lower().str.replace(' ', '_')

# Fill missing values
df['benefits'] = df['benefits'].fillna('Not specified')

# Validate data types
df['benefit_amount'] = pd.to_numeric(df['benefit_amount'], errors='coerce')

# Save cleaned data
df.to_csv('schemes_cleaned.csv', index=False)
```

---

## Data to Extract

For each scheme, extract:
- **name**: Scheme name (string)
- **ministry**: Ministry/Department (string)
- **description**: Brief description (text)
- **benefits**: What benefits are provided (text)
- **benefit_amount**: Maximum benefit amount (decimal)
- **eligibility_rules**: JSON with age, category, income, etc.
- **documents_required**: List of required documents (JSON array)
- **application_link**: URL to apply (string)
- **source_url**: URL where data was scraped from (string)

---

## Best Practices

### 1. Respect Robots.txt
- Check `https://example.com/robots.txt`
- Respect `Disallow` rules
- Add delays between requests

### 2. Add Delays
```python
import time
time.sleep(2)  # 2 second delay between requests
```

### 3. Use Proxies (if rate-limited)
```python
proxies = {
    'http': 'http://proxy.example.com:8080',
    'https': 'https://proxy.example.com:8080'
}
response = requests.get(url, proxies=proxies)
```

### 4. Handle Errors
```python
try:
    response = requests.get(url, timeout=10)
    response.raise_for_status()
except requests.exceptions.RequestException as e:
    print(f"Error: {e}")
```

### 5. User-Agent
```python
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
}
response = requests.get(url, headers=headers)
```

---

## Sample Output

```json
{
  "name": "PMEGP",
  "ministry": "Ministry of MSME",
  "description": "Prime Minister's Employment Generation Programme",
  "benefits": "Subsidy up to 35% of project cost",
  "benefit_amount": 500000,
  "eligibility_rules": {
    "age_min": 18,
    "category": ["SC", "ST", "OBC", "General"],
    "business_type": ["Manufacturing", "Service"]
  },
  "documents_required": ["Aadhaar Card", "Caste Certificate", "Income Certificate"],
  "application_link": "https://pmegp.msme.gov.in/",
  "source_url": "https://pmegp.msme.gov.in/Home/About"
}
```

---

## Manual Verification

After scraping, manually verify 10-20 schemes:
- Check name accuracy
- Check ministry accuracy
- Check benefits accuracy
- Check eligibility rules
- Check application links
- Fix scraper logic if needed

---

**Scraping Complete!**

Load data into PostgreSQL and verify before using in matching engine.
