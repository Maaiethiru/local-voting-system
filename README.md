# 🗳️ Local Voting System

A secure, scalable, and user-friendly web application designed for conducting elections in local environments like schools, colleges, or organizations.

---

## 📌 Features

### 👤 Voter Functionality
- Email and password-based login for voters
- Cast vote for candidates grouped by position
- Only one vote allowed per voter
- Real-time success confirmation after voting

### 🛠️ Admin Controls
- Secure election head login
- Ability to reset all votes
- View live election results
- Admin actions are logged for transparency

### 📊 Results
- Real-time vote tally
- Results displayed by position and candidate
- Built-in vote summary view in MySQL

---

## 🛠️ Technologies Used

| Layer      | Tech Stack           |
|------------|----------------------|
| Frontend   | HTML, CSS (inline & customizable) |
| Backend    | Python (Flask micro-framework) |
| Database   | MySQL (with views, triggers, stored procedures) |
| Version Control | Git & GitHub |

---

## 🧠 Database Features Implemented

- ✅ **Constraints** – Primary key, unique email, foreign keys
- ✅ **Joins** – Multi-table queries to display results
- ✅ **Views** – Vote summary, pending voters
- ✅ **Triggers** – Automatically update has_voted after voting
- ✅ **Stored Procedures & Cursors** – Count votes
- ✅ **Set Operations & Subqueries** – Filter results and prevent duplicates

---

## 📂 Folder Structure

voting_system/
│
├── app.py # Main backend logic
├── config.py # DB connection config
├── database.sql # SQL schema and test data
├── templates/ # HTML templates
│ ├── home.html
│ ├── login.html
│ ├── vote.html
│ ├── result.html
│ ├── admin_login.html
│ └── admin_reset.html
└── static/ # CSS and optional images

---

## 🚀 How to Run the Project Locally

1. Clone the repository  
   `git clone https://github.com/Maaiethiru/local-voting-system`

2. Set up a MySQL database  
   - Import `database.sql` into your MySQL Workbench

3. Configure DB credentials in `config.py`

4. Run the Flask app  
   ```bash
   python app.py
