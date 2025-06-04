from flask import Flask, render_template, request, redirect, session, url_for
import mysql.connector

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Database connection
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='Mtp@2006',  # Update if needed
    database='voting_system'
)
cursor = conn.cursor(dictionary=True)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        cursor.execute("SELECT * FROM voters WHERE email = %s AND password = %s", (email, password))
        voter = cursor.fetchone()

        if voter:
            if voter['verified']:
                session['voter_id'] = voter['id']
                return redirect('/vote')
            else:
                return "Your account is not verified yet."
        else:
            return "Invalid credentials."

    return render_template('login.html')

@app.route('/vote', methods=['GET', 'POST'])
def vote():
    if 'voter_id' not in session:
        return redirect('/login')

    voter_id = session['voter_id']
    cursor.execute("SELECT has_voted FROM voters WHERE id = %s", (voter_id,))
    voter = cursor.fetchone()

    if voter['has_voted']:
        return render_template('success.html', message="You have already voted.")

    cursor.execute("SELECT * FROM candidates ORDER BY position")
    candidates = cursor.fetchall()

    if request.method == 'POST':
        for key in request.form:
            candidate_id = request.form[key]
            cursor.execute("SELECT election_id FROM candidates WHERE id = %s", (candidate_id,))
            election = cursor.fetchone()
            cursor.execute("INSERT INTO votes (voter_id, candidate_id, election_id) VALUES (%s, %s, %s)",
                           (voter_id, candidate_id, election['election_id']))
        conn.commit()
        return render_template('success.html', message="Thank you for voting!")

    return render_template('vote.html', candidates=candidates)

@app.route('/candidates')
def candidates():
    cursor.execute("SELECT * FROM candidates ORDER BY position")
    data = cursor.fetchall()
    return render_template('candidates.html', candidates=data)

@app.route('/results')
def result():
    cursor.execute("SELECT * FROM vote_summary")
    results = cursor.fetchall()
    return render_template('results.html', results=results)

# Admin Login
@app.route('/admin_login', methods=['GET', 'POST'])
def admin_login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor.execute("SELECT * FROM admins WHERE username = %s AND password = %s", (username, password))
        admin = cursor.fetchone()

        if admin:
            session['admin_id'] = admin['id']
            return redirect('/admin_reset')
        else:
            return "Invalid admin credentials."

    return render_template('admin_login.html')

# Admin Reset Votes
@app.route('/admin_reset', methods=['GET', 'POST'])
def admin_reset():
    if 'admin_id' not in session:
        return redirect('/admin_login')

    if request.method == 'POST':
        cursor.execute("DELETE FROM votes")
        cursor.execute("UPDATE voters SET has_voted = FALSE")
        cursor.execute("INSERT INTO logs (admin_id, action) VALUES (%s, 'Reset all votes')", (session['admin_id'],))
        conn.commit()
        return render_template('admin_reset.html', message="All votes have been reset.")

    return render_template('admin_reset.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)
