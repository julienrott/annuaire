# -*- coding: utf-8 -*-
from elixir import metadata, session
from flask import Flask, render_template
from annuaireapp.config import DefaultConfig

app = Flask(__name__)
app.config.from_object(DefaultConfig)

# DB configuration
metadata.bind = app.config['SQLALCHEMY_DATABASE_URI']
metadata.echo = True

session.configure(autoflush=False)

# DB shutdown
@app.after_request
def shutdown_session(response):
    session.remove()
    return response

# Default route
@app.route("/")
def index():
    return render_template('index.html')
    
from annuaireapp.views.persons import persons
from annuaireapp.views.teams import teams
app.register_blueprint(persons, url_prefix='/persons')
app.register_blueprint(teams, url_prefix='/teams')

if __name__ == '__main__': #pragma: no cover
    app.run()
