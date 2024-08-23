from login import app, db, User
from werkzeug.security import generate_password_hash

with app.app_context():
    # Create a hashed password
    hashed_password = generate_password_hash('123456')

    # Create a new user with a name
    new_user = User(name='Ronit kothari', email='ronitkothari@gmail.com', password=hashed_password)

    # Add and commit the new user to the database
    db.session.add(new_user)
    db.session.commit()
    print("Test user created")
