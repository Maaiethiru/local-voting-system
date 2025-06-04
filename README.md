Local Voting System - README
Project Overview
The Local Voting System is a secure and user-friendly web application designed to conduct elections in small-scale environments such as schools, colleges, or organizations. It allows voters to log in, cast their vote for candidates grouped by position, and view real-time results. An election head (admin) can log in separately to reset votes or monitor the results.
Technologies Used
- Backend: Python (Flask)
- Frontend: HTML and CSS
- Database: MySQL
Features
- Voter login and authentication
- Role-based access for admin
- Vote casting restricted to one vote per user
- Real-time vote tally using views
- Admin-controlled reset option
- Secure session management
- Database constraints, views, triggers, joins, and stored procedures
Project Structure
voting_system/
├── app.py            # Backend logic
├── config.py         # DB configuration
├── database.sql      # MySQL schema and test data
├── templates/        # HTML templates
│   ├── home.html
│   ├── login.html
│   ├── vote.html
│   ├── result.html
│   ├── admin_login.html
│   └── admin_reset.html
└── static/           # Optional CSS files
How to Run Locally
1. Clone the repository:
   git clone https://github.com/Maaiethiru/local-voting-system
2. Import database.sql into your MySQL instance.
3. Configure your database credentials in config.py.
4. Run the application:
   python app.py
5. Open a browser and navigate to:
   http://127.0.0.1:5000
Login Credentials
Admin:
- Email: election_head@srmist.edu.in
- Password: admin123
Voter (Sample):
- Email: vk7915@srmist.edu.in
- Password: varshat123
Future Enhancements
- OTP-based voter verification
- Mobile app integration
- Graphical dashboard with live stats
- Blockchain-based vote recording
- Support for multiple concurrent elections
Developed By
Maaie Thiru Prakash
B.Tech CSE (AIML), SRM University
